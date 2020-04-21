package src;

import src.ent.Paddle;

class ClientPaddle extends Paddle {

	public function new(uid = 0) {
		super(300, 300, Const.ENTITIES.P1, uid);
		init();
	}

	override function init() {
		net = Network.inst;
		spr = new h2d.Bitmap(h2d.Tile.fromColor(0xffffff, 2 * Const.PADDLE_XR, 2 * Const.PADDLE_YR), net.s2d);
		net.log("Init " + this);
		enableReplication = true;
	}

	override function alive() {
		init();
		// refresh bmp
		spr.x = xx;
		spr.y = yy;
		if (uid == net.uid) {
			net.clientPaddle = this;
			net.host.self.ownerObject = this;
		}
	}
}

// PARAM=-lib hxbit
class Network extends hxd.App {
	// Hamachi IP: 25.3.244.90
	static var HOST = "127.0.0.1";
	static var PORT = 6676;

	public var host:hxd.net.SocketHost;
	public var event:hxd.WaitEvent;
	public var uid:Int;
	public var clientPaddle:ClientPaddle;

	override function init() {
		event = new hxd.WaitEvent();
		host = new hxd.net.SocketHost();
		host.setLogger(function(msg) log(msg));

		if (!hxd.net.Socket.ALLOW_BIND) {
			#if flash
			log("Using network with flash requires compiling with -lib air3 and running through AIR");
			#else
			log("Server not allowed on this platform");
			#end
		}

		try {
			host.wait(HOST, PORT, function(c) {
				log("Client Connected");
			});
			host.onMessage = function(p, uid:Int) {
				log("Client identified (" + uid + ")");
				var paddleClient = new ClientPaddle(uid);
				p.ownerObject = paddleClient;
				p.sync();
			};
			log("Server Started");

			start();
		} catch (e:Dynamic) {
			log(e);
			// we could not start the server
			log("Connecting");

			uid = 1 + Std.random(1000);
			host.connect(HOST, PORT, function(b) {
				if (!b) {
					log("Failed to connect to server");
					return;
				}
				log("Connected to server");
				host.sendMessage(uid);
			});
		}
	}

	public function log(s:String, ?pos:haxe.PosInfos) {
		pos.fileName = (host.isAuth ? "[S]" : "[C]") + " " + pos.fileName;
		haxe.Log.trace(s, pos);
	}

	function start() {
		clientPaddle = new ClientPaddle();
		log("Live");
		host.makeAlive();
	}

	override function update(dt:Float) {
		event.update(dt);
		if (clientPaddle != null) {
			clientPaddle.update(dt);
			// clientPaddle.update(dt);
		}
		host.flush();
	}

	public static var inst:Network;

	static function main() {
		#if air3
		@:privateAccess hxd.Stage.getInstance().multipleWindowsSupport = true;
		#end
		inst = new Network();
	}
}
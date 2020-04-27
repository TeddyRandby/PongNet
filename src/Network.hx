package src;

import src.ent.Paddle;
import src.ent.Ball;
import haxe.Timer;
import src.renderer.Engine;

// PARAM=-lib hxbit
class Network extends hxd.App {
	// 25.4.49.141
	// Hamachi IP: 25.3.244.90
	static var HOST = "25.3.244.90";
	// Local host IP
	// static var HOST = "127.0.0.1";
	static var PORT = 6676;

	public var host:hxd.net.SocketHost;
	public var event:hxd.WaitEvent;
	public var uid:Int;
	public var clientPaddle:Paddle;
	public var ball:Ball;
	public var wx:Int;
	public var wy:Int;
	public var p1tf:Score;
	public var p2tf:Score;
	public var eng:Engine;
	public var onUpdate: Array<Float->Void> = [];

	override function init() {
		event = new hxd.WaitEvent();
		host = new hxd.net.SocketHost();
		eng = new Engine(s2d);

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
				var paddleClient = new Paddle(Const.ENTITIES.P2, uid);
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
		clientPaddle = new Paddle(Const.ENTITIES.P1);
		

		// p1tf = new Score(Const.ENTITIES.GOAL1, s2d);

		// p2tf = new Score(Const.ENTITIES.GOAL2, s2d);

		// ball = new Ball(Math.floor(wx / 2), Math.floor(wy / 2), s2d, onGoal, Const.ENTITIES.BALL);

		log("Live");
		host.makeAlive();
	}

	override function update(dt:Float) {
		event.update(dt);

		for ( func in onUpdate) {
			func(dt);
		}

		// if (ball != null) {
		// 	ball.update(dt, [clientPaddle]);
		// }
		host.flush();
	}

	public static var inst:Network;

	static function main() {
		#if air3
		@:privateAccess hxd.Stage.getInstance().multipleWindowsSupport = true;
		#end
		hxd.Res.initEmbed();
		inst = new Network();
	}
}

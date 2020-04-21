package src;

import src.ent.Paddle;

class ClientPaddle extends Paddle {

	@:s var color : Int;

	var net : Network;

	public function new( uid=0 ) {
		super(300,300,Const.ENTITIES.P1,uid);
		init();
		this.color = color;
	}

	function init() {
		net = Network.inst;
		spr = new h2d.Bitmap(h2d.Tile.fromColor(0xffffff, 2 * Const.PADDLE_XR, 2 * Const.PADDLE_YR),net.s2d);
		net.log("Init "+this);
		enableReplication = true;
	}

	override public function alive() {
		init();
		// refresh bmp
		spr.x = xx;
		spr.y = yy;
		if( uid == net.uid ) {
			net.clientPaddle = this;
			net.host.self.ownerObject = this;
		}
	}
}

//PARAM=-lib hxbit
class Network extends hxd.App {

	static var HOST = "127.0.0.1";
	static var PORT = 6676;

	public var host : hxd.net.SocketHost;
	public var event : hxd.WaitEvent;
	public var uid : Int;
	public var clientPaddle: ClientPaddle;

	override function init() {
		event = new hxd.WaitEvent();
		host = new hxd.net.SocketHost();
		host.setLogger(function(msg) log(msg));

		if( !hxd.net.Socket.ALLOW_BIND ) {
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
			host.onMessage = function(p,uid:Int) {
				log("Client identified ("+uid+")");
				var paddleClient = new Paddle(Const.PADDLE_CUSION + Const.PADDLE_XR, Math.floor(300), Const.ENTITIES.P2,uid);
				p.ownerObject = paddleClient;
				p.sync();
			};
			log("Server Started");

			start();
		} catch( e : Dynamic ) {

			log(e);
			// we could not start the server
			log("Connecting");

			uid = 1 + Std.random(1000);
			host.connect(HOST, PORT, function(b) {
				if( !b ) {
					log("Failed to connect to server");
					return;
				}
				log("Connected to server");
				host.sendMessage(uid);
			});
		}
	}

	public function log( s : String, ?pos : haxe.PosInfos ) {
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
		if( clientPaddle != null ) {
			clientPaddle.update(dt);
		}
		host.flush();
	}

	public static var inst : Network;
	static function main() {
		#if air3
		@:privateAccess hxd.Stage.getInstance().multipleWindowsSupport = true;
		#end
		inst = new Network();
	}

}

// package src;

// import haxe.Timer;
// import h2d.Font;
// import src.ent.Paddle;
// import src.ent.Ball;
// import src.ent.Entity;
// import src.ent.Goal;
// import src.Score;
// import hxbit.Serializer;
// import hxbit.NetworkHost.NetworkClient;
// import hxd.net.SocketHost;

// class Server extends hxd.App {
    
// 	static var HOST = "127.0.0.1";
// 	static var PORT = 65432;

// 	public var host : hxd.net.SocketHost;
// 	public var event : hxd.WaitEvent;
// 	public var uid : Int;
// 	public var p1 : Paddle;

// 	override function init() {
// 		event = new hxd.WaitEvent();
// 		host = new hxd.net.SocketHost();
// 		host.setLogger(function(msg) log(msg));

// 		if( !hxd.net.Socket.ALLOW_BIND ) {
// 			#if flash
// 			log("Using network with flash requires compiling with -lib air3 and running through AIR");
// 			#else
// 			log("Server not allowed on this platform");
// 			#end
// 		}

// 		try {
// 			host.wait(HOST, PORT, function(c) {
// 				log("Client Connected");
// 			});
// 			host.onMessage = function(p,uid:Int) {
// 				log("Client identified ("+uid+")");
// 				var paddleClient = new Paddle(Const.PADDLE_CUSION + Const.PADDLE_XR, Math.floor(500 / 2), s2d, Const.ENTITIES.P1,uid);
// 				p.ownerObject = paddleClient;
// 				p.sync();
// 			};
// 			log("Server Started");

// 			// start();
// 		} catch( e : Dynamic ) {

// 			// we could not start the server
// 			log("Connecting");

// 			uid = 1 + Std.random(1000);
// 			host.connect(HOST, PORT, function(b) {
// 				if( !b ) {
// 					log("Failed to connect to server");
// 					return;
// 				}
// 				log("Connected to server");
// 				host.sendMessage(uid);
// 			});
// 		}
// 	}

// 	public function log( s : String, ?pos : haxe.PosInfos ) {
// 		pos.fileName = (host.isAuth ? "[S]" : "[C]") + " " + pos.fileName;
// 		haxe.Log.trace(s, pos);
// 	}

// 	// function start() {
// 	// 	p1 =  new Paddle(Const.PADDLE_CUSION + Const.PADDLE_XR, Math.floor(500), s2d, Const.ENTITIES.P1);
// 	// 	log("Live");
// 	// 	host.makeAlive();
// 	// }

// 	override function update(dt:Float) {
// 		event.update(dt);
// 		if( p1 != null ) {
//             p1.update(dt,p1.preUpdateTask);
// 		}
// 		host.flush();
// 	}

// 	public static var inst : Server;
// 	static function main() {
// 		#if air3
// 		@:privateAccess hxd.Stage.getInstance().multipleWindowsSupport = true;
// 		#end
// 		inst = new Server();
//     }
    
// 	// static function main() {
// 	// 	hxd.Res.initEmbed();
// 	// 	new Server();
// 	// }

// 	// var p1:Paddle;
// 	// var p2:Paddle;
// 	// var ball:Ball;
// 	// var goal1:Goal;
// 	// var goal2:Goal;
// 	// var entities:Array<Entity>;

// 	// var p1tf:Score;
// 	// var p2tf:Score;

// 	// var font:Font;
// 	// var wx:Int;
// 	// var wy:Int;

// 	// var connection:Bool;

// 	// override function init() {
// 	// 	var HOST = '127.0.0.1'; // Standard loopback interface address (localhost)
// 	// 	var PORT = 65432; // Port to listen on (non-privileged ports are > 1023)
// 	// 	var s = new Serializer();

// 	// 	var hostsock = new ClientHandler((clpck)->{p1.dx=clpck.dx; p1.dy=clpck.dy;});
// 	// 	hostsock.wait(HOST, PORT, (client) -> {
// 	// 		var handshake = new ServerPacket();
// 	// 		s.serialize(handshake);
// 	// 		hostsock.sendMessage(handshake, client);
// 	// 		connection = true;
// 	// 		onClient();
// 	// 	});
// 	// }

// 	// override function update(dt:Float) {
// 	// 	if (connection) {
// 	// 		p2.update(dt, p2.preUpdateTask);
// 	// 		ball.update(dt, ball.preUpdateTask, entities, ball.postUpdateTask);
// 	// 	}
// 	// }

// 	// private function onClient() {
// 	// 	wx = hxd.Window.getInstance().width;
// 	// 	wy = hxd.Window.getInstance().height;

// 	// 	// Create the score trackers
// 	// 	font = hxd.Res.font.toFont();

// 	// 	p1tf = new Score(Math.floor(wx / 4), Math.floor(wy / 2), font, s2d);

// 	// 	p2tf = new Score(Math.floor(3 * wx / 4), Math.floor(wy / 2), font, s2d);

// 	// 	// Register game objects
// 	// 	p1 = new Paddle(Const.PADDLE_CUSION + Const.PADDLE_XR, Math.floor(wy / 2), s2d, Const.ENTITIES.P1);
// 	// 	p2 = new Paddle(wx - Const.PADDLE_CUSION - Const.PADDLE_XR, Math.floor(wy / 2), s2d, Const.ENTITIES.P2);

// 	// 	ball = new Ball(Math.floor(wx / 2), Math.floor(wy / 2), s2d, onGoal, Const.ENTITIES.BALL);
// 	// 	goal1 = new Goal(Const.GOAL_WR, Math.floor(wy / 2), s2d, Const.ENTITIES.GOAL1);
// 	// 	goal2 = new Goal(wx - Const.GOAL_WR, Math.floor(wy / 2), s2d, Const.ENTITIES.GOAL2);

// 	// 	// Register entities for collision with ball
// 	// 	entities = [p1, p2, goal1, goal2];
// 	// }

// 	// private function onGoal(g:Goal) {
// 	// 	switch (g.type) {
// 	// 		case Const.ENTITIES.GOAL1:
// 	// 			p2tf.addScore();
// 	// 		case Const.ENTITIES.GOAL2:
// 	// 			p1tf.addScore();
// 	// 		default:
// 	// 			return;
// 	// 	}

// 	// 	// After 1 second, create a new ball.
// 	// 	Timer.delay(() -> this.ball = new Ball(Math.floor(wx / 2), Math.floor(wy / 2), s2d, onGoal, Const.ENTITIES.BALL), 1000);
// 	// }
// }

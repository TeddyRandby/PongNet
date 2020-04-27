package src.ent;

import hxbit.NetworkSerializable;
import hxd.Key;
import src.ent.Entity;
import src.Const;

class Paddle implements NetworkSerializable {
	@:s public var type:Const.ENTITIES;
	@:s public var uid:Int;
	public var rid:Int;
	@:s public var x(default, set):Float;
	@:s public var y(default, set):Float;
	public var friction:Float = .4;
	public var dy:Float;

	var net:Network;

	function init() {
		net = Network.inst;
		rid = net.eng.registerPaddle(x, y);
		net.log("Init " + this);
		enableReplication = true;
		if (net.uid == uid) {
			net.clientPaddle = this;
			net.host.self.ownerObject = this;
			var wx = hxd.Window.getInstance().width;
			var wy = hxd.Window.getInstance().height;
			switch type {
				case P1:
					x = Const.PADDLE_CUSION;
					y = Math.floor(wy / 2);
				case P2:
					x = wx - Const.PADDLE_CUSION;
					y = Math.floor(wy / 2);
				default:
					x = wx - Const.PADDLE_CUSION;
					y = Math.floor(wy / 2);
			}
		}
		net.eng.setObject(x, y, rid);
		net.onUpdate.push(update);
	}

	public function alive() {
		init();
	}

	function set_x(v:Float) {
		if (v == x)
			return v;
		if (net != null)
			net.eng.setObject(v, y, rid);
		return this.x = v;
	}

	function set_y(v:Float) {
		if (net != null)
			net.eng.setObject(x, v, rid);
		return this.y = v;
	}

	public function networkAllow(op:hxbit.NetworkSerializable.Operation, propId:Int, client:hxbit.NetworkSerializable):Bool {
		return client == this;
	}

	public function toString() {
		return "Paddle " + type + (enableReplication ? ":ALIVE" : "");
	}

	public function new(type:Const.ENTITIES, uid = 0) {
		this.type = type;
		this.uid = uid;
		init();
	}

	public function preUpdateTask(?data:Any) {
		var upkey:Int;
		var downkey:Int;
		var leftkey:Int;
		var rightkey:Int;
		upkey = Key.W;
		downkey = Key.S;
		leftkey = Key.A;
		rightkey = Key.D;
		if (Key.isDown(upkey)) {
			addVel(upkey);
		}
		if (Key.isDown(downkey)) {
			addVel(downkey);
		}
	}

	public function update(dt:Float) {
		if (net.clientPaddle == this) {
			preUpdateTask();
			dy *= Math.pow(friction, dt);
			y += dy * dt / 16;
			net.eng.setObject(x, y, rid);
		} else {
			net.eng.setObject(x, y, rid);
		}
	}

	public function addVel(key:Int) {
		switch key {
			case key = Key.UP:
				this.dy += (Const.PADDLE_SPEED * -1);
			case key = Key.W:
				this.dy += (Const.PADDLE_SPEED * -1);
			case key = Key.DOWN:
				this.dy += (Const.PADDLE_SPEED);
			case key = Key.S:
				this.dy += (Const.PADDLE_SPEED);
		}
	}
}

package src.ent;

import h2d.Bitmap;

class Entity {
	// Circular hitbox from center:
	public var cx:Int;
	public var cy:Int;
	public var xr:Float;
	public var yr:Float;

	// Movement and Collision
	public var dx:Float;
	public var dy:Float;
	public var friction:Float;
	public var hitH:Float;
	public var hitW:Float;

	public var name = "Entity";

	public function new(cx:Int, cy:Int, wr:Int, hr:Int, uid = 0) {
		// Center and center ratios for physics.

		this.dx = 0;
		this.dy = 0;

		// Physics related constants
		this.hitH = hr;
		this.hitW = wr;
		this.friction = Const.FRICTION;

	}

	private function move(dt:Float) {
		xr += dx * dt / 16;
		dx *= Math.pow(friction, dt);
		while (xr < 0) {
			cx--;
			xr++;
		}
		while (xr > 1) {
			cx++;
			xr--;
		}

		dy *= Math.pow(friction, dt);
		yr += dy * dt / 16;

		while (yr < 0) {
			cy--;
			yr++;
		}
		while (yr > 1) {
			cy++;
			yr--;
		}
	}
	
	public function preUpdateTask(?data:Any) {}

	public function postUpdateTask(?data:Any) {}

	public function update(dt:Float, ?data:Any) {
		preUpdateTask(data);

		move(dt);

		postUpdateTask(data);
	}
}

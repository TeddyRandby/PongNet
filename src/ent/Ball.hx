package src.ent;

import h3d.parts.Data.BlendMode;
import hxbit.NetworkSerializable;
import haxe.Timer;
import hxd.Window;
import h2d.Bitmap;

class Ball extends Entity implements NetworkSerializable{
	public var type:Const.ENTITIES;

	var onGoal:Const.ENTITIES->Void;
	var prevCollision:BlendMode;
	var canCollide:Bool;
	var net: Network;
	var rid: Int;
	@:s var x: Float;
	@:s var y: Float;

	public function new(cx:Int, cy:Int, s2d:h2d.Object, onGoal:Const.ENTITIES->Void, type:Const.ENTITIES) {
		var r = Const.BALL_R;
		init();
		super(cx, cy, r, r, 10);
		this.onGoal = onGoal;
		this.type = type;
		this.dx = Const.BALL_MAX_SPEED * (Math.random()) - (Const.BALL_MAX_SPEED / 2);
		this.dy = Const.BALL_MAX_SPEED * (Math.random()) - (Const.BALL_MAX_SPEED / 2);
		cx = Math.floor(hxd.Window.getInstance().width / 2);
		cy = Math.floor(hxd.Window.getInstance().height / 2);
		x = cx + xr;
		y = cy + xr;
		this.prevCollision = null;
		this.canCollide = true;
		this.friction = 1;
		net.onUpdate.push(update);

	}
	
	public function alive() {
		init();
	}

	public function init() {
		net = Network.inst;
		net.log("init " + this);

		net.onUpdate.push(clientUpdate);
		rid = net.eng.registerBall(x,y);

		enableReplication = true;
	}

	private function collides(e:Paddle) {
		// Fast distance check

		if (e!=null && Math.abs(x - e.x) <= 100) {
			// Real distance check
			var xdist = Math.abs(e.x - x );
			var ydist = Math.abs(e.y - y );

			if (xdist <= Const.PADDLE_XR + this.hitW && ydist <= Const.PADDLE_YR + this.hitH) {
				Timer.delay(() -> canCollide = true, 300);
				canCollide = false;

				// Update previous collision
				// There was no goal: hit the ball back slightly faster.
				dx *= -1.2;
				dy *= 1.2;
				// trace("new dx: " + dx + " new dy: " + dy);

				return true;
			}
		}
		return false;
	}

	override public function preUpdateTask(?data:Any) {
		// Check for collisions before moving.
		if (!Std.is(data, Array))
			return;
		for (entity in (data : Array<Paddle>)) {
			if (canCollide )
				if (collides(entity))
					break;
		}
	}

	public function clientUpdate(dt:Float,?data:Any){
		// Update drawing the ball
		net.eng.setObject(x,y,rid);
	}

	override public function postUpdateTask(?data:Any) {
		// After moving, keep the ball on screen.
		if (cx + Const.BALL_R > Window.getInstance().width || cx - Const.BALL_R < 0) {
			dx *= -1;
		}
		if (cy + Const.BALL_R > Window.getInstance().height || cy - Const.BALL_R < 0) {
			dy *= -1;
		}

		// Keep the ball's speed capped.
		if (Math.abs(dx) > Const.BALL_MAX_SPEED) {
			if (dx < 0)
				dx = Const.BALL_MAX_SPEED * -1
			else
				dx = Const.BALL_MAX_SPEED;
		}

		if (Math.abs(dy) > Const.BALL_MAX_SPEED) {
			if (dy < 0)
				dy = Const.BALL_MAX_SPEED * -1;
			else
				dy = Const.BALL_MAX_SPEED;
		}

		// Handle scoring
		if (cx + hitW > hxd.Window.getInstance().width - Const.GOAL_WR  ) {
			onGoal(Const.ENTITIES.GOAL1);
		} else if (cx - hitW < Const.GOAL_WR) {
			onGoal(Const.ENTITIES.GOAL2);
		}

		x = cx + xr - hitW;
		y = cy + yr - hitH;
	}

}

package src.ent;

import h2d.Bitmap;

class Entity {

	// Circular hitbox from center:
	public var cx:Int;
	public var cy:Int;
	public var xr:Float;
	public var yr:Float;
	
	// Coordinates for drawing, top left corner of hitbox.
	public var xx: Float;
	public var yy: Float;

	// Movement.
	public var dx:Float;
	public var dy:Float;
	public var friction: Float;

	public var hitH: Float;
	public var hitW: Float;

	public var spr:Bitmap;
	public var name: String;

	public function new(cx:Int, cy:Int, wr:Int, hr:Int, spr: Bitmap) {
		// Center and center ratios for physics.
		this.cx = cx;
		this.cy = cy;
		this.xr = 0;
		this.yr = 0;

		this.dx = 0;
		this.dy = 0;

		// Physics related constants
		this.hitH = hr;
		this.hitW = wr;
		this.friction = Const.FRICTION;
		xx = (cx + xr) - hitW;
		yy = (cy + yr) - hitH;


		this.spr = spr;
		this.name = "Entity";

		// Draw at cx,cy
        spr.x = xx;
		spr.y = yy; 
	}

	private function move(dt: Float){
		xr += dx*dt/16;
		dx *= Math.pow(friction, dt);
		while( xr<0 ) {
			cx--;
			xr++;
		}
		while( xr>1 ) {
			cx++;
			xr--;
		}

		dy *= Math.pow(friction, dt);
		yr += dy*dt/16;

		while( yr<0 ) {
			cy--;
			yr++;
		}
		while( yr>1 ) {
			cy++;
			yr--;
        }

		xx = (xr + cx) - hitW;
		yy = (yr + cy) - hitH;

        spr.x = xx;
		spr.y = yy; 
	}

	public function update(dt: Float, ?preUpdateTask:Any->Void, ?preData : Any, ?postUpdateTask:Any->Void, ?postData : Any) {
		if(preUpdateTask != null) preUpdateTask(preData);
		
		move(dt);

        if(postUpdateTask != null) postUpdateTask(postData);
	}

	public function toString(){
		return(this.name);
	}
}

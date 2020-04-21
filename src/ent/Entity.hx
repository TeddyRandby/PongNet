package src.ent;

import h2d.Bitmap;

class Entity implements hxbit.NetworkSerializable 	{

	// Circular hitbox from center:
	@:s public var cx:Int;
	@:s public var cy:Int;
	@:s public var xr:Float;
	@:s public var yr:Float;
	
	// Coordinates for drawing, top left corner of hitbox.
	@:s public var xx: Float;
	@:s public var yy: Float;

	// Movement.
	@:s public var dx:Float;
	@:s public var dy:Float;
	@:s public var friction: Float;

	@:s public var hitH: Float;
	@:s public var hitW: Float;

     public var spr:Bitmap;
	@:s public var name: String;

	@:s public var uid : Int;

	public function new(cx:Int, cy:Int, wr:Int, hr:Int, uid=0) {
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

		this.name = "Entity";

		// Draw at cx,cy
        // spr.x = xx;
		// spr.y = yy; 
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

	public function preUpdateTask(?data: Any){

	}

	public function postUpdateTask(?data: Any){
		
	}

	public function update(dt: Float,  ?data : Any) {
		preUpdateTask(data);
		
		move(dt);

        postUpdateTask(data);
	}



	public function toString(){
		return(this.name);
	}

	public function networkAllow( op : hxbit.NetworkSerializable.Operation, propId : Int, client : hxbit.NetworkSerializable ) : Bool {
		return client == this;
	}

	public function set_x( v : Float ) {
		if( v == xx ) return v;
		if( spr != null ) {
			spr.x = v;
			cx = Math.floor(xx + hitW);
			xr = xx - cx;
		}
		return this.xx = v;
	}

	public function set_y( v : Float ) {
		if( spr != null ) {
			spr.x = v;
			cy = Math.floor(yy + hitH);
			yr = yy - cy;
		}
		return this.yy = v;
	}
}

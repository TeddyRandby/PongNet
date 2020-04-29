package src.renderer;

import h2d.Tile;
import h2d.Bitmap;

class Engine {
	private var s2d:h2d.Object;
	private var counter:Int = -1;
	private var objects:Array<RenderObject> = [];

	public function new(s2d:h2d.Object) {
		this.s2d = s2d;
	}

	public function registerPaddle(x, y, ?rid: Int):Int {
		if(rid !=null) {
			objects[rid] = new RenderObject(Tile.fromColor(0xFFFFFF, Const.PADDLE_XR * 2, Const.PADDLE_YR * 2), s2d);
			setObject(x, y, rid);
			return rid;
		} else {
		objects.push(new RenderObject(Tile.fromColor(0xFFFFFF, Const.PADDLE_XR * 2, Const.PADDLE_YR * 2), s2d));
		counter++;
		setObject(x, y, counter);
		return counter;
		}
	}

	public function registerBall(x, y):Int {
		objects.push(new RenderObject(Tile.fromColor(0x0000FF, Const.BALL_R * 2, Const.BALL_R * 2), s2d));
		counter++;
		setObject(x, y, counter);
		return counter;
	}

	public function setObject(x:Float, y:Float, id:Int) {
		objects[id].spr.x = x;
		objects[id].spr.y = y;
	}

	public function deleteObject(id:Int) {
		objects[id].spr.parent.removeChild(objects[id].spr);
		objects[id] = null;
	}
}

class RenderObject {

	public var spr:h2d.Bitmap;

	public function new(tile, s2d) {
		spr = new Bitmap(tile, s2d);
	}
}

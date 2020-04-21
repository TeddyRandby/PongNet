package src.ent;

import h2d.Object;
import hxd.Key;
import src.ent.Entity;
import src.Const;

class Paddle extends Entity {
    
    public var type : Const.ENTITIES;

    public function new(cx:Int,cy:Int, s2d: h2d.Object, type : Const.ENTITIES){
        var spr = new h2d.Bitmap(h2d.Tile.fromColor(0xffffff, 2 * Const.PADDLE_XR, 2 * Const.PADDLE_YR),s2d);
        super(cx,cy,Const.PADDLE_XR,Const.PADDLE_YR,spr);
        this.type = type;
        this.name = "" + this.type;
    }

    public function preUpdateTask(data : Any){
        var upkey : Int;
        var downkey : Int;
        var leftkey : Int;
        var rightkey : Int;
        switch type {
            case Const.ENTITIES.P1:
                upkey = Key.W;
                downkey = Key.S;
                leftkey = Key.A;
                rightkey = Key.D;
            case Const.ENTITIES.P2:
                upkey = Key.UP;
                downkey = Key.DOWN;
                leftkey = Key.LEFT;
                rightkey = Key.RIGHT;
            default: 
                upkey = Key.UP;
                downkey = Key.DOWN;
                leftkey = Key.LEFT;
                rightkey = Key.RIGHT;
        }
        if( Key.isDown(upkey) ) { this.dy+=(Const.PADDLE_SPEED * -1); }
        if( Key.isDown(downkey) ) { this.dy+=(Const.PADDLE_SPEED); }
        // if( Key.isDown(leftkey) ) { this.dx+=(Const.PADDLE_SPEED * -1); }
        // if( Key.isDown(rightkey) ) { this.dx+=(Const.PADDLE_SPEED); }

    }
}
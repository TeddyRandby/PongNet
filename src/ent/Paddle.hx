package src.ent;

import h2d.Object;
import hxd.Key;
import src.ent.Entity;
import src.Const;

class Paddle extends Entity {
    
    public var type : Const.ENTITIES;

    public function new(cx:Int,cy:Int, type : Const.ENTITIES, uid=0){
        super(cx,cy,Const.PADDLE_XR,Const.PADDLE_YR);
        this.type = type;
        this.name = "" + this.type;
    }

    public override function preUpdateTask(?data : Any){
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
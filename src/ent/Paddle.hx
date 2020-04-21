package src.ent;

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
        if( Key.isDown(upkey) ) { addVel(upkey);}
        if( Key.isDown(downkey) ) { addVel(downkey); }
    }

    @:rpc(immediate) private function addVel(key: Int){
        switch key {
            case key = Key.UP:
                this.dy+=(Const.PADDLE_SPEED * -1);
            case key = Key.W:
                this.dy+=(Const.PADDLE_SPEED * -1);
            case key = Key.DOWN:
                this.dy+=(Const.PADDLE_SPEED);
            case key = Key.S:
                this.dy+=(Const.PADDLE_SPEED);
        }
    }

}
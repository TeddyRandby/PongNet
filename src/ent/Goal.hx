package src.ent;

class Goal extends Entity{

    public var type : Const.ENTITIES;
    var h : Int;

    public function new(cx:Int,cy:Int, s2d: h2d.Object, type : Const.ENTITIES){
        h = hxd.Window.getInstance().height;
        var spr = new h2d.Bitmap(h2d.Tile.fromColor(0xffffff, 2*Const.GOAL_WR, h),s2d);
        super(cx,cy,Const.GOAL_WR,Math.floor(h/2),spr);
        this.type = type;
        this.name = "" + this.type;
    }

}
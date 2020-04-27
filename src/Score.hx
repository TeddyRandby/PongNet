package src;

import hxbit.NetworkSerializable;
import h2d.Text;

class Score implements hxbit.NetworkSerializable {

    var tf : Text;
    var score: Int;

    public function new(type: Const.ENTITIES, s2d: h2d.Object) {
        var wx = hxd.Window.getInstance().width;
        var wy = hxd.Window.getInstance().height;
        var f = hxd.Res.font.toFont();
        var cx: Int;
        var cy: Int;
        switch type{
            case GOAL1:
                cx = Const.PADDLE_CUSION*3;
                cy = Math.floor(wy/2);
            case GOAL2:
                cx = wx - Const.PADDLE_CUSION*3;
                cy = Math.floor(wy/2);
            default:
                cx = wx - Const.PADDLE_CUSION*3;
                cy = Math.floor(wy/2);
        }
        var scale = 8;
        tf = new h2d.Text(f, s2d);
        tf.textColor = 0xFFFFFF;
        tf.alpha = 0.6;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFFFFF0, alpha : 0.4 };
        tf.scale(scale);
        tf.text = "0";
        score = 0;
        tf.x = cx - (tf.textWidth  * scale / 2);
        tf.y = cy - (tf.textHeight * scale / 2);

        enableReplication = true;
    }

    public function addScore(){
        score++;
        tf.text = "" + score;
    }
}
package src;

import hxbit.NetworkSerializable;
import h2d.Text;

class Score implements hxbit.NetworkSerializable {
	var tf:Text;

	@:s public var score(default,set):Int;

	var net:Network;
	@:s var type:Const.ENTITIES;
	var wx:Int;
	var wy:Int;

	public function new(type:Const.ENTITIES) {

		this.type = type;
		score = 0;
        enableReplication = true;
        init();
	}

	public function alive() {
		init();
    }
    
    public function set_score(val:Int){
        if(tf!=null){
            tf.text = "" + val;
            score = val;
        }
        return score;
    }

	public function init() {
        wx = hxd.Window.getInstance().width;
		wy = hxd.Window.getInstance().height;
		var scale = 8;
		net = Network.inst;
		var f = hxd.Res.font.toFont();
		tf = new h2d.Text(f, net.eng.s2d);
		tf.textColor = 0xFFFFFF;
		tf.alpha = 0.6;
		tf.dropShadow = {
			dx: 0.5,
			dy: 0.5,
			color: 0xFFFFF0,
			alpha: 0.4
		};
		tf.scale(scale);
		tf.text = score + "";
		var cx:Int;
		var cy:Int;
		switch type {
			case GOAL1:
				cx = Const.PADDLE_CUSION * 3;
				cy = Math.floor(wy / 2);
			case GOAL2:
				cx = wx - Const.PADDLE_CUSION * 3;
				cy = Math.floor(wy / 2);
			default:
				cx = wx - Const.PADDLE_CUSION * 3;
				cy = Math.floor(wy / 2);
		}
		tf.x = cx - (tf.textWidth * scale / 2);
		tf.y = cy - (tf.textHeight * scale / 2);
	}

	public function addScore() {
		score = score + 1;
	}
}

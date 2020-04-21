package src;

import h2d.Text;

class Score {

    var tf : Text;
    var score: Int;

    public function new(cx: Int, cy: Int, f: h2d.Font, s2d: h2d.Object) {
        var scale = 20;
        tf = new h2d.Text(f, s2d);
        tf.textColor = 0xFFFFFF;
        tf.alpha = 0.6;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFFFFF0, alpha : 0.4 };
        tf.scale(scale);
        tf.text = "0";
        score = 0;
        tf.x = cx - (tf.textWidth  * scale / 2);
        tf.y = cy - (tf.textHeight * scale / 2);
    }

    public function addScore(){
        score++;
        tf.text = "" + score;
    }
}
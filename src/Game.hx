package src;

import haxe.Timer;
import h2d.Font;
import src.ent.Paddle;
import src.ent.Ball;
import src.ent.Entity;
import src.ent.Goal;
import src.Score;

class Game extends hxd.App {
    
	static function main() {
        hxd.Res.initEmbed();
		new Game();
	}

	var p1:Paddle;
	var p2:Paddle;
	var ball:Ball;
	var goal1:Goal;
	var goal2:Goal;
	var entities:Array<Entity>;

    var p1tf: Score;
    var p2tf: Score;
    
    var font: Font;
    var wx: Int;
    var wy: Int;

	override function init() {
		wx = hxd.Window.getInstance().width;
        wy = hxd.Window.getInstance().height;
        
        // Create the score trackers
        font = hxd.Res.font.toFont();

        p1tf = new Score(
            Math.floor(wx/4),
            Math.floor(wy/2),
            font,
            s2d
        );

        p2tf = new Score(
            Math.floor(3*wx/4),
            Math.floor(wy/2),
            font,
            s2d
        );

        // Register game objects
		p1 = new Paddle(
            Const.PADDLE_CUSION + Const.PADDLE_XR,
            Math.floor(wy / 2),
            s2d,
            Const.ENTITIES.P1
        );
		p2 = new Paddle(
            wx - Const.PADDLE_CUSION - Const.PADDLE_XR,
            Math.floor(wy / 2),
            s2d,
            Const.ENTITIES.P2
        );
		ball = new Ball(
            Math.floor(wx / 2),
            Math.floor(wy / 2),
            s2d,
            onGoal,
            Const.ENTITIES.BALL
        );
		goal1 = new Goal(
            Const.GOAL_WR,
            Math.floor(wy / 2),
            s2d,
            Const.ENTITIES.GOAL1
        );
		goal2 = new Goal(
            wx - Const.GOAL_WR,
            Math.floor(wy / 2),
            s2d,
            Const.ENTITIES.GOAL2
        );

        // Register entities for collision with ball
		entities = [p1, p2, goal1, goal2];
	}

	override function update(dt:Float) {
		p1.update(dt, p1.preUpdateTask);
		p2.update(dt, p2.preUpdateTask);
        ball.update(dt, ball.preUpdateTask, entities, ball.postUpdateTask);
    }

	private function onGoal(g:Goal) {
		switch (g.type) {
			case Const.ENTITIES.GOAL1:
                p2tf.addScore();
			case Const.ENTITIES.GOAL2:
                p1tf.addScore();
			default:
				return;
        }

        // After 1 second, create a new ball.
		Timer.delay(()-> this.ball = new Ball(Math.floor(wx / 2), Math.floor(wy / 2), s2d, onGoal, Const.ENTITIES.BALL),1000);
    }
    
}

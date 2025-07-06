package;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;

class PlayState extends FlxState
{
	public var Score:Int = 0;

	var scoreText:FlxText;

	// otc - object to click
	var otc:FlxSprite;

	public var OtcClicked:FlxSignal = new FlxSignal();

	public function OtcClickedEvent():Void
	{
		Score += Constants.DefaultScoreIncrement;

		scoreText.text = 'Score: $Score';
		scoreText.screenCenter(X);
		otc.scale.set(0.75, 0.75);
		FlxTween.tween(otc, {'scale.x': 1, 'scale.y': 1}, 0.25);
	}

	override public function create():Void
	{
		super.create();
		otc = new FlxSprite(0, 0);
		otc.makeGraphic(512, 512, FlxColor.RED);
		otc.screenCenter();
		add(otc);

		scoreText = new FlxText(0, 10, 0, 'Score: 0', 16);
		scoreText.screenCenter(X);
		add(scoreText);

		OtcClicked.add(OtcClickedEvent);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justReleased && FlxG.mouse.overlaps(otc))
		{
			OtcClicked.dispatch();
		}
	}
}

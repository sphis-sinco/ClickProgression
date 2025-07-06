package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import medals.MedalChecker;

class PlayState extends FlxState
{
	public static var instance:PlayState;

	public var Score:Int = 0;
	public var medals:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	var scoreText:FlxText;

	// otc - object to click
	var otc:FlxSprite;

	public var OtcClicked:FlxSignal = new FlxSignal();

	public function OtcClickedEvent():Void
	{
		Score += Constants.DefaultScoreIncrement;

		scoreText.text = 'Score: $Score';
		scoreText.screenCenter(X);
		
		FlxTween.cancelTweensOf(otc);
		otc.scale.set(0.9, 0.9);
		FlxTween.tween(otc, {'scale.x': 1, 'scale.y': 1}, 0.25);

		MedalChecker.checkForMedals();
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
		add(medals);
		instance = this;

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

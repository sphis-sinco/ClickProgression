package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import flixel.util.FlxStringUtil;
import medals.MedalChecker;

class PlayState extends FlxState
{
	public static var instance:PlayState;

	public var Score:Int = 0;
	public var Money:Float = 0;

	public var ScoreIncrement:Null<Int> = 0;
	public var MoneyIncrement:Null<Float> = 0;

	public var medals:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	var scoreText:FlxText;
	var moneyText:FlxText;
	var shopButton:FlxButton;

	// otc - object to click
	var otc:FlxSprite;

	public var OtcClicked:FlxSignal = new FlxSignal();

	public function OtcClickedEvent():Void
	{
		Score += ScoreIncrement;
		Money += MoneyIncrement;

		FlxG.save.data.score = Score;
		FlxG.save.data.money = Money;
		FlxG.save.flush();

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
		add(scoreText);

		moneyText = new FlxText(0, 30, 0, 'Money: $0', 16);
		add(moneyText);

		shopButton = new FlxButton(0, 60, 'Shop', () ->
		{
			FlxG.switchState(ShopState.new);
		});
		shopButton.screenCenter(X);
		add(shopButton);

		OtcClicked.add(OtcClickedEvent);
		add(medals);

		instance = this;

		if (FlxG.save.data.score != null)
		{
			Score = FlxG.save.data.score;
			MedalChecker.checkForMedals();
		}

		if (FlxG.save.data.money != null)
		{
			Money = FlxG.save.data.money;
		}

		ScoreIncrement = FlxG.save.data.scoreInc;
		ScoreIncrement ??= Constants.DefaultScoreIncrement;

		MoneyIncrement = FlxG.save.data.moneyInc;
		MoneyIncrement ??= Constants.DefaultMoneyIncrement;

		scoreText.text = 'Score: $Score';
		scoreText.screenCenter(X);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justReleased && FlxG.mouse.overlaps(otc))
		{
			OtcClicked.dispatch();
		}

		moneyText.text = 'Money: $' + '${FlxStringUtil.formatMoney(Money)}';
		moneyText.screenCenter(X);
	}
}

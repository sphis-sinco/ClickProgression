package;

import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxStringUtil;

class ShopState extends FlxState
{
	public static var instance:ShopState;

	public var Money:Float = 0;

	var moneyText:FlxText;
	var scoreIncText:FlxText;
	var moneyIncText:FlxText;
	var leaveButton:FlxButton;

	var doubleScoringBtn:ShopButton;
	var doubleMoneyBtn:ShopButton;

	override function create()
	{
		super.create();

		Money = PlayState.instance.Money;

		moneyText = new FlxText(0, 10, 0, 'Money: $0', 16);
		add(moneyText);

		scoreIncText = new FlxText(0, moneyText.y + 30, 0, '', 16);
		add(scoreIncText);

		moneyIncText = new FlxText(0, scoreIncText.y + 30, 0, '', 16);
		add(moneyIncText);

		leaveButton = new FlxButton(0, moneyIncText.y + 30, 'Leave', () ->
		{
			FlxG.save.data.money = Money;
			FlxG.save.flush();
			FlxG.switchState(PlayState.new);
		});
		leaveButton.screenCenter(X);
		add(leaveButton);

		doubleScoringBtn = new ShopButton(30, () ->
		{
			PlayState.instance.ScoreIncrement += PlayState.instance.ScoreIncrement;
			FlxG.save.data.scoreInc = PlayState.instance.ScoreIncrement;
                        FlxG.save.flush();
		}, 'Double scoring increment', [160, 30], 10);
		doubleScoringBtn.setPosition(20, 60);
		add(doubleScoringBtn);

		doubleMoneyBtn = new ShopButton(60, () ->
		{
			PlayState.instance.MoneyIncrement += PlayState.instance.MoneyIncrement;
			FlxG.save.data.moneyInc = PlayState.instance.MoneyIncrement;
                        FlxG.save.flush();
		}, 'Double money increment', doubleScoringBtn.dimensions, doubleScoringBtn.maximumClicks);
		doubleMoneyBtn.setPosition(20 + doubleScoringBtn.width + 20, 60);
		add(doubleMoneyBtn);

		instance = this;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		moneyText.text = 'Money: $' + '${FlxStringUtil.formatMoney(Money)}';
		moneyText.screenCenter(X);

		scoreIncText.text = 'Score increment: ${PlayState.instance.ScoreIncrement}';
		scoreIncText.screenCenter(X);

		moneyIncText.text = 'Money increment: ${PlayState.instance.MoneyIncrement}';
		moneyIncText.screenCenter(X);
	}
}

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
	var leaveButton:FlxButton;

	var doubleScoringBtn:ShopButton;

	override function create()
	{
		super.create();

		Money = PlayState.instance.Money;

		moneyText = new FlxText(0, 10, 0, 'Money: $0', 16);
		add(moneyText);

		leaveButton = new FlxButton(0, 40, 'Leave', () ->
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
		}, 'Double scoring increment ($30)', [160, 20]);
		doubleScoringBtn.setPosition(20, 60);
		add(doubleScoringBtn);

		instance = this;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		moneyText.text = 'Money: $' + '${FlxStringUtil.formatMoney(Money)}';
		moneyText.screenCenter(X);
	}
}

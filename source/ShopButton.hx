package;

import flixel.addons.ui.FlxButtonPlus;

class ShopButton extends FlxButtonPlus
{
	public var price:Float = 0;

	override public function new(cost, callback:() -> Void, label:String, dimensions:Array<Int>)
	{
		super(0, 0, () ->
		{
			if (ShopState.instance.Money >= price)
			{
				ShopState.instance.Money -= price;
				callback();
			}
		}, label, dimensions[0], dimensions[1]);

		price = cost;
	}
}

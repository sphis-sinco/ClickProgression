package;

import flixel.addons.ui.FlxButtonPlus;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;

class ShopButton extends FlxButtonPlus
{
	public var price:Float = 0;
	public var dimensions:Array<Int> = [0,0];

	public var clicks:Int = 0;
	public var maximumClicks:Int = FlxMath.MAX_VALUE_INT;

	override public function new(cost, callback:() -> Void, label:String, dimensions:Array<Int>, ?maxClicks:Int)
	{
		this.dimensions = dimensions;

		super(0, 0, () ->
		{
			if (ShopState.instance.Money >= price)
			{
				clicks++;

				if (clicks > maximumClicks) return;
				
				ShopState.instance.Money -= price;
				callback();
			}
		}, label + '($'+FlxStringUtil.formatMoney(cost)+')', dimensions[0], dimensions[1]);

		price = cost;

		if (maxClicks != null)
			maximumClicks = maxClicks;
	}
}

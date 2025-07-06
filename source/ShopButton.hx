package;

import flixel.addons.ui.FlxButtonPlus;
import flixel.util.FlxStringUtil;

class ShopButton extends FlxButtonPlus
{
	public var price:Float = 0;
	public var dimensions:Array<Int> = [0,0];

	override public function new(cost, callback:() -> Void, label:String, dimensions:Array<Int>)
	{
		this.dimensions = dimensions;

		super(0, 0, () ->
		{
			if (ShopState.instance.Money >= price)
			{
				ShopState.instance.Money -= price;
				callback();
			}
		}, label + '($'+FlxStringUtil.formatMoney(cost)+')', dimensions[0], dimensions[1]);

		price = cost;
	}
}

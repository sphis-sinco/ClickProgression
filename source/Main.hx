package;

import openfl.display.Sprite;

class Main extends Sprite
{
	public function new():Void
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));

		#if newgrounds
		Newgrounds.initNG();
		#end
	}
}

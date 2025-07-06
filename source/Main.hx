package;

import openfl.display.Sprite;

class Main extends Sprite
{
	#if NEWGROUNDS
	public static var NG:NGio;
	#end

	public function new():Void
	{
		FlxG.save.bind('ClickProgression', Application.COMPANY);
		trace(FlxG.save.data);

		super();
		addChild(new FlxGame(0, 0, PlayState));

		#if NEWGROUNDS
		NG = new NGio(NewgroundsInfo.APP_ID, NewgroundsInfo.ENCRYPTION_KEY, NewgroundsInfo.SESSION_ID);
		#end
	}
}

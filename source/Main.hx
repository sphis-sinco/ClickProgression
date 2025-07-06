package;

import openfl.display.Sprite;

class Main extends Sprite
{
	#if NEWGROUNDS
	public static var NG:NGio;
	#end

	public function new():Void
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));

		#if NEWGROUNDS
		NG = new NGio(NewgroundsInfo.APP_ID, NewgroundsInfo.ENCRYPTION_KEY, NewgroundsInfo.SESSION_ID);
		#end
	}
}

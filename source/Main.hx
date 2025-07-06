package;

import openfl.display.Sprite;

class Main extends Sprite
{
	public static var NG:NGio;

	public function new():Void
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));

		NG = new NGio(NewgroundsInfo.APP_ID, NewgroundsInfo.ENCRYPTION_KEY, NewgroundsInfo.SESSION_ID);
	}
}

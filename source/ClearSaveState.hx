package;

class ClearSaveState extends FlxState
{
	var heart:FlxSprite;
	var yesSpr:FlxSprite;
	var noSpr:FlxSprite;

	override function create()
	{
		super.create();

		heart = new FlxSprite();
		heart.frames = FileManager.getSparrowAtlas('ui/clearSave/heart');
		heart.animation.addByPrefix('false', 'Heart0', 24);
		heart.animation.addByPrefix('true', 'Heart selected', 24);

		yesSpr = new FlxSprite();
		yesSpr.frames = FileManager.getSparrowAtlas('ui/clearSave/yes');
		yesSpr.animation.addByPrefix('yes', 'Yes', 24);
		yesSpr.animation.play('yes');
		add(yesSpr);

		noSpr = new FlxSprite();
		noSpr.frames = FileManager.getSparrowAtlas('ui/clearSave/no');
		noSpr.animation.addByPrefix('no', 'No', 24);
		noSpr.animation.play('no');
		add(noSpr);

		heart.scale.set(0.5, 0.5);
		heart.screenCenter(XY);
		add(heart);

		yesSpr.screenCenter(XY);
		yesSpr.x -= yesSpr.width;
		noSpr.screenCenter(XY);
		noSpr.x += noSpr.width;
	}

	override function update(elapsed:Float)
	{
		var selecting:Bool = heart.overlaps(yesSpr);
		if (!selecting)
			selecting = heart.overlaps(noSpr);
		FlxG.watch.addQuick('Selecting', selecting);

		if (FlxG.keys.pressed.LEFT)
			heart.x -= 10;
		if (FlxG.keys.pressed.RIGHT)
			heart.x += 10;
		if (FlxG.keys.pressed.UP)
			heart.y -= 10;
		if (FlxG.keys.pressed.DOWN)
			heart.y += 10;

		if (FlxG.keys.justReleased.ENTER)
		{
			if (heart.overlaps(yesSpr))
				yes();
			if (heart.overlaps(noSpr))
				no();
		}

		if (heart.animation.name != Std.string(selecting))
			heart.animation.play(Std.string(selecting));

		super.update(elapsed);
	}

	public function yes()
	{
		FlxG.save.erase();
		FlxG.resetGame();
	}

	public function no()
	{
		FlxG.switchState(PlayState.new);
	}
}

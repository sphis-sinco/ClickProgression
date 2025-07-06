package medals;

import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class MedalChecker
{
	public static var medalIDS:Map<String, Null<Int>> = [];
	public static var medalUnlockVal:Map<String, Null<Int>> = [];
	public static var medalNames:Array<String> = [];

	public static function initMedals()
	{
		addMedal('Uno', 85437, 1);
		addMedal('Dos', 85438, 2);
		addMedal('Tres', 85439, 3);
		addMedal('Cuatro', 85440, 4);
		addMedal('Sinco', 85441, 5);

		addMedal('Cancer', 85433, 69);

		addMedal('One Hundo', 85432, 100);
		addMedal('Korin', 85442, 190);

		addMedal('Super Kamehameha', 85443, 910);

		// TODO: make this dub-only
		addMedal('Its over 9000!', 85444, 9000);
	}

	public static function addMedal(name:String, id:Null<Int>, setval:Null<Int>)
	{
		medalIDS.set(name, id);
		medalUnlockVal.set(name, setval);
		medalNames.push(name);
	}

	public static function checkForMedals(isnew:Bool = true)
	{
		var thescore = PlayState.instance.Score;
		var newval = isnew; // != null ? isnew : FlxG.save.data.medals.contains();

		var i = 0;
		for (medal in medalNames)
		{
			if (thescore >= medalUnlockVal.get(medal))
			{
				unlockMedal(i, newval);
			}
			i++;
		}
	}

	public static function unlockMedal(medalIndex:Int, isnew:Bool = true)
	{
		var medalName:String = medalNames[medalIndex];
		var medalID:Int = medalIDS.get(medalName);

		#if NEWGROUNDS
		NGio.unlockMedal(medalID);
		#end

		var medals:Array<String> = FlxG.save.data.medals;
		medals ??= [];
		if (!isnew || medals.contains(medalName))
			return;

		if (medalUnlockVal.get(medalName) == 9000)
			FlxG.sound.play(FileManager.getSoundFile('ui/medals/over9000'));

		trace('Unlocked medal: $medalName${#if NEWGROUNDS ' / $medalID' #else '' #end}');

		medals.push(medalName);
		FlxG.save.data.medals = medals;
		FlxG.save.flush();

		var medalText:FlxText = new FlxText();
		medalText.text = 'Unlocked medal "$medalName"';

		medalText.size = 32;
		medalText.alpha = 1;
		medalText.screenCenter(X);
		medalText.y = FlxG.height - medalText.height - 32;

		medalText.y = FlxG.height - medalText.height - 32;
		if (PlayState.instance.medals.members.length > 0)
		{
			medalText.y -= 32 * PlayState.instance.medals.members.length;
		}
		PlayState.instance.medals.add(medalText);

		FlxTween.tween(medalText, {alpha: 1}, 0.5, {
			onStart: tween ->
			{
				FlxG.sound.play(FileManager.getSoundFile('ui/medals/NGFadeIn'));
			},
			onComplete: tween ->
			{
				FlxTimer.wait(0.5, () ->
				{
					FlxG.sound.play(FileManager.getSoundFile('ui/medals/NGFadeOut'));
					FlxFlicker.flicker(medalText, 1, 0.05, false, false, flicker ->
					{
						PlayState.instance.medals.members.remove(medalText);
						medalText.destroy();
					});
				});
			},
			ease: FlxEase.sineInOut
		});
	}
}

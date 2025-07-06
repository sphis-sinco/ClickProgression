package medals;

import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class MedalChecker
{
	public static function checkForMedals()
	{
		switch (PlayState.instance.Score)
		{
			// 2 is just for testing
			case 2:
				unlockMedal(OneHundoName, OneHundoID);

			default:
				// Prevent this from spamming the console
				// trace('No medal unlocked');
		}
	}

	public static function unlockMedal(medalName:MedalNames, medalID:MedalIDs)
	{
		// Newgrounds API will unlock the medal here

		var medalText:FlxText = new FlxText();
		medalText.text = 'Unlocked medal "$medalName"';
		medalText.size = 32;
		medalText.alpha = 0;
		medalText.screenCenter(X);
		medalText.y = FlxG.height - medalText.height - 32;

		PlayState.instance.add(medalText);

		FlxTween.tween(medalText, {alpha: 1}, 0.5, {
			onStart: tween ->
			{
				FlxG.sound.play(FileManager.getAssetFile('ui/medals/NGFadeIn.${FileManager.SOUND_EXT}'));
			},
			onComplete: tween ->
			{
				FlxG.sound.play(FileManager.getAssetFile('ui/medals/NGFadeOut.${FileManager.SOUND_EXT}'));
				FlxFlicker.flicker(medalText, 1, 0.05, false, false, flicker ->
				{
					PlayState.instance.remove(medalText);
					medalText.destroy();
				});
			},
			ease: FlxEase.sineInOut
		});
	}
}

enum abstract MedalNames(String)
{
	var OneHundoName = 'OneHundo';
}

enum abstract MedalIDs(Int)
{
	var OneHundoID = 0;
}

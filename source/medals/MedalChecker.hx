package medals;

import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class MedalChecker
{
	static var medalIDS:Map<String, Int> = ['cancer' => 85433, 'one hundo' => 85432];
	static var medalNames:Map<String, String> = ['cancer' => 'Cancer', 'one hundo' => 'One Hundo'];

	public static function checkForMedals()
	{
		switch (PlayState.instance.Score)
		{
			case 69:
				unlockMedal('cancer');

			case 100:
				unlockMedal('one hundo');

			default:
				// Prevent this from spamming the console
				// trace('No medal unlocked');
		}
	}

	public static function unlockMedal(medalKey:String)
	{
		var medalName:String = medalNames.get(medalKey);
		var medalID:Int = medalIDS.get(medalKey);

		#if newgrounds
		Newgrounds.unlockMedal(medalID);
		#end

		var medalText:FlxText = new FlxText();
		medalText.text = 'Unlocked medal "$medalName"';
		medalText.size = 32;
		medalText.alpha = 0;
		medalText.screenCenter(X);
		medalText.y = FlxG.height - medalText.height - 32;

		if (PlayState.instance.medals.length > 0)
			medalText.y -= 32 * PlayState.instance.medals.length;
		PlayState.instance.medals.add(medalText);

		FlxTween.tween(medalText, {alpha: 1}, 0.5, {
			onStart: tween ->
			{
				FlxG.sound.play(FileManager.getAssetFile('ui/medals/NGFadeIn.${FileManager.SOUND_EXT}'));
			},
			onComplete: tween ->
			{
				FlxTimer.wait(0.5, () ->
				{
					FlxG.sound.play(FileManager.getAssetFile('ui/medals/NGFadeOut.${FileManager.SOUND_EXT}'));
					FlxFlicker.flicker(medalText, 1, 0.05, false, false, flicker ->
					{
						PlayState.instance.remove(medalText);
						medalText.destroy();
					});
				});
			},
			ease: FlxEase.sineInOut
		});
	}
}

enum abstract MedalNames(String)
{
	var CancerName = 'Cancer';
	var OneHundoName = 'One Hundo';
}

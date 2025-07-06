package medals;

import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class MedalChecker
{
	public static var medalIDS:Map<String, Int> = ['cancer' => 85433, 'one hundo' => 85432];
	public static var medalNames:Map<String, String> = ['cancer' => 'Cancer', 'one hundo' => 'One Hundo'];

	public static function checkForMedals(isnew:Bool = true)
	{
		var thescore = PlayState.instance.Score;
		var newval = isnew; // != null ? isnew : FlxG.save.data.medals.contains();

		if (thescore >= 69)
			unlockMedal('cancer', newval);
		if (thescore >= 100)
			unlockMedal('one hundo', newval);
	}

	public static function unlockMedal(medalKey:String, isnew:Bool = true)
	{
		var medalName:String = medalNames.get(medalKey);
		var medalID:Int = medalIDS.get(medalKey);
		trace('Unlocked medal: $medalName${#if NEWGROUNDS ' / $medalID' #else '' #end}');

		#if NEWGROUNDS
		NGio.unlockMedal(medalID);
		#end

		var medals:Array<String> = FlxG.save.data.medals;
		medals ??= [];
		if (!isnew || medals.contains(medalName))
			return;
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

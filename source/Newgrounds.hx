package;

#if newgrounds
import io.newgrounds.NG;
import io.newgrounds.NGLite.LoginOutcome;
import io.newgrounds.objects.Medal;

class Newgrounds
{
	public static function initNG()
	{
		NG.create(NewgroundsInfo.APP_ID, NewgroundsInfo.SESSION_ID);
		NG.createAndCheckSession(NewgroundsInfo.APP_ID, false, NewgroundsInfo.BACKUP_SESSION_ID);
		NG.core.setupEncryption(NewgroundsInfo.ENCRYPTION_KEY, AES_128, BASE_64);

		NG.core.medals.loadList();
	}

	public static function unlockMedal(id:Int)
	{
		var medal:Medal = NG.core.medals.get(id);
		trace('${medal.name} is worth ${medal.value}');

		if (!medal.unlocked)
		{
			medal.onUnlock.add(function():Void
			{
				trace('${medal.name} unlocked:${medal.unlocked}');
			});
			medal.sendUnlock();
		}
	}
}
#end

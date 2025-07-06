package medals;

class MedalChecker
{
	public static function checkForMedals()
	{
		switch (PlayState.instance.Score)
		{
			case 100:
				unlockMedal(OneHundoName, OneHundoID);

			default:
				// Prevent this from spamming the console
				// trace('No medal unlocked');
		}
	}

	public static function unlockMedal(medalName:MedalNames, medalID:MedalIDs)
	{
		// Newgrounds API will unlock the medal here
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

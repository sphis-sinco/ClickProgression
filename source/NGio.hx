package;

#if NEWGROUNDS
import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import io.newgrounds.components.ScoreBoardComponent.Period;
import io.newgrounds.objects.Medal;
import io.newgrounds.objects.Score;
import io.newgrounds.objects.ScoreBoard;
import io.newgrounds.objects.events.Response;
import lime.app.Application;
import openfl.display.Stage;

using StringTools;

/**
 * MADE BY GEOKURELI THE LEGENED GOD HERO MVP
 */
class NGio
{
	public static var isLoggedIn:Bool = false;
	public static var scoreboardsLoaded:Bool = false;

	public static var scoreboardArray:Array<Score> = [];

	public static var ngDataLoaded(default, null):FlxSignal = new FlxSignal();
	public static var ngScoresLoaded(default, null):FlxSignal = new FlxSignal();

	public static var GAME_VER:String = "";
	public static var GAME_VER_NUMS:String = '';
	public static var gotOnlineVer:Bool = false;

	public static function noLogin(api:String)
	{
		trace('INIT NOLOGIN');
	}

	public function new(api:String, encKey:String, ?sessionId:String)
	{
		trace("connecting to newgrounds");

		NG.createAndCheckSession(api, sessionId);

		NG.core.verbose = true;
		// Set the encryption cipher/format to RC4/Base64. AES128 and Hex are not implemented yet
		NG.core.setupEncryption(encKey); // Found in you NG project view

		trace(NG.core.attemptingLogin);

		if (NG.core.attemptingLogin)
		{
			/* a session_id was found in the loadervars, this means the user is playing on newgrounds.com
			 * and we should login shortly. lets wait for that to happen
			 */
			trace("attempting login");
			NG.core.onLogin.add(onNGLogin);
		}
		else
		{
			/* They are NOT playing on newgrounds.com, no session id was found. We must start one manually, if we want to.
			 * Note: This will cause a new browser window to pop up where they can log in to newgrounds
			 */
			NG.core.requestLogin(outcome ->
			{
				onNGLogin();
			});
		}
	}

	function onNGLogin():Void
	{
		trace('logged in! user:${NG.core.user.name}');
		isLoggedIn = true;
		FlxG.save.data.sessionId = NG.core.sessionId;
		// FlxG.save.flush();
		// Load medals then call onNGMedalFetch()
		NG.core.requestMedals(outcome ->
		{
			onNGMedalFetch();
		});

		// Load Scoreboards hten call onNGBoardsFetch()
		NG.core.scoreBoards.loadList(outcome ->
		{
			onNGBoardsFetch();
		});

		ngDataLoaded.dispatch();
	}

	// --- MEDALS
	function onNGMedalFetch():Void
	{
		// Reading medal info
		for (id in NG.core.medals.keys())
		{
			var medal = NG.core.medals.get(id);
			trace('loaded medal id:$id, name:${medal.name}, description:${medal.description}');
		}

		// Unlocking medals
		// var unlockingMedal = NG.core.medals.get(54352);// medal ids are listed in your NG project viewer
		// if (!unlockingMedal.unlocked)
		//	unlockingMedal.sendUnlock();
	}

	// --- SCOREBOARDS
	function onNGBoardsFetch():Void
	{
		// Reading medal info
		for (id in NG.core.scoreBoards.keys())
		{
			var board = NG.core.scoreBoards.get(id);
			trace('loaded scoreboard id:$id, name:${board.name}');
		}
		var board = NG.core.scoreBoards.get(15064);// ID found in NG project view

		// Posting a score thats OVER 9000!
		// board.postScore(FlxG.random.int(0, 1000));
		// KAKAROT YOUR A FRAUD!

		// --- To view the scores you first need to select the range of scores you want to see ---

		// add an update listener so we know when we get the new scores
		board.onUpdate.add(onNGScoresFetch);
		trace("shoulda got score by NOW!");
		board.requestScores();// get the best 10 scores ever logged
		// more info on scores --- http://www.newgrounds.io/help/components/#scoreboard-getscores
	}

	inline static public function postScore(score:Int = 0, song:String)
	{
		if (isLoggedIn)
		{
			for (id in NG.core.scoreBoards.keys())
			{
				var board = NG.core.scoreBoards.get(id);

				if (song == board.name)
				{
					board.postScore(score, NG.core.user.name);
				}

				trace('loaded scoreboard id:$id, name:${board.name}');
			}
		}
	}

	function onNGScoresFetch():Void
	{
		return;

		scoreboardsLoaded = true;

		ngScoresLoaded.dispatch();
			for (score in NG.core.scoreBoards.get(8737).scores)
			{
				trace('score loaded user:${score.user.name}, score:${score.formattedValue}');

			}

		// var board = NG.core.scoreBoards.get(15064);// ID found in NG project view
		// board.postScore(HighScore.score);

		NGio.scoreboardArray = NG.core.scoreBoards.get(15064).scores;
	}

	inline static public function logEvent(event:String)
	{
		NG.core.calls.event.logEvent(event).send();
		trace('should have logged: ' + event);
	}

	inline static public function unlockMedal(id:Int)
	{
		if (isLoggedIn)
		{
			var medal = NG.core.medals.get(id);
			if (!medal.unlocked)
				medal.sendUnlock();
		}
	}
}
#end
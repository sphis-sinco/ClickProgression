package medals;

class MedalChecker
{
        public static function checkForMedals() {
                switch(PlayState.instance.Score)
                {
                        default:
                                trace('No medal unlocked');
                }
        }
}
import Toybox.Lang;
import Toybox.Test;

(:test)
function createGame(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    Test.assertEqual(theGame.FrameNumber, 0);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}
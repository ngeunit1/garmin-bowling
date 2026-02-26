import Toybox.Lang;
import Toybox.Test;

(:test)
function oneFrameScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var theScore = new Score(theGame);
    theGame.AddShot(5);
    theGame.AddShot(4);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assertEqual(scoreDisplay.RunningTotal.size(), 1);
    Test.assert(compareDisplayWoodArray(scoreDisplay.DisplayWood[0].Display, ["5", "4"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 9);
    return true;
}
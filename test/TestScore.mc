import Toybox.Lang;
import Toybox.Test;

(:test)
function oneFrameScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(5);
    theGame.AddShot(4);
    var theScore = new Score(theGame);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assert(compareWoodDisplay(scoreDisplay.DisplayWood[0].Display, ["5", "4"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 9);
    return true;
}

(:test)
function oneFrameSpareGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(5);
    theGame.AddShot(5);
    var theScore = new Score(theGame);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assert(compareWoodDisplay(scoreDisplay.DisplayWood[0].Display, ["5", "/"]));
    Test.assert(scoreDisplay.RunningTotal[0] == null);
    return true;
}

(:test)
function oneFrameStrikeGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(STRIKE);
    var theScore = new Score(theGame);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assert(compareWoodDisplay(scoreDisplay.DisplayWood[0].Display, ["X"]));
    Test.assert(scoreDisplay.RunningTotal[0] == null);
    return true;
}

(:test)
function oneFrameStrikeWithIncompleteFillGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(STRIKE);
    theGame.AddShot(5);
    var theScore = new Score(theGame);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assert(compareWoodDisplay(scoreDisplay.DisplayWood[0].Display, ["X"]));
    Test.assert(scoreDisplay.RunningTotal[0] == null);
    return true;
}

(:test)
function oneFrameStrikeWithFillsGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(STRIKE);
    theGame.AddShot(5);
    theGame.AddShot(5);
    var theScore = new Score(theGame);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 2);
    Test.assert(compareWoodDisplay(scoreDisplay.DisplayWood[0].Display, ["X"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 20);
    return true;
}

(:test)
function oneFrameStrikeWithStrikeFillsGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(STRIKE);
    theGame.AddShot(STRIKE);
    theGame.AddShot(STRIKE);
    var theScore = new Score(theGame);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 3);
    Test.assert(compareWoodDisplay(scoreDisplay.DisplayWood[0].Display, ["X"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 30);
    return true;
}

(:test)
function oneFrameThreeShotGetScore(logger as Logger) as Boolean {
    var theGame = new Game(CANDLEPIN);
    theGame.AddShot(5);
    theGame.AddShot(3);
    theGame.AddShot(2);
    var theScore = new Score(theGame);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assert(compareWoodDisplay(scoreDisplay.DisplayWood[0].Display, ["5", "3", "2"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 10);
    return true;
}

(:test)
function twoDifferentFramesGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(5);
    theGame.AddShot(4);
    theGame.AddShot(3);
    theGame.AddShot(2);
    var theScore = new Score(theGame);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 2);
    Test.assert(compareWoodDisplay(scoreDisplay.DisplayWood[0].Display, ["5", "4"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 9);
    Test.assert(compareWoodDisplay(scoreDisplay.DisplayWood[1].Display, ["3", "2"]));
    Test.assertEqual(scoreDisplay.RunningTotal[1] as Number, 14);
    return true;
}

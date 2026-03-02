import Toybox.Lang;
import Toybox.Test;

function compareDisplayWoodArray(act as Array<String>, exp as Array<String>) as Boolean {
    if (act.size() != exp.size()) {
        return false;
    }
    for (var idx = 0; idx < exp.size(); idx++) {
        if (!(act[idx] == null && exp[idx] == null) && !(act[idx].equals(exp[idx]))) {
            return false;
        }
    }
    return true;
}

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

(:test)
function oneFrameSpareGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var theScore = new Score(theGame);
    theGame.AddShot(5);
    theGame.AddShot(5);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assertEqual(scoreDisplay.RunningTotal.size(), 1);
    Test.assert(compareDisplayWoodArray(scoreDisplay.DisplayWood[0].Display, ["5", "/"]));
    Test.assert(scoreDisplay.RunningTotal[0] == null);
    return true;
}

(:test)
function oneFrameStrikeGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var theScore = new Score(theGame);
    theGame.AddShot(10);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assertEqual(scoreDisplay.RunningTotal.size(), 1);
    Test.assert(compareDisplayWoodArray(scoreDisplay.DisplayWood[0].Display, ["X"]));
    Test.assert(scoreDisplay.RunningTotal[0] == null);
    return true;
}

(:test)
function oneFrameStrikeWithIncompteFillGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var theScore = new Score(theGame);
    theGame.AddShot(10);
    theGame.AddShot(5);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assertEqual(scoreDisplay.RunningTotal.size(), 1);
    Test.assert(compareDisplayWoodArray(scoreDisplay.DisplayWood[0].Display, ["X"]));
    Test.assert(scoreDisplay.RunningTotal[0] == null);
    return true;
}

(:test)
function oneFrameStrikeWithFillsGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var theScore = new Score(theGame);
    theGame.AddShot(10);
    theGame.AddShot(5);
    theGame.AddShot(5);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 2);
    Test.assertEqual(scoreDisplay.RunningTotal.size(), 2);
    Test.assert(compareDisplayWoodArray(scoreDisplay.DisplayWood[0].Display, ["X"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 20);
    return true;
}

(:test)
function oneFrameStrikeWithStrikeFillsGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var theScore = new Score(theGame);
    theGame.AddShot(10);
    theGame.AddShot(10);
    theGame.AddShot(10);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 3);
    Test.assert(compareDisplayWoodArray(scoreDisplay.DisplayWood[0].Display, ["X"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 30);
    return true;
}

(:test)
function oneFrameThreeShotGetScore(logger as Logger) as Boolean {
    var theGame = new Game(CANDLEPIN);
    theGame.StartGame();
    var theScore = new Score(theGame);
    theGame.AddShot(5);
    theGame.AddShot(3);
    theGame.AddShot(2);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 1);
    Test.assert(compareDisplayWoodArray(scoreDisplay.DisplayWood[0].Display, ["5", "3", "2"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 10);
    return true;
}

(:test)
function twoDifferentFramesGetScore(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var theScore = new Score(theGame);
    theGame.AddShot(5);
    theGame.AddShot(4);
    theGame.AddShot(3);
    theGame.AddShot(2);
    var scoreDisplay = theScore.GetScore();
    Test.assertEqual(scoreDisplay.DisplayWood.size(), 2);
    Test.assert(compareDisplayWoodArray(scoreDisplay.DisplayWood[0].Display, ["5", "4"]));
    Test.assertEqual(scoreDisplay.RunningTotal[0] as Number, 9);
    Test.assert(compareDisplayWoodArray(scoreDisplay.DisplayWood[1].Display, ["3", "2"]));
    Test.assertEqual(scoreDisplay.RunningTotal[1] as Number, 14);
    return true;
}
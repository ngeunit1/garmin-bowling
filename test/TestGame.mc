import Toybox.Lang;
import Toybox.Test;

(:test)
function createGame(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    Test.assertEqual(theGame.FrameNumber, 0);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}

(:test)
function gameAddShotLessThan10(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var frameStatus = theGame.AddShot(5);
    Test.assertEqual(theGame.FrameNumber, 0);
    Test.assertEqual(frameStatus, FRAMENOTDONE);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}

(:test)
function gameAddTwoShotsLessThan10(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    theGame.AddShot(5);
    var frameStatus = theGame.AddShot(4);
    Test.assertEqual(theGame.FrameNumber, 1);
    Test.assertEqual(frameStatus, NEXTFRAME);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}

(:test)
function gameAddStrike(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var frameStatus = theGame.AddShot(10);
    Test.assertEqual(theGame.FrameNumber, 1);
    Test.assertEqual(frameStatus, NEXTFRAME);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}

(:test)
function gameAddThreeShotsLessThan10(logger as Logger) as Boolean {
    var theGame = new Game(CANDLEPIN);
    theGame.StartGame();
    theGame.AddShot(2);
    theGame.AddShot(2);
    var frameStatus = theGame.AddShot(4);
    Test.assertEqual(theGame.FrameNumber, 1);
    Test.assertEqual(frameStatus, NEXTFRAME);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}

(:test)
function gameTenthFrameStrikeFrameNotDone(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    for (var idx = 0; idx < 9; idx++) {
        theGame.AddShot(10);
    }
    var frameStatus = theGame.AddShot(10);
    Test.assertEqual(theGame.FrameNumber, 9);
    Test.assertEqual(frameStatus, FRAMENOTDONE);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}

(:test)
function gameTenthFrameThreeShotsGameDone(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    for (var idx = 0; idx < 9; idx++) {
        theGame.AddShot(10);
    }
    theGame.AddShot(10);
    theGame.AddShot(5);
    var frameStatus = theGame.AddShot(4);
    Test.assertEqual(theGame.FrameNumber, 9);
    Test.assertEqual(frameStatus, ENDGAME);
    Test.assertEqual(theGame.GameDone, true);
    return true;
}

(:test)
function gameTenthFrameTwoShotsLessThan10GameDone(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    for (var idx = 0; idx < 9; idx++) {
        theGame.AddShot(10);
    }
    theGame.AddShot(4);
    var frameStatus = theGame.AddShot(4);
    Test.assertEqual(theGame.FrameNumber, 9);
    Test.assertEqual(frameStatus, ENDGAME);
    Test.assertEqual(theGame.GameDone, true);
    return true;
}

(:test)
function initialGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 0);
    return true;
}

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
function oneFrameGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    theGame.AddShot(5);
    theGame.AddShot(4);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 1);
    Test.assertEqual(frameStats.Frames[0].RunningTotalWood as Number, 9);
    Test.assert(compareDisplayWoodArray(frameStats.Frames[0].WoodDisplay, ["5", "4"]));
    return true;
}

(:test)
function oneFrameSpareGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    theGame.AddShot(5);
    theGame.AddShot(5);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 1);
    Test.assert(frameStats.Frames[0].RunningTotalWood == null);
    Test.assert(compareDisplayWoodArray(frameStats.Frames[0].WoodDisplay, ["5", "/"]));
    return true;
}

(:test)
function oneFrameStrikeGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.StartGame();
    theGame.AddShot(10);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 1);
    Test.assert(frameStats.Frames[0].RunningTotalWood == null);
    Test.assert(compareDisplayWoodArray(frameStats.Frames[0].WoodDisplay, ["X", null] as Array<String>));
    return true;
}
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
    var frameStatus = theGame.AddShot(5);
    Test.assertEqual(theGame.FrameNumber, 0);
    Test.assertEqual(frameStatus, FRAMENOTDONE);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}

(:test)
function gameAddTwoShotsLessThan10(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
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
    var frameStatus = theGame.AddShot(STRIKE);
    Test.assertEqual(theGame.FrameNumber, 1);
    Test.assertEqual(frameStatus, NEXTFRAME);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}

(:test)
function gameAddThreeShotsLessThan10(logger as Logger) as Boolean {
    var theGame = new Game(CANDLEPIN);
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
    advanceToTenthFrame(theGame);
    var frameStatus = theGame.AddShot(STRIKE);
    Test.assertEqual(theGame.FrameNumber, 9);
    Test.assertEqual(frameStatus, FRAMENOTDONE);
    Test.assertEqual(theGame.GameDone, false);
    return true;
}

(:test)
function gameTenthFrameThreeShotsGameDone(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    advanceToTenthFrame(theGame);
    theGame.AddShot(STRIKE);
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
    advanceToTenthFrame(theGame);
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
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 0);
    return true;
}

(:test)
function oneFrameGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(5);
    theGame.AddShot(4);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 1);
    Test.assertEqual(frameStats.Frames[0].TotalWood as Number, 9);
    Test.assert(compareWoodShots(frameStats.Frames[0].WoodShots, [5, 4]));
    return true;
}

(:test)
function oneFrameSpareGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(5);
    theGame.AddShot(5);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 1);
    Test.assert(frameStats.Frames[0].TotalWood == null);
    Test.assert(compareWoodShots(frameStats.Frames[0].WoodShots, [5, 5]));
    return true;
}

(:test)
function oneFrameStrikeGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(STRIKE);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 1);
    Test.assert(frameStats.Frames[0].TotalWood == null);
    Test.assert(compareWoodShots(frameStats.Frames[0].WoodShots, [STRIKE]));
    return true;
}

(:test)
function oneFrameStrikeWithIncompleteFillGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(STRIKE);
    theGame.AddShot(5);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 1);
    Test.assert(frameStats.Frames[0].TotalWood == null);
    return true;
}

(:test)
function oneFrameStrikeWithFillsGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(STRIKE);
    theGame.AddShot(5);
    theGame.AddShot(5);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 2);
    Test.assertEqual(frameStats.Frames[0].TotalWood as Number, 20);
    return true;
}

(:test)
function oneFrameStrikeWithStrikeFillsGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(STRIKE);
    theGame.AddShot(STRIKE);
    theGame.AddShot(STRIKE);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 3);
    Test.assertEqual(frameStats.Frames[0].TotalWood as Number, 30);
    return true;
}

(:test)
function oneFrameThreeShotGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(CANDLEPIN);
    theGame.AddShot(5);
    theGame.AddShot(3);
    theGame.AddShot(2);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 1);
    Test.assertEqual(frameStats.Frames[0].TotalWood as Number, 10);
    Test.assert(compareWoodShots(frameStats.Frames[0].WoodShots, [5, 3, 2]));
    return true;
}

(:test)
function twoDifferentFramesGetFrameStats(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    theGame.AddShot(5);
    theGame.AddShot(4);
    theGame.AddShot(3);
    theGame.AddShot(2);
    var frameStats = theGame.GetFrameStats();
    Test.assertEqual(frameStats.Frames.size(), 2);
    Test.assertEqual(frameStats.Frames[0].TotalWood as Number, 9);
    Test.assert(compareWoodShots(frameStats.Frames[0].WoodShots, [5, 4]));
    Test.assertEqual(frameStats.Frames[1].TotalWood as Number, 5);
    Test.assert(compareWoodShots(frameStats.Frames[1].WoodShots, [3, 2]));
    return true;
}

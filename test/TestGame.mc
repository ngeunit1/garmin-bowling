import Toybox.Lang;
import Toybox.Test;

(:test)
function createFrame(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    var theFrame = new Frame(theGame);
    Test.assertEqual(theFrame.Bowled, false);
    Test.assertEqual(theFrame.ScoreReady, false);
    return true;
}

(:test)
function addShotLessThan10(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    var theFrame = new Frame(theGame);
    theFrame.addShot(5);
    Test.assertEqual(theFrame.Bowled, false);
    Test.assertEqual(theFrame.ScoreReady, false);
    return true;
}

(:test)
function addTwoShotLessThan10(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    var theFrame = new Frame(theGame);
    theFrame.addShot(5);
    theFrame.addShot(4);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.ScoreReady, true);
    return true;
}

(:test)
function addThreeShotLessThan10(logger as Logger) as Boolean {
    var theGame = new Game(CANDLEPIN);
    var theFrame = new Frame(theGame);
    theFrame.addShot(3);
    theFrame.addShot(3);
    theFrame.addShot(3);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.ScoreReady, true);
    return true;
}

(:test)
function addShotStrike(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    var theFrame = new Frame(theGame);
    theFrame.addShot(10);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.ScoreReady, false);
    return true;
}

(:test)
function addShotSpare(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    var theFrame = new Frame(theGame);
    theFrame.addShot(9);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.ScoreReady, false);
    return true;
}

(:test)
function addThreeShotsEqual10(logger as Logger) as Boolean {
    var theGame = new Game(DUCKPIN);
    var theFrame = new Frame(theGame);
    theFrame.addShot(8);
    theFrame.addShot(1);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.ScoreReady, true);
    return true;
}

(:test)
function addShotErrorTooManyShots(logger as Logger) as Boolean {
    var theGame = new Game(TENPIN);
    var theFrame = new Frame(theGame);
    theFrame.addShot(8);
    theFrame.addShot(1);
    try {
        theFrame.addShot(1);
    } catch (e instanceof InvalidFrameException) {
        return true;
    }
    return false;
}
import Toybox.Lang;
import Toybox.Test;

(:test)
function createFrame(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    Test.assertEqual(theFrame.Bowled, false);
    return true;
}

(:test)
function addShotLessThan10(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(5);
    Test.assertEqual(theFrame.Bowled, false);
    return true;
}

(:test)
function addTwoShotLessThan10(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(5);
    theFrame.addShot(4);
    Test.assertEqual(theFrame.Bowled, true);
    return true;
}

(:test)
function addThreeShotLessThan10(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(3);
    theFrame.addShot(3);
    theFrame.addShot(3);
    theFrame.addShot(3);
    Test.assertEqual(theFrame.Bowled, true);
    return true;
}

(:test)
function addShotStrike(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(10);
    Test.assertEqual(theFrame.Bowled, true);
    return true;
}

(:test)
function addShotSpare(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(9);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    return true;
}

(:test)
function addThreeShotsEqual10(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(3);
    theFrame.addShot(8);
    theFrame.addShot(1);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    return true;
}

(:test)
function addShotErrorTooManyShots(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(8);
    theFrame.addShot(1);
    try {
        theFrame.addShot(1);
    } catch (e instanceof InvalidFrameException) {
        return true;
    }
    return false;
}
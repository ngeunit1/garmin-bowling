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
function addShotLessThan10Candlepin(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(3);
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
    Test.assertEqual(theFrame.GetBowledWood(), 9);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
    Test.assert(compareWoodShots(theFrame.GetWood(), [5, 4]));
    return true;
}

(:test)
function addTwoShotLessThan10Candlepin(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(3);
    theFrame.addShot(5);
    theFrame.addShot(4);
    Test.assertEqual(theFrame.Bowled, false);
    return true;
}

(:test)
function addThreeShotLessThan10(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(3);
    theFrame.addShot(3);
    theFrame.addShot(3);
    theFrame.addShot(3);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 9);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
    Test.assert(compareWoodShots(theFrame.GetWood(), [3, 3, 3]));
    return true;
}

(:test)
function addShotStrike(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(STRIKE);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), STRIKE);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 2);
    return true;
}

(:test)
function addShotStrikeCandlepin(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(3);
    theFrame.addShot(STRIKE);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), STRIKE);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 2);
    return true;
}

(:test)
function addShotSpare(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(9);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 10);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 1);
    return true;
}

(:test)
function addShotSpareCandlepin(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(3);
    theFrame.addShot(9);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 10);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 1);
    return true;
}

(:test)
function addThreeShotsEqual10(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(3);
    theFrame.addShot(8);
    theFrame.addShot(1);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 10);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
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
    logger.debug("Expected InvalidFrameException was not thrown");
    return false;
}

(:test)
function addShotErrorGetBowledWoodNotBowled(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(8);
    try {
        theFrame.GetBowledWood();
    } catch (e instanceof InvalidFrameException) {
        return true;
    }
    logger.debug("Expected InvalidFrameException was not thrown");
    return false;
}

(:test)
function addShotErrorGetBonusShotsNotBowled(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(8);
    try {
        theFrame.GetNumberBonusShots();
    } catch (e instanceof InvalidFrameException) {
        return true;
    }
    logger.debug("Expected InvalidFrameException was not thrown");
    return false;
}

(:test)
function addShotErrorGetWoodNotBowled(logger as Logger) as Boolean {
    var theFrame = new NormalFrame(2);
    theFrame.addShot(8);
    try {
        theFrame.GetWood();
    } catch (e instanceof InvalidFrameException) {
        return true;
    }
    logger.debug("Expected InvalidFrameException was not thrown");
    return false;
}

(:test)
function createTenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    Test.assertEqual(theFrame.Bowled, false);
    return true;
}

(:test)
function addShotLessThan10TenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    theFrame.addShot(5);
    Test.assertEqual(theFrame.Bowled, false);
    return true;
}

(:test)
function addTwoShotLessThan10TenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    theFrame.addShot(5);
    theFrame.addShot(4);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 9);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
    return true;
}

(:test)
function addThreeShotLessThan10TenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(3);
    theFrame.addShot(3);
    theFrame.addShot(3);
    theFrame.addShot(3);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 9);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
    return true;
}

(:test)
function addShotStrikeTenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    theFrame.addShot(STRIKE);
    Test.assertEqual(theFrame.Bowled, false);
    return true;
}

(:test)
function addShotStrikeTenthFrameCandlepin(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(3);
    theFrame.addShot(STRIKE);
    Test.assertEqual(theFrame.Bowled, false);
    return true;
}

(:test)
function addShotStrikeWithFillTenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    theFrame.addShot(STRIKE);
    theFrame.addShot(8);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 19);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
    return true;
}

(:test)
function addShotStrikeWithFillTenthFrameCandlepin(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(3);
    theFrame.addShot(STRIKE);
    theFrame.addShot(8);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 19);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
    return true;
}

(:test)
function addShotSpareTenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    theFrame.addShot(9);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, false);
    return true;
}

(:test)
function addShotSpareTenthFrameCandlepin(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(3);
    theFrame.addShot(9);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, false);
    return true;
}

(:test)
function addShotSpareWithFillTenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    theFrame.addShot(9);
    theFrame.addShot(1);
    theFrame.addShot(8);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 18);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
    return true;
}

(:test)
function addShotSpareWithFillTenthFrameCandlepin(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(3);
    theFrame.addShot(9);
    theFrame.addShot(1);
    theFrame.addShot(8);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 18);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
    return true;
}

(:test)
function addThreeShotsEqual10TenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(3);
    theFrame.addShot(8);
    theFrame.addShot(1);
    theFrame.addShot(1);
    Test.assertEqual(theFrame.Bowled, true);
    Test.assertEqual(theFrame.GetBowledWood(), 10);
    Test.assertEqual(theFrame.GetNumberBonusShots(), 0);
    return true;
}

(:test)
function addShotErrorTooManyShotsTenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    theFrame.addShot(8);
    theFrame.addShot(1);
    try {
        theFrame.addShot(1);
    } catch (e instanceof InvalidFrameException) {
        return true;
    }
    logger.debug("Expected InvalidFrameException was not thrown");
    return false;
}

(:test)
function addShotErrorGetBowledWoodNotBowledTenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    theFrame.addShot(8);
    try {
        theFrame.GetBowledWood();
    } catch (e instanceof InvalidFrameException) {
        return true;
    }
    logger.debug("Expected InvalidFrameException was not thrown");
    return false;
}

(:test)
function addShotErrorGetBonusShotsNotBowledTenthFrame(logger as Logger) as Boolean {
    var theFrame = new TenthFrame(2);
    theFrame.addShot(8);
    try {
        theFrame.GetNumberBonusShots();
    } catch (e instanceof InvalidFrameException) {
        return true;
    }
    logger.debug("Expected InvalidFrameException was not thrown");
    return false;
}

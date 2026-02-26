import Toybox.Lang;

class WoodDisplay {
    function initialize(display as Array<String>) {
        Display = display;
    }
    var Display as Array<String>;
}

class ScoreDisplay {
    function initialize(displayWood as Array<WoodDisplay>, runningTotal as Array<Number?>) {
        DisplayWood = displayWood;
        RunningTotal = runningTotal;
    }
    var DisplayWood as Array<WoodDisplay>;
    var RunningTotal as Array<Number?>;
}

class Score {
    function initialize(game as Game) {
        _game = game;
    }

    function GetScore() as ScoreDisplay {
        var frameStats = _game.GetFrameStats();
        var theRunningTotal = 0 as Number?;
        var runningTotal = new [frameStats.Frames.size()] as Array<Number?>;
        var woodDisplay = new WoodDisplay[frameStats.Frames.size()];
        for (var idx = 0; idx < frameStats.Frames.size(); idx++) {
            if (theRunningTotal == null || frameStats.Frames[idx].TotalWood == null) {
                theRunningTotal = null;
                runningTotal[idx] = null;
            } else {
                theRunningTotal += frameStats.Frames[idx].TotalWood as Number;
                runningTotal[idx] = theRunningTotal;
                woodDisplay[idx] = new WoodDisplay(frameStats.Frames[idx].WoodDisplay);
            }
        }
        return new ScoreDisplay(woodDisplay, runningTotal);
    }

    private var _game as Game;
}
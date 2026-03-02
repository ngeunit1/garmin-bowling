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
            woodDisplay[idx] = new WoodDisplay(self._getWoodDisplay(frameStats.Frames[idx].WoodShots));
            if (theRunningTotal == null || frameStats.Frames[idx].TotalWood == null) {
                theRunningTotal = null;
                runningTotal[idx] = null;
            } else {
                theRunningTotal += frameStats.Frames[idx].TotalWood as Number;
                runningTotal[idx] = theRunningTotal;
            }
        }
        return new ScoreDisplay(woodDisplay, runningTotal);
    }

    private function _getWoodDisplay(woodShots as Array<Number>) as Array<String> {
        var woodDisplay = new String[woodShots.size()];
        var culumativeWood = 0;
        for (var idx = 0; idx < woodShots.size(); idx++) {
            if (woodShots[idx] == null) {
                break;
            }
            var currentWood = woodShots[idx];
            culumativeWood += currentWood;
            if(culumativeWood == 10) {
                if(idx == 0) {
                    woodDisplay[idx] = "X";
                    break;
                } else if(idx == 1) {
                    woodDisplay[idx] = "/";
                    break;
                } else {
                    woodDisplay[idx] = currentWood.toString();
                    break;
                }
            }
            if (currentWood == 0) {
                woodDisplay[idx] = "-";
            } else {
                woodDisplay[idx] = currentWood.toString();
            }
        }
        return woodDisplay;
    }

    private var _game as Game;
}
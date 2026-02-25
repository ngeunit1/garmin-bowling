import Toybox.Lang;

enum GameTypes {
    TENPIN,
    CANDLEPIN,
    DUCKPIN
}

var shotsPerFrame as Dictionary<Number, Number> = {
    TENPIN => 2,
    CANDLEPIN => 3,
    DUCKPIN => 3
};

enum FrameStatus {
    FRAMENOTDONE,
    NEXTFRAME,
    ENDGAME
}

class InvalidGameType extends Lang.Exception {
    function initialize(errorMessage as String) {
        Exception.initialize();
        _errorMessage = errorMessage;
    }
    function getErrorMessage() {
        return _errorMessage;
    }
    private var _errorMessage as String;
}

function ShotsPerFrame(gameType as GameTypes) as Number {
    var numShots = shotsPerFrame[gameType];
    if (numShots == null) {
        throw new InvalidGameType("invalid game type");
    }
    return numShots;
}

class Game {
    function initialize(gameType as GameTypes) {
        GameType = gameType;
        _bonusShotsLeft = {} as Dictionary<Number, Number>;
        _bonusWood = {} as Dictionary<Number, Number>;
        _frames = new[10];
        _shotList = new[30];
        FrameNumber = 0;
        GameDone = false;
    }

    function StartGame() as Void {
        _frames[0] = new NormalFrame(ShotsPerFrame(GameType));
    }

    private function appendShot(wood as Number) as Void {
        var idx = 0;
        while (_shotList[idx] != null) {
            idx++;
        }
        _shotList[idx] = wood;
    }

    function AddShot(wood as Number) as FrameStatus {
        appendShot(wood);
        (_frames[FrameNumber] as Frame).addShot(wood);
        var frameNumbers = _bonusShotsLeft.keys();
        for (var keyIdx = 0; keyIdx < frameNumbers.size(); keyIdx++) {
            var frameNumber = frameNumbers[keyIdx];
            _bonusShotsLeft[frameNumber] = (_bonusShotsLeft[frameNumber] as Number) - 1;
            if ((_bonusShotsLeft[frameNumber] as Number) == 0) {
                _bonusShotsLeft.remove(frameNumber);
            }
            _bonusWood[frameNumber] = (_bonusWood[frameNumber] as Number) + wood;
        }
        return checkFrameStatus();
    }

    private function checkFrameStatus() as FrameStatus {
        var currentFrame = (_frames[FrameNumber] as Frame);
        if (currentFrame.Bowled && FrameNumber < 8) {
            _bonusWood[FrameNumber] = 0;
            if (currentFrame.GetNumberBonusShots() > 0) {
                _bonusShotsLeft[FrameNumber] = currentFrame.GetNumberBonusShots();
            }
            FrameNumber += 1;
            _frames[FrameNumber] = new NormalFrame(ShotsPerFrame(GameType));
            return NEXTFRAME;
        } else if (currentFrame.Bowled && FrameNumber == 8) {
            _bonusWood[FrameNumber] = 0;
            if (currentFrame.GetNumberBonusShots() > 0) {
                _bonusShotsLeft[FrameNumber] = currentFrame.GetNumberBonusShots();
            }
            FrameNumber += 1;
            _frames[FrameNumber] = new TenthFrame(ShotsPerFrame(GameType));
            return NEXTFRAME;
        } else if (currentFrame.Bowled && FrameNumber == 9) {
            _bonusWood[FrameNumber] = 0;
            GameDone = true;
            return ENDGAME;
        } else {
            return FRAMENOTDONE;
        }
    }

    function GetFrameStats() as FrameStats {
        var numFrames = 0;
        while (_frames[numFrames] != null && (_frames[numFrames] as Frame).Bowled) {
            numFrames++;
        }
        var frames = new Frame[numFrames];
        var bonusWoods = new Number[numFrames];
        for (var idx = 0; idx < numFrames; idx++) {
            frames[idx] = _frames[idx] as Frame;
            if (_bonusWood.hasKey(idx)) {
                bonusWoods[idx] = _bonusWood[idx] as Number;
            } else {
                bonusWoods[idx] = 0;
            }
        }
        return new FrameStats(frames, bonusWoods);
    }

    class FrameStats {
        function initialize(frames as Array<Frame>, bonusWoods as Array<Number>) {
            Frames = new SingleFrameStats[frames.size()];
            for (var idx = 0; idx < frames.size(); idx ++) {
                Frames[idx] = new SingleFrameStats(frames[idx], bonusWoods[idx]);
            }
        }

        class SingleFrameStats {
            function initialize(frame as Frame, bonusWood as Number) {
                _wood = frame.GetWood();
                RunningTotalWood = frame.GetBowledWood();
                RunningTotalWood += bonusWood;
                WoodDisplay = self.getWoodDisplay(_wood);
            }

            static private function getWoodDisplay(wood as Array<Number?>) as Array<Char> {
                var woodDisplay = new Char[wood.size()];
                var culumativeWood = 0;
                for (var idx = 0; idx < wood.size(); idx++) {
                    if (wood[idx] == null) {
                        break;
                    }
                    var currentWood = wood[idx] as Number;
                    culumativeWood += currentWood;
                    if(culumativeWood == 10) {
                        if(idx == 0) {
                            woodDisplay[idx] = 'X';
                            break;
                        } else if(idx == 1) {
                            woodDisplay[idx] = '/';
                            break;
                        } else {
                            woodDisplay[idx] = currentWood.toChar();
                            break;
                        }
                    }
                    if (currentWood == 0) {
                        woodDisplay[idx] = '-';
                    } else {
                        woodDisplay[idx] = currentWood.toChar();
                    }
                }
                return woodDisplay;
            } 

            
            var RunningTotalWood as Number;      
            var WoodDisplay as Array<Char>;
            private var _wood as Array<Number?>;
        }

        var Frames as Array<SingleFrameStats>;
    }

    public var GameType as GameTypes;
    public var GameDone as Boolean;
    public var FrameNumber as Number;
    private var _bonusShotsLeft as Dictionary<Number, Number>;
    private var _bonusWood as Dictionary<Number, Number>;
    private var _frames as Array<Frame?>;
    private var _shotList as Array<Number?>;
}

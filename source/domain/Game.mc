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

    public var GameType as GameTypes;
    public var GameDone as Boolean;
    public var FrameNumber as Number;
    private var _bonusShotsLeft as Dictionary<Number, Number>;
    private var _bonusWood as Dictionary<Number, Number>;
    private var _frames as Array<Frame?>;
    private var _shotList as Array<Number?>;
}
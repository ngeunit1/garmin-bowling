import Toybox.Lang;

class InvalidFrameException extends Lang.Exception {
    function initialize(errorMessage as String) {
        Exception.initialize();
        _errorMessage = errorMessage;
    }
    function getErrorMessage() {
        return _errorMessage;
    }
    private var _errorMessage as String;
}

class Frame {
    function initialize(game as Game) {
        _game = game;
        _gameType = game.GameType;
        Bowled = false;
        ScoreReady = false;
        _wood = new[ShotsPerFrame[_gameType]] as Array<Number?>;
        _currentShot = 0;
    }

    function addShot(wood as Number) as Void {
        if (Bowled) {
            throw new InvalidFrameException("Attempted to add shot to completed frame");
        }
        _wood[_currentShot] = wood;
        _totalBowledWood = _getTotalBowledWood();
        if (_currentShot == ShotsPerFrame[_gameType] - 1 || _totalBowledWood == 10) {
            Bowled = true;
            if (_totalBowledWood == 10) {
                if (_currentShot == 0) {
                    _bonusShots = 2;
                } else if (_currentShot == 1) {
                    _bonusShots = 1;
                } else {
                    _bonusShots = 0;
                    ScoreReady = true;
                }
            } else {
                _bonusShots = 0;
                ScoreReady = true;
            }
        } else {
            _currentShot += 1;
        }
    }

    private function _getTotalBowledWood() as Number {
        var totalWood = 0;
        for (var i = 0; i <= _currentShot; i++) {
            totalWood += _wood[i] as Number;
        }
        return totalWood;
    }

    var Bowled as Boolean;
    var ScoreReady as Boolean;
    var _bonusShots as Number?;
    var _bonusWood as Number?;
    var _currentShot as Number;
    var _cumulativeWood as Number?;
    var _display as String?;
    var _game as Game;
    var _gameType as GameTypes;
    var _totalBowledWood as Number?;
    var _totalWood as Number?;
    var _wood as Array<Number?>;
}
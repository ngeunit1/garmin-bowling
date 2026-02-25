import Toybox.Lang;

typedef Frame as interface {
    function addShot(wood as Number) as Void;
    function GetBowledWood() as Number;
    function GetNumberBonusShots() as Number;
    function GetWood() as Array<Number?>;
    var Bowled as Boolean;
};

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

class NormalFrame {
    function initialize(shotsPerFrame as Number) {
        _shotsPerFrame = shotsPerFrame;
        Bowled = false;
        _wood = new[_shotsPerFrame] as Array<Number?>;
        _currentShot = 0;
    }

    function addShot(wood as Number) as Void {
        if (Bowled) {
            throw new InvalidFrameException("Attempted to add shot to completed frame");
        }
        _wood[_currentShot] = wood;
        _totalBowledWood = _getTotalBowledWood();
        if (_totalBowledWood == 10) {
            Bowled = true;
            if (_currentShot == 0) {
                _bonusShots = 2;
            } else if (_currentShot == 1) {
                _bonusShots = 1;
            } else {
                _bonusShots = 0;
            }
        } else if (_currentShot == _shotsPerFrame - 1 ) {
            Bowled = true;
            _bonusShots = 0;
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

    function GetBowledWood() as Number {
        if (!Bowled) {
            throw new InvalidFrameException("Called GetBowledWood from non-bowled frame");
        }
        return _getTotalBowledWood();
    }

    function GetNumberBonusShots() as Number {
        if (!Bowled) {
            throw new InvalidFrameException("Called GetNumberBonusShots from non-bowled frame");
        }
        return _bonusShots as Number;
    }

    function GetWood() as Array<Number?> {
        if (!Bowled) {
            throw new InvalidFrameException("Called GetWood from non-bowled frame");
        }
        return _wood;
    }

    var Bowled as Boolean;
    private var _bonusShots as Number?;
    private var _currentShot as Number;
    private var _shotsPerFrame as Number;
    private var _totalBowledWood as Number?;
    private var _wood as Array<Number?>;
}

class TenthFrame {
    function initialize(shotsPerFrame as Number) {
        Bowled = false;
        _shotsPerFrame = shotsPerFrame;
        _wood = new[3] as Array<Number?>;
        _currentShot = 0;
    }

    function addShot(wood as Number) as Void {
        if (Bowled) {
            throw new InvalidFrameException("Attempted to add shot to completed frame");
        }
        _wood[_currentShot] = wood;
        _totalBowledWood = _getTotalBowledWood();
        if (_totalBowledWood < 10 && _currentShot == _shotsPerFrame-1) {
            Bowled = true;
        } else if (_currentShot == 2) {
            Bowled = true;
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

    function GetBowledWood() as Number {
        if (!Bowled) {
            throw new InvalidFrameException("Called GetBowledWood from non-bowled frame");
        }
        return _getTotalBowledWood();
    }
    function GetNumberBonusShots() as Number {
        if (!Bowled) {
            throw new InvalidFrameException("Called GetNumberBonusShots from non-bowled frame");
        }
        return 0;
    }

    function GetWood() as Array<Number?> {
        if (!Bowled) {
            throw new InvalidFrameException("Called GetWood from non-bowled frame");
        }
        return _wood;
    }

    var Bowled as Boolean;
    private var _currentShot as Number;
    private var _shotsPerFrame as Number;
    private var _totalBowledWood as Number?;
    private var _wood as Array<Number?>;
}
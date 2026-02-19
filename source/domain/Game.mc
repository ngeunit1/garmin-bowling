import Toybox.Lang;

enum GameTypes {
    TENPIN,
    CANDLEPIN,
    DUCKPIN
}

var ShotsPerFrame as Dictionary = {
    TENPIN => 2,
    CANDLEPIN => 3,
    DUCKPIN => 3
};

class Game {
    function initialize(gameType as GameTypes) {
        GameType = gameType;
        _frames = new[10];
    }

    function startGame() as Void {
        _frames[0] = new Frame(self);
        _frameNumber = 0;
    }

    function addShot(wood as Number) as Void {
        (_frames[_frameNumber as Number] as Frame).addShot(wood);
    }

    public var GameType as GameTypes;
    private var _frameNumber as Number?;
    private var _frames as Array<Frame?>;  
}
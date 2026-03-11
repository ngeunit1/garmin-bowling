import Toybox.Lang;
import Toybox.WatchUi;

class GameSettings {
    function initialize() {
        Bumpers = false;
        LeagueLanes = false;
    }
    var Bumpers as Boolean;
    var LeagueLanes as Boolean;
}

class GameSettingsDelegate extends WatchUi.Menu2InputDelegate {
    function initialize(gameSettings as GameSettings) {
        Menu2InputDelegate.initialize();
        _gameSettings = gameSettings;
    }

    function onSelect(item) {
        if (item == :bumpers) {
            _gameSettings.Bumpers = !_gameSettings.Bumpers;
        } else if (item == :leagueLanes) {
            _gameSettings.LeagueLanes = !_gameSettings.LeagueLanes;
        }
    }
    private var _gameSettings as GameSettings;
}
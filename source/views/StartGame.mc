import Toybox.Lang;
import Toybox.WatchUi;

class StartGameDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }
}

class StartGameView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.StartGame(dc));
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }

}
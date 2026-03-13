import Toybox.Lang;
import Toybox.WatchUi;

class StartGameDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        WatchUi.pushView(new ThreeFrameView(), new ThreeFrameDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
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
import Toybox.Lang;
import Toybox.WatchUi;

class ThreeFrameDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }
}

class ThreeFrameView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.ThreeFrames(dc));
    }

    function onUpdate(dc) {
        View.onUpdate(dc);
    }

}
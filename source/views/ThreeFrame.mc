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
        _gt = Application.getApp().gt;
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.ThreeFrames(dc));
    }

    function onUpdate(dc) {
        if (_gt.gameType == TENPIN) {
            var frame0shot0 = View.findDrawableById("Frame0Shot0") as WatchUi.Drawable;
            frame0shot0.setVisible(false);
            var frame1shot0 = View.findDrawableById("Frame1Shot0") as WatchUi.Drawable;
            frame1shot0.setVisible(false);
            var frame2shot0 = View.findDrawableById("Frame2Shot0") as WatchUi.Drawable;
            frame2shot0.setVisible(false);
        }
        View.onUpdate(dc);
    }

    hidden var _gt as TheGameType;
}
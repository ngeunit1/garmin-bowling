import Toybox.Lang;
import Toybox.WatchUi;

class garminbowlingDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new garminbowlingMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}
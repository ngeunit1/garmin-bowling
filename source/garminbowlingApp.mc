import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class garminbowlingApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
        gs = new GameSettings();
        gt = new TheGameType();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var factory = new GameTypeFactory();
        var picker = new WatchUi.Picker({
            :title => new WatchUi.Text({
                :text=>"Game Type",
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_TOP,
                :color=>Graphics.COLOR_WHITE
            }),
            :pattern => [factory],
        });
        return [ picker, new GameTypePickerDelegate(gt) ];
    }

    var gt as TheGameType;
    var gs as GameSettings;
}

function getApp() as garminbowlingApp {
    return Application.getApp() as garminbowlingApp;
}
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class TheGameType {
    function initialize() {
        theGameType = null; 
    }
    var theGameType as String?;
}

class GameTypePickerDelegate extends WatchUi.PickerDelegate {
    function initialize(gt as TheGameType) {
        PickerDelegate.initialize();
        _gt = gt;
    }

    function onAccept(values) {
        System.println("Selected: " + values[0] as String);
        _gt.theGameType = values[0] as String;
        WatchUi.pushView(new Rez.Menus.GameSettings(), new GameSettingsDelegate(Application.getApp().gs), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    private var _gt as TheGameType;
}

class GameTypeFactory extends WatchUi.PickerFactory {
    function initialize() {
        PickerFactory.initialize();
    }

    function getDrawable(item as Number, isSelected as Boolean) {
        return new WatchUi.Text({
            :text=>_gameTypes[item],
            :color=>Graphics.COLOR_WHITE,   
            :font=>Graphics.FONT_LARGE,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER,
        });
    }

    function getSize() as Number { return _gameTypes.size(); }
    function getValue(item) { return _gameTypes[item]; }

    private var _gameTypes as Array<String> = ["Tenpin", "Candlepin", "Duckpin"];
}

function getPicker (gt as TheGameType) as Void {
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
    WatchUi.pushView(picker, new GameTypePickerDelegate(gt), WatchUi.SLIDE_IMMEDIATE);
}
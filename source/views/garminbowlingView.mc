import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class TheGameType {
    function initialize() {
        theGameType = null; 
    }
    var theGameType as String?;
}

class garminbowlingView extends WatchUi.View {

    function initialize() {
        View.initialize();
        _gt = new TheGameType();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        getPicker(_gt);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    private var _gt as TheGameType;
}

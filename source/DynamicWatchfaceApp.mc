using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;

var SETTINGSCHANGED as Lang.Boolean = false;

class DynamicWatchfaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // Return the initial view of your application here
    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [ new DynamicWatchfaceView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        SETTINGSCHANGED = true;
        WatchUi.requestUpdate();
    }

}

function getApp() as DynamicWatchfaceApp {
    return Application.getApp() as DynamicWatchfaceApp;
}
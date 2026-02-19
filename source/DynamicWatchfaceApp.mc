import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

var SETTINGSCHANGED as Boolean = false;

class DynamicWatchfaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new DynamicWatchfaceView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        SETTINGSCHANGED = true;
        WatchUi.requestUpdate();
    }

    function onInactive(state as Dictionary or Null) as Void {
        
    }

}

function getApp() as DynamicWatchfaceApp {
    return Application.getApp() as DynamicWatchfaceApp;
}
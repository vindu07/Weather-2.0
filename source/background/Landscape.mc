using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.Application.Properties;

class Landscape extends Ui.Drawable {


    private var mx;
    private var my;

    private var energySavingMode;

    private var landscapeBitmap;

    private enum Landscapes {
        LANDSCAPE_MOUNTAINS,
        LANDSCAPE_HILLS,
        LANDSCAPE_BEACH,
        LANDSCAPE_LONDON,
        LANDSCAPE_PARIS,
        LANDSCAPE_VENICE,
        LANDSCAPE_ROME
    }


    function initialize(params as Lang.Dictionary){
        Drawable.initialize(params);

        mx = params[:x];
        my = params[:y];
        getAppSettings();
    }

    public function draw(dc as Gfx.Dc){

        if(SETTINGSCHANGED){
            getAppSettings();
        }
            
    
        dc.drawBitmap(mx, my, landscapeBitmap);
    }

    private function getLandscape(){
        
        
        if(energySavingMode){
            self.landscapeBitmap = WatchUi.loadResource(Rez.Drawables.EnergysavingBackground);
        }
        else{

            var bitmap;
            var landscape = Properties.getValue("LandscapeType") as Landscapes;

            switch(landscape){
                case LANDSCAPE_MOUNTAINS:
                    bitmap = WatchUi.loadResource(Rez.Drawables.MountainBackground);
                    break;
                case LANDSCAPE_HILLS:
                    bitmap = WatchUi.loadResource(Rez.Drawables.CountryBackground);
                    break;
                case LANDSCAPE_BEACH:
                    bitmap = WatchUi.loadResource(Rez.Drawables.BeachBackground);
                    break;
                case LANDSCAPE_LONDON:
                    bitmap = WatchUi.loadResource(Rez.Drawables.LondonBackground);
                    break;
                case LANDSCAPE_PARIS:
                    bitmap = WatchUi.loadResource(Rez.Drawables.ParisBackground);
                    break;
                case LANDSCAPE_ROME:
                    bitmap = WatchUi.loadResource(Rez.Drawables.RomeBackground);
                    break;
                case LANDSCAPE_VENICE:
                    bitmap = WatchUi.loadResource(Rez.Drawables.VeniceBackground);
                    break;   
                default:
                    bitmap = WatchUi.loadResource(Rez.Drawables.MountainBackground);
            }

            landscapeBitmap = bitmap;
        }
    }

    private function getAppSettings(){
        energySavingMode = Properties.getValue("EnergySavingMode");

        getLandscape();
    }
}
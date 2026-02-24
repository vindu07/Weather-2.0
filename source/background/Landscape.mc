using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi as Ui;

class Landscape extends Ui.Drawable {


    private var _x;
    private var _y;
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

        _x = params[:x];
        _y = params[:y];
        getAppSettings();
    }

    public function draw(dc as Gfx.Dc){

        if(SETTINGSCHANGED){
            getAppSettings();
        }
            
    
        dc.drawBitmap(_x, _y, landscapeBitmap);
    }

    private function getLandscape(){
        try{
            if(energySavingMode){
                self.landscapeBitmap = WatchUi.loadResource(Rez.Drawables.EnergysavingBackground);
            }
            else{

                var bitmap;
                var landscape = Properties.getValue("LandscapeType");

                if(landscape == null){
                    System.println("WARNING -- Landscape.getLandscape -- LandscapeType is null, defaulting to MOUNTAINS");
                    landscape = LANDSCAPE_MOUNTAINS;
                }

                switch(landscape as Landscapes){
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
        catch(ex){
            System.println("ERROR -- Landscape.getLandscape -- " + ex.getErrorMessage());
            landscapeBitmap = WatchUi.loadResource(Rez.Drawables.MountainBackground);
        }
    }

    private function getAppSettings(){
        try{
            var enSave = Properties.getValue("EnergySavingMode");
            energySavingMode = (enSave != null) ? enSave : false;
            getLandscape();
        }
        catch(ex){
            System.println("ERROR -- Landscape.getAppSettings -- " + ex.getErrorMessage());
            energySavingMode = false;
        }
    }
}
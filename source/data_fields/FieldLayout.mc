using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.Graphics as Gfx;
import Toybox.Application;


class FieldLayout extends Ui.Drawable { 

    private var showFields as Lang.Boolean = false;

    private var my;
    private var mcolor;

    function initialize(params as Lang.Dictionary){
        Drawable.initialize(params);
        getAppSettings();

        my = params[:y] as Lang.Number;

    }

    function draw(dc as Gfx.Dc) as Void{

        if(SETTINGSCHANGED){
            getAppSettings();
        }

        if(showFields){
            dc.setColor(mcolor, Gfx.COLOR_TRANSPARENT);

            dc.setPenWidth(3);
            dc.drawLine(0, my, dc.getWidth(), my);

            dc.setPenWidth(2);
            dc.drawLine(0, my+5, dc.getWidth(), my+5);

            dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(50, my-2, 260-50*2, 9);

            dc.setPenWidth(1);
        }
     
    }


    function getAppSettings() as Void{

        mcolor = Properties.getValue("FieldColor");

        showFields = Properties.getValue("ShowDataFields") as Lang.Boolean;
    }

}
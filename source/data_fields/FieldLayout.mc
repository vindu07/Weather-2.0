using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.WatchUi as Ui;


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
        try{
            var fieldColor = Properties.getValue("FieldColor");
            mcolor = (fieldColor != null) ? fieldColor : Gfx.COLOR_WHITE;

            var sFields = Properties.getValue("ShowDataFields");
            self.showFields = (sFields != null) ? sFields : false;
        }
        catch(ex){
            System.println("ERROR -- FieldLayout.getAppSettings -- " + ex.getErrorMessage());
            mcolor = Gfx.COLOR_WHITE;
            self.showFields = false;
        }
    }

}
using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Graphics as Gfx;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi as Ui;


class BatteryIndicator extends Ui.Drawable { 

    private var drawBattery as Lang.Boolean = false;

    private var indicatorColor as Lang.Number = 0xFFFFFF;
    private var percentBattery as Lang.Number = System.getSystemStats().battery.toNumber() as Lang.Number;

    private var fullColor as Lang.Number = 0x00FF00;
    private var goodColor as Lang.Number = 0xFFFFFF;
    private var medColor as Lang.Number = 0xFFFFFF;
    private var lowColor as Lang.Number = 0xFF0000;
    private var extremelyLowColor as Lang.Number = 0xFF0000;

    private var fullPercent as Lang.Number = 80;
    private var goodPercent as Lang.Number = 50;
    private var medPercent as Lang.Number = 20;
    private var lowPercent as Lang.Number = 10;

    private var mx;
    private var my;
    private var mheight;
    private var mwidth;
   
   
    function initialize(params as Lang.Dictionary){
        Drawable.initialize(params);
        getAppSettings();

        mx = params[:x] as Lang.Number;
        my = params[:y] as Lang.Number;
        mheight = params[:height] as Lang.Number;
        mwidth = params[:width] as Lang.Number;
    }

    function draw(dc as Gfx.Dc) as Void{

        if(SETTINGSCHANGED){
            getAppSettings();
        }
        
        if(drawBattery){
            getIndicatorColor();

            drawIndicator(dc);
        }
    }

    function getIndicatorColor() as Void{
        percentBattery = System.getSystemStats().battery.toNumber() as Lang.Number;

        if(percentBattery >= fullPercent){
            indicatorColor = fullColor;
        }
        else if(percentBattery >= goodPercent){
            indicatorColor = goodColor;
        }
        else if(percentBattery >= medPercent){
            indicatorColor = medColor;
        }
        else if(percentBattery >= lowPercent){
            indicatorColor = lowColor;
        }
        else{
            indicatorColor = extremelyLowColor;
        }
    }

    function drawIndicator(dc as Gfx.Dc) as Void{
        var fillLength = (percentBattery/100.0)*(mwidth-4);

        if(percentBattery < lowPercent){
             dc.setColor(extremelyLowColor, Gfx.COLOR_TRANSPARENT);
        }
        else{
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        }
        // Draw the icon
        dc.drawRoundedRectangle(mx, my, mwidth, mheight, 2);
        dc.drawLine(mx+mwidth+1, my+(mheight-4)/2, mx+mwidth+1, my+(mheight-4)/2+4);


        // Fill with the percentage
        dc.setColor(indicatorColor, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(mx+2, my+2, fillLength, mheight-4);

    }

    function getAppSettings() as Void{
        try{
            var drawBatt = Properties.getValue("ShowBatteryIcon");
            drawBattery = (drawBatt != null) ? drawBatt : false;

            var fullCol = Properties.getValue("BatteryIndicatorFullColor");
            fullColor = (fullCol != null) ? fullCol : 0x00FF00;
            
            var goodCol = Properties.getValue("BatteryIndicatorGoodColor");
            goodColor = (goodCol != null) ? goodCol : 0xFFFFFF;
            
            var medCol = Properties.getValue("BatteryIndicatorMedColor");
            medColor = (medCol != null) ? medCol : 0xFFFFFF;
            
            var lowCol = Properties.getValue("BatteryIndicatorLowColor");
            lowColor = (lowCol != null) ? lowCol : 0xFF0000;
            
            var extremeCol = Properties.getValue("BatteryIndicatorExtremelyLowColor");
            extremelyLowColor = (extremeCol != null) ? extremeCol : 0xFF0000;

            var fullPerc = Properties.getValue("BatteryIndicatorFull");
            fullPercent = (fullPerc != null) ? fullPerc : 80;
            
            var goodPerc = Properties.getValue("BatteryIndicatorGood");
            goodPercent = (goodPerc != null) ? goodPerc : 50;
            
            var medPerc = Properties.getValue("BatteryIndicatorMed");
            medPercent = (medPerc != null) ? medPerc : 20;
            
            var lowPerc = Properties.getValue("BatteryIndicatorLow");
            lowPercent = (lowPerc != null) ? lowPerc : 10;
        }
        catch(ex){
            System.println("ERROR -- BatteryIndicator.getAppSettings -- " + ex.getErrorMessage());
            drawBattery = false;
        }
    }

}
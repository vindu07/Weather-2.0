using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.Graphics as Gfx;
import Toybox.Application;


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
        //disegno l'icona
        dc.drawRoundedRectangle(mx, my, mwidth, mheight, 2);
        dc.drawLine(mx+mwidth+1, my+(mheight-4)/2, mx+mwidth+1, my+(mheight-4)/2+4);


        //riempio con la percentuale
        dc.setColor(indicatorColor, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(mx+2, my+2, fillLength, mheight-4);

    }

    function getAppSettings() as Void{

        drawBattery = Properties.getValue("ShowBatteryIcon") as Lang.Boolean;

        fullColor = Properties.getValue("BatteryIndicatorFullColor") as Lang.Number;
        goodColor = Properties.getValue("BatteryIndicatorGoodColor") as Lang.Number;
        medColor = Properties.getValue("BatteryIndicatorMedColor") as Lang.Number;
        lowColor = Properties.getValue("BatteryIndicatorLowColor") as Lang.Number;
        extremelyLowColor = Properties.getValue("BatteryIndicatorExtremelyLowColor") as Lang.Number;

        fullPercent = Properties.getValue("BatteryIndicatorFull") as Lang.Number;
        goodPercent = Properties.getValue("BatteryIndicatorGood") as Lang.Number;
        medPercent = Properties.getValue("BatteryIndicatorMed") as Lang.Number;
        lowPercent = Properties.getValue("BatteryIndicatorLow") as Lang.Number; 
    }

}
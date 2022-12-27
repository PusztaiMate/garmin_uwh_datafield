import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Math;
import Toybox.Time;

class UWHView extends WatchUi.DataField {

    hidden var pressureValue as Numeric;
    hidden var fitContributions = new FitContributions(self);

    function initialize() {
        DataField.initialize();
        pressureValue = 0.0f;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            System.println("Top left");
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            System.println("Top right");
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            System.println("Bottom left");
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            System.println("Bottom right");
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 16;
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 7;
        }

        (View.findDrawableById("label") as Text).setText(Rez.Strings.label);
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        // See Activity.Info in the documentation for available information.
        if(info has :rawAmbientPressure){
            if(info.rawAmbientPressure != null){
                pressureValue = info.rawAmbientPressure as Number;
            } else {
                System.println("rawAmbientPressure is null, sumulating pressure value");
                pressureValue = simulatePressureValue(info.elapsedTime);
            }
            fitContributions.setPressureData(pressureValue);
        }
    }

    function simulatePressureValue(elapsedTime as Number) as Lang.Float {
        var currentTime = elapsedTime as Number;
        // create a sin curve using the current time
        var sinValue = ((Math.sin(currentTime / 1000.0f) + 1.0f) * 10000.0f) + 100000.0f;
        return sinValue;
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        // Set the background color
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        // Set the foreground color and value
        var value = View.findDrawableById("value") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
        }
        value.setText(pressureValue.format("%.2f"));

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

    function onNextMultisportLeg() {
    	fitContributions.onNextMultisportLeg();
    }
    
    function onTimerLap() {
    	fitContributions.onTimerLap();
    }
    
    function onTimerReset() {
    	fitContributions.onTimerReset();
    }
    
    function onTimerPause() {
    	fitContributions.onTimerPause();
    }
    
    function onTimerResume() {
    	fitContributions.onTimerResume();
    }
    
    function onTimerStart() {
    	fitContributions.onTimerStart();
    }
    
    function onTimerStop() {
    	fitContributions.onTimerStop();
    }
}

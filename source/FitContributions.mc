import Toybox.System;

using Toybox.WatchUi;
using Toybox.FitContributor as Fit;

const PRESSURE_FIELD_RECORD_ID = 0;

const PRESSURE_RATE_UNITS = "Pa";

class FitContributions {

    hidden var pressureRecordField;
    
	hidden var timerRunning = false;
	hidden var sessionStats;
	hidden var lapStats;

    function initialize(dataField) {
        pressureRecordField = dataField.createField(
            "pressure",
            PRESSURE_FIELD_RECORD_ID,
            Fit.DATA_TYPE_FLOAT,
            {
                :mesgType=>Fit.MESG_TYPE_RECORD,
                :units=>PRESSURE_RATE_UNITS
            }
        );
        
		sessionStats = new MinMaxAvg();
		lapStats = new MinMaxAvg();
    }
    
    function setPressureData(pressure) as Void {
    	pressureRecordField.setData(pressure > 0.0 ? pressure : 0xFF);
    	
    	if(timerRunning) {
    		sessionStats.addData(pressure);
    		lapStats.addData(pressure);
    	}
    }
    
    function onNextMultisportLeg() {
    	sessionStats.reset();
    	lapStats.reset();
    }

    function onTimerLap() {
    	lapStats.reset();
    }
    
    function onTimerReset() {
    	sessionStats.reset();
    	lapStats.reset();
    }
    
    function onTimerPause() {
    	timerRunning = false;
    }
    
    function onTimerResume() {
        timerRunning = true;
    }
    
    function onTimerStart() {
        timerRunning = true;
    }

    function onTimerStop() {
        timerRunning = false;
    } 
}

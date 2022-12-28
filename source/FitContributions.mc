import Toybox.System;

using Toybox.WatchUi;
using Toybox.FitContributor as Fit;

const PRESSURE_FIELD_RECORD_ID = 0;
const RELATIVE_POSITION_FIELD_RECORD_ID = 1;

const PRESSURE_RATE_UNITS = "Pa";
const RELATIVE_POSITION_UNITS = "0/1/2";

class FitContributions {

    hidden var pressureRecordField;
    hidden var relativePositionRecordField;
    
	hidden var timerRunning = false;
	hidden var sessionStats;
	hidden var lapStats;

    hidden var pressureConverter = new UWHPressureConverter();

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

        relativePositionRecordField = dataField.createField(
            "relativePosition",
            RELATIVE_POSITION_FIELD_RECORD_ID,
            Fit.DATA_TYPE_UINT8,
            {
                :mesgType=>Fit.MESG_TYPE_RECORD,
                :units=>RELATIVE_POSITION_UNITS
            }
        );
        
		sessionStats = new MinMaxAvg();
		lapStats = new MinMaxAvg();
    }
    
    function setPressureData(pressure) as Void {
    	pressureRecordField.setData(pressure > 0.0 ? pressure : -0.0);

    	if(timerRunning) {
    		sessionStats.addData(pressure);
    		lapStats.addData(pressure);
            relativePositionRecordField.setData(pressureConverter.convertToRelativePosition(sessionStats, pressure).toNumber());
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

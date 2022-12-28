import Toybox.Lang;

class MinMaxAvg {
    hidden var min as Lang.Float;
    hidden var max as Lang.Float;
    hidden var avg as Lang.Float;
    hidden var count as Lang.Number;

    function initialize() {
        System.println("initializing MinMaxAvg");
        min = 0.0f;
        max = 0.0f;
        avg = 0.0f;
        count = 0;
        System.println("initialized MinMaxAvg");
    }

    function addData(value as Lang.Float) {
        if (count == 0)
        {
            min = value;
            max = value;
            avg = value;
        }
        else
        {
            min = min < value ? min : value;
            max = max > value ? max : value;
            avg = (avg * count + value) / (count + 1);
        }
        count += 1;
    }

    function reset() as Void {
        min = 0.0f;
        max = 0.0f;
        avg = 0.0f;
        count = 0;
    }

    function minimum() as Lang.Float {
        return min;
    }

    function maximum() as Lang.Float {
        return max;
    }

    function average() as Lang.Float {
        return avg;
    }
}
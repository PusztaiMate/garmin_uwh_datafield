import Toybox.Lang;

enum RelativePosition {
    RP_FLOATING = 0,
    RP_UNDERWATER = 1,
    RP_BOTTOM = 2
}

class UWHPressureConverter {
    function convertToRelativePosition(referenceFrame as MinMaxAvg, value as Lang.Float) as RelativePosition {
        var depth = referenceFrame.maximum() - referenceFrame.minimum();
        // when smaller than 1m, we use ratios instead of fixed values
        if (depth < 15000) {
            if (value < depth * 0.5)
            {
                return RP_FLOATING;
            }
            else if (value < depth * 0.7)
            {
                return RP_UNDERWATER;
            }
            else
            {
                return RP_BOTTOM;
            }
        }
        else {
            if (value < (referenceFrame.minimum() + 10000))
            {
                return RP_FLOATING;
            }
            else if (value < (referenceFrame.maximum() - 5000))
            {
                return RP_UNDERWATER;
            }
            else
            {
                return RP_BOTTOM;
            }
        }
    }
}

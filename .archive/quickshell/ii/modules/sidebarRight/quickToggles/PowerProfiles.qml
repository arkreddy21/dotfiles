import Quickshell.Services.UPower
import qs.modules.common
import qs.modules.common.widgets
import qs
import Quickshell.Io
import Quickshell

QuickToggleButton {
    toggled: PowerProfiles.profile != PowerProfile.Balanced
    buttonIcon: {
        switch (PowerProfiles.profile) {
        case PowerProfile.PowerSaver:
            return "battery_saver";
        case PowerProfile.Balanced:
            return "dynamic_form";
        case PowerProfile.Performance:
            return "speed";
        }
    }
    onClicked: {
        if (PowerProfiles.hasPerformanceProfile) {
            switch (PowerProfiles.profile) {
            case PowerProfile.PowerSaver:
                PowerProfiles.profile = PowerProfile.Balanced;
                break;
            case PowerProfile.Balanced:
                PowerProfiles.profile = PowerProfile.Performance;
                break;
            case PowerProfile.Performance:
                PowerProfiles.profile = PowerProfile.PowerSaver;
                break;
            }
        } else {
            PowerProfiles.profile = PowerProfiles.profile == PowerProfile.Balanced ? PowerProfile.PowerSaver : PowerProfile.Balanced;
        }
    }
    StyledToolTip {
        text: switch (PowerProfiles.profile) {
                    case PowerProfile.PowerSaver:
                        return "power saver";
                    case PowerProfile.Balanced:
                        return "balanced";
                    case PowerProfile.Performance:
                        return "performance";
                }
    }
}

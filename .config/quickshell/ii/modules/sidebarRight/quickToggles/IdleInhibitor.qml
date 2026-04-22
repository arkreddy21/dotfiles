import qs.modules.common.widgets
import qs
import qs.services

QuickToggleButton {
    id: root
    toggled: Idle.inhibit
    buttonIcon: "coffee"
    onClicked: {
        if (!toggled) {
            root.toggled = true
            Quickshell.execDetached(["pkill", "hypridle"])
        } else {
            root.toggled = false
            Quickshell.execDetached(["pkill", "hypridle"])
            Quickshell.execDetached(["hypridle"])
        }
    }
    
    StyledToolTip {
        text: Translation.tr("Keep system awake")
    }

}

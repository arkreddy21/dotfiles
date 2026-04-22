import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { MaterialIcon } from "./materialicon.js";
import { AnimatedCircProg } from "./cairo_circularprogress.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
const { execAsync } = Utils;

export const BarResource = (
    name,
    icon,
    command,
    circprogClassName = "bar-batt-circprog",
    textClassName = "txt-onSurfaceVariant",
    iconClassName = "bar-batt"
  ) => {
    const resourceCircProg = AnimatedCircProg({
      className: `${circprogClassName}`,
      vpack: "center",
      hpack: "center",
    });
    const resourceProgress = Widget.Box({
      homogeneous: true,
      children: [
        Widget.Overlay({
          child: Widget.Box({
            vpack: "center",
            className: `${iconClassName}`,
            homogeneous: true,
            children: [MaterialIcon(icon, "small")],
          }),
          overlays: [resourceCircProg],
        }),
      ],
    });
    const resourceLabel = Widget.Label({
      className: `txt-smallie ${textClassName}`,
    });
    const widget = Widget.Button({
      onClicked: () =>
        Utils.execAsync(["bash", "-c", `${userOptions.apps.taskManager}`]).catch(
          print
        ),
      child: Widget.Box({
        className: `spacing-h-4 ${textClassName}`,
        children: [resourceProgress, resourceLabel],
        setup: (self) => {
          // Check if the widget is visible
          if (self.visible) {
            self.poll(5000, () => {
              execAsync(["bash", "-c", command])
                .then((output) => {
                  resourceCircProg.css = `font-size: ${Number(output)}px;`;
                  resourceLabel.label = `${Math.round(Number(output))}%`;
                  widget.tooltipText = `${name}: ${Math.round(Number(output))}%`;
                })
                .catch(print);
            });
          }
        },
      }),
    });
    return widget;
  };
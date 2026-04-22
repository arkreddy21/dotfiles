import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';

import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
const { execAsync } = Utils;
import Indicator from '../../../services/indicator.js';
import { StatusIcons } from '../../.commonwidgets/statusicons.js';
import { Tray } from './tray.js';
import { BarBattery } from './system.js';

const SeparatorDotOld = () =>
	Widget.Revealer({
		transition: 'slide_left',
		revealChild: false,
		attribute: {
			count: SystemTray.items.length,
			update: (self, diff) => {
				self.attribute.count += diff;
				self.revealChild = self.attribute.count > 0;
			},
		},
		child: Widget.Box({
			vpack: 'center',
			className: 'separator-circle',
		}),
		setup: (self) =>
			self
				.hook(SystemTray, (self) => self.attribute.update(self, 1), 'added')
				.hook(SystemTray, (self) => self.attribute.update(self, -1), 'removed'),
	});

const SeparatorDot = () =>
	Widget.Revealer({
		transition: 'slide_left',
		revealChild: false,
		child: Widget.Box({
			vpack: 'center',
			className: 'separator-circle',
		}),
		setup: (self) =>
			self.hook(SystemTray, (self) => {
				self.revealChild = SystemTray.items.length > 0;
			}),
	});

const RightBarGroup = (childs) =>
	Widget.Box({
		className: 'bar-group-margin bar-sides',
		children: [
			Widget.Box({
				className: 'bar-group bar-group-standalone bar-group-pad-system',
				children: [...childs],
			}),
		],
	});

export default (monitor = 0) => {
	const barTray = Tray();
	const barStatusIcons = StatusIcons(
		{
			className: 'bar-statusicons',
			setup: (self) =>
				self.hook(App, (self, currentName, visible) => {
					if (currentName === 'sideright') {
						self.toggleClassName('bar-statusicons-active', visible);
					}
				}),
		},
		monitor
	);
	const SpaceRightDefaultClicks = (child) =>
		Widget.EventBox({
			onHover: () => {
				barStatusIcons.toggleClassName('bar-statusicons-hover', true);
			},
			onHoverLost: () => {
				barStatusIcons.toggleClassName('bar-statusicons-hover', false);
			},
			onPrimaryClick: () => App.toggleWindow('sideright'),
			setup: (self) =>
				self.on('button-press-event', (self, event) => {
					if (event.get_button()[1] === 8) execAsync('playerctl previous').catch(print);
				}),
			child: child,
		});
	// const emptyArea = SpaceRightDefaultClicks(Widget.Box({ hexpand: true, }));
	const indicatorArea = SpaceRightDefaultClicks(
		Widget.Box({
			children: [SeparatorDot(), RightBarGroup([barStatusIcons, BarBattery()])],
		})
	);
	const actualContent = Widget.Box({
		hexpand: true,
		className: 'spacing-h-5 bar-spaceright',
		children: [
			// emptyArea,
			Widget.Box({ hexpand: true }), //empty area without ckick events
			barTray,
			indicatorArea,
		],
	});

	return Widget.EventBox({
		// Moved this to music widget
		// onScrollDown: () => {
		// 	if (!Audio.speaker) return;
		// 	Audio.speaker.volume += 0.01;
		// 	Indicator.popup(1);
		// },
		// onScrollUp: () => {
		// 	if (!Audio.speaker) return;
		// 	Audio.speaker.volume -= 0.01;
		// 	Indicator.popup(1);
		// },
		child: Widget.Box({
			children: [actualContent, SpaceRightDefaultClicks(Widget.Box({ className: 'bar-corner-spacing' }))],
		}),
	});
};

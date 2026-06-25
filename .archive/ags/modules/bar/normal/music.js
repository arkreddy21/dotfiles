import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
const { Box, Button, EventBox, Label, Overlay, Revealer, Scrollable } = Widget;
const { execAsync, exec } = Utils;
import { AnimatedCircProg } from '../../.commonwidgets/cairo_circularprogress.js';
import { MaterialIcon } from '../../.commonwidgets/materialicon.js';
import { BarGroup } from '../../.commonwidgets/bargroup.js';
import { showMusicControls } from '../../../variables.js';

const Mpris = await Service.import('mpris');

function trimTrackTitle(title) {
	if (!title) return '';
	const cleanPatterns = [
		/【[^】]*】/, // Touhou n weeb stuff
		' [FREE DOWNLOAD]', // F-777
	];
	cleanPatterns.forEach((expr) => (title = title.replace(expr, '')));
	return title;
}

const TrackProgress = () => {
	const _updateProgress = (circprog) => {
		const mpris = Mpris.getPlayer('');
		if (!mpris) return;
		// Set circular progress value
		circprog.css = `font-size: ${Math.max((mpris.position / mpris.length) * 100, 0)}px;`;
	};
	return AnimatedCircProg({
		className: 'bar-music-circprog',
		vpack: 'center',
		hpack: 'center',
		extraSetup: (self) => self.hook(Mpris, _updateProgress).poll(3000, _updateProgress),
	});
};

export default () => {
	// TODO: use cairo to make button bounce smaller on click, if that's possible
	const playingState = Box({
		// Wrap a box cuz overlay can't have margins itself
		homogeneous: true,
		children: [
			Overlay({
				child: Box({
					vpack: 'center',
					className: 'bar-music-playstate',
					homogeneous: true,
					children: [
						Label({
							vpack: 'center',
							className: 'bar-music-playstate-txt',
							justification: 'center',
							setup: (self) =>
								self.hook(Mpris, (label) => {
									const mpris = Mpris.getPlayer('');
									label.label = `${mpris !== null && mpris.playBackStatus == 'Playing' ? 'pause' : 'play_arrow'}`;
								}),
						}),
					],
					setup: (self) =>
						self.hook(Mpris, (label) => {
							const mpris = Mpris.getPlayer('');
							if (!mpris) return;
							label.toggleClassName('bar-music-playstate-playing', mpris !== null && mpris.playBackStatus == 'Playing');
							label.toggleClassName('bar-music-playstate', mpris !== null || mpris.playBackStatus == 'Paused');
						}),
				}),
				overlays: [TrackProgress()],
			}),
		],
	});
	const trackTitle = Label({
		hexpand: true,
		className: 'txt-smallie bar-music-txt',
		truncate: 'end',
		maxWidthChars: 1, // Doesn't matter, just needs to be non negative
		setup: (self) =>
			self.hook(Mpris, (label) => {
				const mpris = Mpris.getPlayer('');
				if (mpris) label.label = `${trimTrackTitle(mpris.trackTitle)} • ${mpris.trackArtists.join(', ')}`;
				else label.label = getString('No media');
			}),
	});
	const musicStuff = Box({
		className: 'spacing-h-10',
		hexpand: true,
		children: [playingState, trackTitle],
	});

	return Box({
		className: 'spacing-h-4',
		children: [
			EventBox({
				child: BarGroup({ child: musicStuff }),
				onScrollDown: () => {
					if (!Audio.speaker) return;
					Audio.speaker.volume += 0.01;
					Indicator.popup(1);
				},
				onScrollUp: () => {
					if (!Audio.speaker) return;
					Audio.speaker.volume -= 0.01;
					Indicator.popup(1);
				},
				onPrimaryClick: () => execAsync('playerctl play-pause').catch(print),
				onSecondaryClick: () => showMusicControls.setValue(!showMusicControls.value),
				onMiddleClick: () =>
					execAsync([
						'bash',
						'-c',
						'playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"` &',
					]).catch(print),
				setup: (self) => {
					self.hook(Mpris, (self) => {
							self.visible = Mpris.players.length != 0; // only visible if there is a player
						},
						'changed'
					);
					// self.on('button-press-event', (self, event) => {
					// 	if (event.get_button()[1] === 8)
					// 		// Side button
					// 		execAsync('playerctl previous').catch(print);
					// });
				},
			}),
		],
	});
};

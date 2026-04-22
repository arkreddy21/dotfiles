import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

const Hyprland = await Service.import('hyprland');

const clientTitle = Widget.Label({
	xalign: 0,
	truncate: 'end',
	maxWidthChars: 1, // Doesn't matter, just needs to be non negative
	className: 'txt-smallie bar-wintitle-txt',
	setup: (self) =>
		self.hook(Hyprland.active.client, (label) => {
			// Hyprland.active.client
			label.label = Hyprland.active.client.title
				// Hyprland.active.client.title.length === 0
				// 	? `Workspace ${Hyprland.active.workspace.id}`
				// 	: Hyprland.active.client.title;
		}),
});

const clientClass = Widget.Label({
	xalign: 0,
	truncate: 'end',
	maxWidthChars: 1, // Doesn't matter, just needs to be non negative
	className: 'txt-small bar-wintitle-custom', //"txt-smaller bar-wintitle-topdesc txt",
	setup: (self) =>
		self.hook(Hyprland.active.client, (label) => {
			// Hyprland.active.client
			// label.label = Hyprland.active.client.class.length === 0 ? 'Desktop' : Hyprland.active.client.class;
			label.label = Hyprland.active.client.class;
		}),
});

const WindowTitle = async () => {
	try {
		return Widget.Box({
			vertical: true,
			hexpand: true,
			vexpand: true,
			children: [clientClass],  //optional [, clientTitle]
		});
	} catch {
		return null;
	}
};

const WindowIcon = Widget.Icon({
  icon: Hyprland.active.client.bind('class'),
  size: 18,
});

export default async (monitor = 0) => {
	const WindowTitleInstance = await WindowTitle();
	return Widget.EventBox({
		onPrimaryClick: () => {
			App.toggleWindow('sideleft');
		},
		child: Widget.Box({
			homogeneous: false,
			children: [
				Widget.Box({ className: 'bar-corner-spacing' }),
				Widget.Overlay({
					overlays: [
						Widget.Box({ hexpand: true }),
						Widget.Box({
							className: 'bar-sidemodule',
							hexpand: true,
							children: [
								Widget.Box({
								// 	vertical: true,
								// 	className: 'bar-space-button',
                					vpack: 'center',
									children: [WindowIcon,WindowTitleInstance],
									// children: [WindowTitleInstance],
								}),
							],
						}),
					],
				}),
			],
		}),
	});
};

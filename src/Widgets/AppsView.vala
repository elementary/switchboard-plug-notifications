/***
	BEGIN LICENSE

	Copyright (C) 2014 elementary Developers
	This program is free software: you can redistribute it and/or modify it
	under the terms of the GNU Lesser General Public License version 3, as published
	by the Free Software Foundation.

	This program is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranties of
	MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
	PURPOSE.  See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with this program.  If not, see <http://www.gnu.org/licenses/>

	END LICENSE
	Written By: Marcus Wichelmann <admin@marcusw.de>

***/

public class Widgets.AppsView : Granite.Widgets.ThinPaned {
	private Gtk.Box sidebar;

	public AppList applist;
	private Footer footer;

	private Gtk.Stack content;

	private AppSettings appsettings;
	private InfoScreen do_not_disturb_info;

	public AppsView () {
		sidebar = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

		applist = new AppList ();
		footer = new Footer ();

		content = new Gtk.Stack ();

		appsettings = new AppSettings ();
		do_not_disturb_info = new InfoScreen (_("elementary OS is in Do Not Disturb mode"),
				_("While in Do Not Disturb mode, notifications and alerts will be hidden and notification sounds will be silenced.") + "\n\n" +
				_("System notifications, such as volume and display brightness, will be unaffected."),
				"notification-disabled");

		content.add_named (appsettings, "app-settings");
		content.add_named (do_not_disturb_info, "do-not-disturb");

		sidebar.pack_start (applist, true, true);
		sidebar.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, true);
		sidebar.pack_start (footer, false, true);

		this.pack1 (sidebar, true, false);
		this.pack2 (content, true, false);
		this.set_position (240);

		select_app (applist.selected_row);

		applist.item_changed.connect (select_app);

		appsettings.bubbles_changed.connect ((bubbles) => {
			(applist.selected_row as AppItem).set_bubbles (bubbles);
		});

		appsettings.sounds_changed.connect ((sounds) => {
			(applist.selected_row as AppItem).set_sounds (sounds);
		});

		set_do_not_disturb_mode (NotifySettings.get_default ().do_not_disturb);

		NotifySettings.get_default ().do_not_disturb_changed.connect ((do_not_disturb) => {
			set_do_not_disturb_mode (do_not_disturb);
		});
	}

	private void set_do_not_disturb_mode (bool do_not_disturb) {
		if (do_not_disturb) {
			applist.set_sensitive (false);
			applist.select_none ();
			do_not_disturb_info.show ();
			content.set_visible_child (do_not_disturb_info);
		} else {
			applist.set_sensitive (true);
			applist.select_first ();
			content.set_visible_child (appsettings);
		}
	}

	private void select_app (AppItem item) {
		appsettings.set_appicon (item.get_icon ());
		appsettings.set_apptitle (item.get_title ());
		appsettings.set_bubbles (item.get_bubbles ());
		appsettings.set_sounds (item.get_sounds ());
		appsettings.set_sensitive (true);
	}
}

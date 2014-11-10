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

public class Widgets.AppItem : Gtk.ListBoxRow {
	private AppInfo appinfo;
	private string appname;
	private string apppriority;
	private string appallowsounds;

	private Gtk.Grid row_grid;
	private Gtk.Image row_image;
	private Gtk.Label row_title;
	private Gtk.Label row_description;

	private string[] priorities = ({"0", "1", "2", "3"});

	// Please add more exceptions! TODO: app-name, title and icon all in one array.
	private string[] exceptions = ({"indicator-sound", "notify-send", "NetworkManager", "gnome-settings-daemon"});

	public AppItem (string app_name, string[] properties) {
		appinfo = search_appinfo_for_name (app_name);
		appname = app_name;
		apppriority = properties [0];
		appallowsounds = properties[1];

		create_ui ();
	}

	private AppInfo search_appinfo_for_name (string app_name) {
		var found_info = AppInfo.create_from_commandline ("", app_name, AppInfoCreateFlags.NONE);

		if ((app_name in exceptions) == false) {
			var found = false;

			AppInfo.get_all ().foreach ((info) => {
				if (app_name.down ().contains (info.get_name ().down ()) || app_name.down ().contains (info.get_executable ().down ())) {
					found_info = info;
					found = true;
				}
			});

			if (!found) {
				AppInfo.get_all ().foreach ((info) => {
					if (info.get_display_name ().down ().contains (app_name.down ())) {
						found_info = info;
						found = true;
					}
				});
			}
		}

		return found_info;
	}

	private void create_ui () {
		row_grid = new Gtk.Grid ();
		row_grid.margin = 6;
		row_grid.column_spacing = 6;
		this.add (row_grid);

		row_image = new Gtk.Image.from_gicon (get_icon (), Gtk.IconSize.DIALOG);
		row_grid.attach (row_image, 0, 0, 1, 2);

		row_title = new Gtk.Label (@"<span font_weight=\"bold\">" + this.get_title () + "</span>");
		row_title.use_markup = true;
		row_title.ellipsize = Pango.EllipsizeMode.END;
		row_title.halign = Gtk.Align.START;
		row_title.valign = Gtk.Align.END;
		row_grid.attach (row_title, 1, 0, 1, 1);

		row_description = new Gtk.Label (null);
		row_description.use_markup = true;
		row_description.ellipsize = Pango.EllipsizeMode.END;
		row_description.halign = Gtk.Align.START;
		row_description.valign = Gtk.Align.START;
		create_description ();
		row_grid.attach (row_description, 1, 1, 1, 1);
	}

	private void create_description () {
		var desc = "";

		if (apppriority != "0") {
			desc += _("Bubbles");

			if (appallowsounds == "1") {
				desc += ", " + _("Sounds");
			}
		} else {
			desc += _("Disabled");
		}

		row_description.set_label (@"<span font_style=\"italic\" font_size=\"small\">$desc</span>");
	}

	public string get_title () {
		// Please add more exceptions! (See also string[] exceptions!)
		switch (appinfo.get_display_name ()) {
				case "indicator-sound":
					return _("Sound Menu");
				case "NetworkManager":
					return _("Network");
				case "gnome-settings-daemon":
					return _("System Configuration");
				default:
					return appinfo.get_display_name ();
			}
	}

	public Icon get_icon () {
		try {
			if (appinfo.get_icon () == null) {
				// Please add more exceptions! (See also string[] exceptions!)
				switch (appinfo.get_display_name ()) {
					case "indicator-sound":
						return Icon.new_for_string ("preferences-desktop-sound");
					case "notify-send":
						return Icon.new_for_string ("applications-chat");
					case "NetworkManager":
						return Icon.new_for_string ("preferences-system-network");
					case "gnome-settings-daemon":
						return Icon.new_for_string ("applications-electronics");
					default:
						return Icon.new_for_string ("application-default-icon");
				}
			} else {
				return appinfo.get_icon ();
			}
		} catch {
			return null;
		}
	}

	public string get_priority () {
		if (apppriority in priorities) {
			return apppriority;
		} else {
			// Fallback to default
			return NotifySettings.get_default ().default_priority.to_string ();
		}
	}

	public void set_priority (string priority) {
		if (priority in priorities) {
			apppriority = priority;
			rewrite_settings ();
			create_description ();
		}
	}

	public string get_allow_sounds () {
		if (appallowsounds == "0" || appallowsounds == "1") {
			return appallowsounds;
		} else {
			// Fallback to default
			return NotifySettings.get_default ().default_sounds_enabled.to_string ();
		}
	}

	public void set_allow_sounds (string allow_sounds) {
		if (allow_sounds == "0" || allow_sounds == "1") {
			appallowsounds = allow_sounds;
			rewrite_settings ();
			create_description ();
		}
	}

	private void rewrite_settings () {
		var apps_new = new string[NotifySettings.get_default ().apps.length];

		for (int i = 0; i < NotifySettings.get_default ().apps.length; i++) {
			try {
				if (NotifySettings.get_default ().apps[i].split (":")[0] == appname) {
					// Rewrite
					apps_new[i] = appname + ":" + apppriority + "," + appallowsounds;
				} else {
					// Keep
					apps_new[i] = NotifySettings.get_default ().apps[i];
				}
			} catch {}
		}

		NotifySettings.get_default ().apps = apps_new;
	}
}

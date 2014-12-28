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
	private string appbubbles;
	private string appsounds;
	private Icon appicon;

	private Gtk.Grid row_grid;
	private Gtk.Image row_image;
	private Gtk.Label row_title;
	private Gtk.Label row_description;

	private string[] cond_bubbles = ({"show", "hide"});
	private string[] cond_sounds = ({"on", "off"});

	// Please add more exceptions! TODO: app-name, title and icon all in one array.
	private string[] exceptions = ({"indicator-sound", "notify-send", "NetworkManager", "gnome-settings-daemon"});

	public AppItem (string app_name, string[] properties) {
		if (search_appinfo_for_name (app_name) && load_icon ()) {
			appname = app_name;
			appbubbles = properties [0];
			appsounds = properties[1];

			create_ui ();
		}
	}

	private bool search_appinfo_for_name (string app_name) {
		try {
			AppInfo found_info = AppInfo.create_from_commandline ("", app_name, AppInfoCreateFlags.NONE);

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

			appinfo = found_info;
			return true;
		} catch {
			return false;
		}
	}

	private bool load_icon () {
		try {
			if (appinfo.get_icon () == null) {
				// Please add more exceptions! (See also string[] exceptions!)
				switch (appinfo.get_display_name ()) {
					case "indicator-sound":
						appicon = Icon.new_for_string ("preferences-desktop-sound");
						break;
					case "notify-send":
						appicon = Icon.new_for_string ("dialog-information");
						break;
					case "NetworkManager":
						appicon = Icon.new_for_string ("preferences-system-network");
						break;
					case "gnome-settings-daemon":
						appicon = Icon.new_for_string ("applications-electronics");
						break;
					default:
						appicon = Icon.new_for_string ("application-default-icon");
						break;
				}
			} else {
				appicon = appinfo.get_icon ();
			}

			return true;
		} catch {
			return false;
		}
	}

	private void create_ui () {
		row_grid = new Gtk.Grid ();
		row_grid.margin = 6;
		row_grid.column_spacing = 6;
		this.add (row_grid);

		row_image = new Gtk.Image.from_gicon (appicon, Gtk.IconSize.DND);
		row_grid.attach (row_image, 0, 0, 1, 2);

		row_title = new Gtk.Label (this.get_title ());
		row_title.get_style_context ().add_class ("h3");
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

		if (appbubbles != "hide") {
			desc += _("Bubbles");

			if (appsounds == "on") {
				desc += ", " + _("Sounds");
			}
		} else {
			desc += _("Disabled");
		}

		row_description.set_label (@"<span font_size=\"small\">$desc</span>");
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
					switch (appinfo.get_executable ()) {
						case "midori":
							return "Midori";
						default:
							return appinfo.get_display_name ();
					}
			}
	}

	public Icon get_icon () {
		return appicon;
	}

	public string get_bubbles () {
		if (appbubbles in cond_bubbles) {
			return appbubbles;
		} else {
			// Fallback to default
			if (NotifySettings.get_default ().default_bubbles) {
				return "show";
			} else {
				return "hide";
			}
		}
	}

	public void set_bubbles (string bubbles) {
		if (bubbles in cond_bubbles) {
			appbubbles = bubbles;
			rewrite_settings ();
			create_description ();
		}
	}

	public string get_sounds () {
		if (appsounds in cond_sounds) {
			return appsounds;
		} else {
			// Fallback to default
			if (NotifySettings.get_default ().default_sounds) {
				return "on";
			} else {
				return "off";
			}
		}
	}

	public void set_sounds (string sounds) {
		if (sounds in cond_sounds) {
			appsounds = sounds;
			rewrite_settings ();
			create_description ();
		}
	}

	private void rewrite_settings () {
		var apps_new = new string[NotifySettings.get_default ().apps.length];

		for (int i = 0; i < NotifySettings.get_default ().apps.length; i++) {
			var parameters = NotifySettings.get_default ().apps[i].split (":");

			if (parameters.length == 2) {
				if (parameters[0] == appname) {
					// Rewrite
					apps_new[i] = appname + ":" + appbubbles + "," + appsounds;
				} else {
					// Keep
					apps_new[i] = NotifySettings.get_default ().apps[i];
				}
			}
		}

		NotifySettings.get_default ().apps = apps_new;
	}
}

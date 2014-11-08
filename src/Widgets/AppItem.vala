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

public class Widgets.AppItem : Granite.Widgets.SourceList.Item {
	private AppInfo appinfo;
	private string appname;
	private string apppriority;
	private string appallowsounds;

	private string[] priorities = ({"0", "1", "2", "3"});

	public AppItem (string app_name, string[] properties) {
		appinfo = search_appinfo_for_name (app_name);
		appname = app_name;
		apppriority = properties [0];
		appallowsounds = properties[1];

		this.name = get_title ();
		this.icon = get_icon ();
	}

	private AppInfo search_appinfo_for_name (string app_name) {
		var found_info = AppInfo.create_from_commandline ("", app_name, AppInfoCreateFlags.NONE);

		AppInfo.get_all ().foreach ((info) => {
			if (app_name.down ().contains (info.get_name ().down ()) || app_name.down ().contains (info.get_executable ().down ())) {
				found_info = info;
			}
		});

		return found_info;
	}

	public string get_title () {
		// Please add more exceptions!
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

	public string get_description () {
		return appinfo.get_description ();
	}

	public Icon get_icon () {
		try {
			if (appinfo.get_icon () == null) {
				// Please add more exceptions!
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
		}
	}

	private void rewrite_settings () {
		
	}
}
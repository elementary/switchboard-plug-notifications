/***
	BEGIN LICENSE

	Copyright (C) 2014-2015 elementary Developers
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

public class Backend.NotifyCenterBlacklist : Object {
	public string[] blacklist { get; set; }

	public bool is_installed { default = false; get; private set; }

	private Settings notify_center_settings;

	public NotifyCenterBlacklist () {
		if (!load_settings_schema ())
			return;

		create_bindings ();

		is_installed = true;
	}

	public void enable_app (string app_id) {
		if (!is_installed || blacklist.length == 0 || !(app_id in blacklist))
			return;

		string[] new_list = new string[blacklist.length -1];
		int new_index = 0;

		for (int i = 0; i < blacklist.length; i++) {
			string item = blacklist[i];

			if (item != app_id)
				new_list[new_index++] = item;
		}

		blacklist = new_list;
	}

	public void disable_app (string app_id) {
		if (!is_installed || app_id in blacklist)
			return;

		string[] list = blacklist;

		list += app_id;

		blacklist = list;
	}

	private bool load_settings_schema () {
		SettingsSchema? schema = SettingsSchemaSource.get_default ().lookup ("org.pantheon.desktop.wingpanel.indicators.notifications", true);

		if (schema == null) {
			debug ("Notification indicator not installed. Disabling Blacklist feature.");

			return false;
		}

		notify_center_settings = new Settings.full (schema, null, null);

		return true;
	}

	private void create_bindings () {
		notify_center_settings.bind ("blacklist", this, "blacklist", GLib.SettingsBindFlags.DEFAULT);
	}
}

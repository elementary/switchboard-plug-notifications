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

public class NotifySettings : Object {
	public Settings settings;

	static const string APPS_KEY = "apps";
	static const string DEFAULT_PRIORITY_KEY = "default-priority";
	static const string DEFAULT_SOUNDS_ENABLED_KEY = "default-sounds-enabled";

	public string[] apps { get; set; }
	public int default_priority { get; set; }
	public int default_sounds_enabled { get; set; }

	public signal void apps_changed (string[] new_value);

	static NotifySettings? instance = null;

	private NotifySettings () {
		settings = new Settings ("org.pantheon.desktop.gala.notifications");

		settings.bind (APPS_KEY, this, "apps", SettingsBindFlags.DEFAULT);
		settings.bind (DEFAULT_PRIORITY_KEY, this, "default-priority", SettingsBindFlags.DEFAULT);
		settings.bind (DEFAULT_SOUNDS_ENABLED_KEY, this, "default-sounds-enabled", SettingsBindFlags.DEFAULT);

		settings.changed[APPS_KEY].connect (() => {
				apps_changed (apps);
			});
	}

	public static NotifySettings get_default () {
		if (instance == null) {
			instance = new NotifySettings ();
		}

		return instance;
	}
}
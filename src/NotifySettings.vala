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
	static const string DEFAULT_BUBBLES_KEY = "default-bubbles";
	static const string DEFAULT_SOUNDS_KEY = "default-sounds";
	static const string DO_NOT_DISTURB_KEY = "do-not-disturb";

	public string[] apps { get; set; }
	public bool default_bubbles { get; set; }
	public bool default_sounds { get; set; }
	public bool do_not_disturb { get; set; }

	public signal void apps_changed (string[] new_value);
	public signal void do_not_disturb_changed (bool new_value);

	static NotifySettings? instance = null;

	private NotifySettings () {
		settings = new Settings ("org.pantheon.desktop.gala.notifications");

		settings.bind (APPS_KEY, this, "apps", SettingsBindFlags.DEFAULT);
		settings.bind (DEFAULT_BUBBLES_KEY, this, "default-bubbles", SettingsBindFlags.DEFAULT);
		settings.bind (DEFAULT_SOUNDS_KEY, this, "default-sounds", SettingsBindFlags.DEFAULT);
		settings.bind (DO_NOT_DISTURB_KEY, this, "do-not-disturb", SettingsBindFlags.DEFAULT);

		settings.changed[APPS_KEY].connect (() => {
			apps_changed (apps);
		});

		settings.changed[DO_NOT_DISTURB_KEY].connect (() => {
			do_not_disturb_changed (do_not_disturb);
		});
	}

	public static NotifySettings get_default () {
		if (instance == null) {
			instance = new NotifySettings ();
		}

		return instance;
	}
}

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

	static const string BUBBLES_KEY = "bubbles";
	static const string SOUNDS_KEY = "sounds";

	public string[] bubbles { get; set; }
	public string[] sounds { get; set; }

	static NotifySettings? instance = null;

	private NotifySettings () {
		settings = new Settings ("org.pantheon.desktop.gala.notifications");

		this.settings.bind (BUBBLES_KEY, this, "bubbles", SettingsBindFlags.DEFAULT);
		this.settings.bind (SOUNDS_KEY, this, "sounds", SettingsBindFlags.DEFAULT);
	}

	public static NotifySettings get_default () {
		if (instance == null) {
			instance = new NotifySettings ();
		}

		return instance;
	}
}
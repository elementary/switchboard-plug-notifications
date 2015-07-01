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

public class Backend.NotifyManager : Object {
	public static NotifyManager? instance = null;

	public bool do_not_disturb { get; set; }

	private Gee.HashMap<string, App> apps; // string: app-id

	private NotifyManager () {
		apps = new Gee.HashMap<string, App> ();

		create_bindings ();
	}

	private void create_bindings () {
		NotifySettings.get_default ().schema.bind ("do-not-disturb", this, "do_not_disturb", SettingsBindFlags.DEFAULT);
	}

	public static NotifyManager get_default () {
		if (instance == null) {
			instance = new NotifyManager ();
		}

		return instance;
	}
}

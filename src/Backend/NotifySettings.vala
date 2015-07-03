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

public class Backend.NotifySettings : Granite.Services.Settings {
	public static NotifySettings? instance = null;

	// FIXME: Granite.Services.Settings seems to not support Variants in the moment.
	//public Variant apps { get; set; }
	public int default_permissions { get; set; }
	public bool do_not_disturb { get; set; }

	private NotifySettings () {
		base ("org.pantheon.desktop.gala.notifications");

	}

	public static NotifySettings get_default () {
		if (instance == null) {
			instance = new NotifySettings ();
		}

		return instance;
	}
}

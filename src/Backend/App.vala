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

public class Backend.App : Object {
	public struct Permissions {
		public bool enable_bubbles;
		public bool enable_sounds;
	}

	public string app_id { get; private set; }
	public DesktopAppInfo app_info { get; private set; }
	public Permissions permissions { get; set; }

	public App (string app_id, DesktopAppInfo app_info, Permissions permissions) {
		this.app_id = app_id;
		this.app_info = app_info;
		this.permissions = permissions;
	}
}

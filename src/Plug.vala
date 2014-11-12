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

public class NotificationsPlug : Switchboard.Plug {
	private Gtk.Box box;
	private Widgets.AppsView appsview;

	public NotificationsPlug () {
		Object (category: Category.PERSONAL,
			code_name: "personal-pantheon-notifications",
			display_name: _("Notifications"),
			description: _("Enable or disable notifications."),
			icon: "preferences-desktop-notifications");
	}

	public override Gtk.Widget get_widget () {
		if (box != null) {
			return box;
		}

		box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

		appsview = new Widgets.AppsView ();

		box.pack_start (appsview, true, true);
		box.show_all ();

		return box;
	}

	public override void shown () {
		
	}

	public override void hidden () {
		
	}

	public override void search_callback (string location) {
		
	}

	public override async Gee.TreeMap<string, string> search (string search) {
		return new Gee.TreeMap<string, string> (null, null);
	}

}

public Switchboard.Plug get_plug (Module module) {
	debug ("Activating Notifications plug");
	var plug = new NotificationsPlug ();
	return plug;
}

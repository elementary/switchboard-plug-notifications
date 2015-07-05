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

public class Widgets.AppSettingsView : Gtk.Grid {
	private enum PermissionType {
		BUBBLES,
		SOUNDS
	}

	private Backend.App? selected_app = null;

	private bool notify_center_installed = false;

	private SettingsHeader header;

	private Gtk.Switch bubbles_switch;
	private SettingsOption bubbles_option;

	private Gtk.Switch sound_switch;
	private SettingsOption sound_option;

	private Gtk.Switch sinc_switch; // sinc = show in notifications center
	private SettingsOption sinc_option;

	public AppSettingsView () {
		notify_center_installed = Backend.NotifyManager.get_default ().notify_center_blacklist.is_installed;

		build_ui ();
		connect_signals ();
		show_selected_app ();
	}

	private void build_ui () {
		this.margin = 12;
		this.row_spacing = 60;

		header = new SettingsHeader ();

		bubbles_option = new SettingsOption (
				Constants.PKGDATADIR + "/bubbles.svg",
				_("Bubbles"),
				_("Bubbles appear in the top right corner of the display and disappear automatically."),
				bubbles_switch = new Gtk.Switch ());

		sound_option = new SettingsOption (
				Constants.PKGDATADIR + "/sounds.svg",
				_("Sounds"),
				_("Sounds play once when a new notification arrives."),
				sound_switch = new Gtk.Switch ());

		this.attach (header, 0, 0, 1, 1);
		this.attach (bubbles_option, 0, 1, 1, 1);
		this.attach (sound_option, 0, 2, 1, 1);

		if (notify_center_installed) {
			sinc_option = new SettingsOption (
					Constants.PKGDATADIR + "/notify-center.svg",
					_("Notification Center"),
					_("Show missed notifications in Notification Center."),
					sinc_switch = new Gtk.Switch ());

			this.attach (sinc_option, 0, 3, 1, 1);
		}
	}

	private void connect_signals () {
		Backend.NotifyManager.get_default ().notify["selected-app-id"].connect (show_selected_app);

		bubbles_switch.state_set.connect (() => { update_permissions (PermissionType.BUBBLES); return false; });
		sound_switch.state_set.connect (() => { update_permissions (PermissionType.SOUNDS); return false; });

		if (notify_center_installed)
			sinc_switch.state_set.connect (() => { update_sinc_state (); return false; });
	}

	private void show_selected_app () {
		string app_id = Backend.NotifyManager.get_default ().selected_app_id;
		selected_app = Backend.NotifyManager.get_default ().apps.get (app_id);

		if (selected_app != null)
			show_app (selected_app);
	}

	private void show_app (Backend.App app) {
		header.set_title (app.app_info.get_display_name ());
		header.set_icon (app.app_info.get_icon ());

		bubbles_switch.set_state (app.permissions.enable_bubbles);
		sound_switch.set_state (app.permissions.enable_sounds);

		if (notify_center_installed)
			sinc_switch.set_state (!(app.app_id in Backend.NotifyManager.get_default ().notify_center_blacklist.blacklist));
	}

	private void update_permissions (PermissionType permission_type) {
		if (selected_app != null)
			selected_app.permissions = {
				permission_type == PermissionType.BUBBLES ? bubbles_switch.active : selected_app.permissions.enable_bubbles,
				permission_type == PermissionType.SOUNDS ? sound_switch.active : selected_app.permissions.enable_sounds
			};
	}

	private void update_sinc_state () {
		if (!notify_center_installed || selected_app == null)
			return;

		if (sinc_switch.active)
			Backend.NotifyManager.get_default ().notify_center_blacklist.enable_app (selected_app.app_id);
		else
			Backend.NotifyManager.get_default ().notify_center_blacklist.disable_app (selected_app.app_id);
	}
}

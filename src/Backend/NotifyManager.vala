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

	public NotifyCenterBlacklist notify_center_blacklist;

	public bool do_not_disturb { get; set; }

	public Gee.HashMap<string, App> apps { get; set; } // string: app-id

	public string selected_app_id { get; set; }

	private VariantDict app_settings;

	private NotifyManager () {
		apps = new Gee.HashMap<string, App> ();
		notify_center_blacklist = new NotifyCenterBlacklist ();

		load_dictionary ();
		create_bindings ();
		read_app_list ();
	}

	private void load_dictionary () {
		app_settings = new VariantDict (NotifySettings.get_default ().schema.get_value ("apps"));

		debug ("App settings loaded.");
	}

	private void save_dictionary () {
		Variant new_variant = app_settings.end ();

		if (!new_variant.equal (NotifySettings.get_default ().schema.get_value ("apps"))) {
			NotifySettings.get_default ().schema.set_value ("apps", new_variant);

			debug ("App settings updated.");
		}

		// FIXME: After calling VariantDict.end () the dictionary is freeed, so we need to reload it
		load_dictionary ();
	}

	private void create_bindings () {
		NotifySettings.get_default ().schema.bind ("do-not-disturb", this, "do-not-disturb", SettingsBindFlags.DEFAULT);
	}

	private void read_app_list () {
		var installed_apps = AppInfo.get_all ();

		foreach (AppInfo app_info in installed_apps) {
			DesktopAppInfo? desktop_app_info = app_info as DesktopAppInfo;

			if (desktop_app_info != null)
				register_app (desktop_app_info);
		}

		save_dictionary ();
	}

	private void register_app (DesktopAppInfo app_info) {
		if (!app_info.get_boolean ("X-GNOME-UsesNotifications"))
			return;

		string app_id = app_info.get_id ().replace (".desktop", "");

		debug ("Application \"%s\" detected.", app_id);

		App.Permissions permissions = lookup_app_permissions (app_id);

		App app = new App (app_id, app_info, permissions);
		app.notify["permissions"].connect (() => {
			Variant new_value = new Variant.int32 (encode_app_permissions (app.permissions));

			app_settings.insert_value (app_id, new_value);

			save_dictionary ();
		});

		apps.@set (app_id, app);
	}

	private App.Permissions lookup_app_permissions (string app_id) {
		int permission_code = NotifySettings.get_default ().default_permissions;

		if (!app_settings.lookup (app_id, "i", out permission_code)) {
			debug ("No settings for \"%s\" found. Adding default permissions to list.", app_id);

			app_settings.insert (app_id, "i", permission_code);
		}

		return decode_app_permissions (permission_code);
	}

	private int encode_app_permissions (App.Permissions permissions) {
		int s = (int)permissions.enable_sounds * 2;
		int b = (int)permissions.enable_bubbles;

		return s + b;
	}

	private App.Permissions decode_app_permissions (int code) requires (code <= 3) {
		int s = code >> 1;
		int b = code - s * 2;

		return {b == 1, s == 1};
	}

	public static NotifyManager get_default () {
		if (instance == null) {
			instance = new NotifyManager ();
		}

		return instance;
	}
}

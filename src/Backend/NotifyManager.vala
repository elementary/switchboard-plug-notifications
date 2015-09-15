/*
 * Copyright (c) 2011-2015 elementary Developers
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

public class Backend.NotifyManager : Object {
    private static const string CHILD_SCHEMA_ID = "org.pantheon.desktop.gala.notifications.application";
    private static const string CHILD_PATH = "/org/pantheon/desktop/gala/notifications/applications/%s/";

    public static NotifyManager? instance = null;

    public SettingsSchemaSource schema_source;

    public bool do_not_disturb { get; set; }
    public Gee.HashMap<string, App> apps { get; set; } /* string: app-id */

    public string selected_app_id { get; set; }

    private NotifyManager () {
        schema_source = SettingsSchemaSource.get_default ();
        apps = new Gee.HashMap<string, App> ();

        create_bindings ();
        read_app_list ();
    }

    private void create_bindings () {
        NotifySettings.get_default ().schema.bind ("do-not-disturb", this, "do-not-disturb", SettingsBindFlags.DEFAULT);
    }

    private void read_app_list () {
        var installed_apps = AppInfo.get_all ();

        foreach (AppInfo app_info in installed_apps) {
            DesktopAppInfo? desktop_app_info = app_info as DesktopAppInfo;

            if (desktop_app_info != null && desktop_app_info.get_boolean ("X-GNOME-UsesNotifications")) {
                register_app (desktop_app_info);
            }
        }
    }

    private void register_app (DesktopAppInfo app_info) {
        string app_id = app_info.get_id ().replace (".desktop", "");

        debug ("Application \"%s\" detected.", app_id);

        Settings app_settings = new Settings.full (schema_source.lookup (CHILD_SCHEMA_ID, false), null, CHILD_PATH.printf (app_id));
        App app = new App (app_id, app_info, app_settings);

        apps.@set (app_id, app);
    }

    public static NotifyManager get_default () {
        if (instance == null) {
            instance = new NotifyManager ();
        }

        return instance;
    }
}
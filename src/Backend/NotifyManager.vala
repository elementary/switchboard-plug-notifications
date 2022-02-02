/*
 * Copyright 2011-2020 elementary, Inc. (https://elementary.io)
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
 * Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

public class Backend.NotifyManager : Object {
    public static NotifyManager? instance = null;

    public static unowned NotifyManager get_default () {
        if (instance == null) {
            instance = new NotifyManager ();
        }

        return instance;
    }

    public Gee.HashMap<string, App> apps { get; construct; } /* string: app-id */
    public Gee.HashSet<string> apps_that_have_notified { get; construct; }

    public string selected_app_id { get; set; }

    construct {
        apps = new Gee.HashMap<string, App> ();
        var apps_that_have_notified = new Gee.HashMap<string, string> ();

        var settings = new Settings.full (
            GLib.SettingsSchemaSource.get_default ().lookup ("io.elementary.notifications", false),
            null,
            null
        );
        foreach (var app_id in settings.get_strv("applications")) {
            apps_that_have_notified.set(App.normalize_app_id(app_id), app_id);
        }

        foreach (AppInfo app_info in AppInfo.get_all ()) {
            var desktop_app_info = app_info as DesktopAppInfo;
            if (desktop_app_info == null) { continue; }

            var app = new App(desktop_app_info);

            var alternate_names = new Gee.HashMap<string, string> ();
            // Even though it is called `alternate_names`, it includes the
            // app's formal name as well.
            foreach (var alt_name in desktop_app_info.get_string_list("X-Flatpak-RenamedFrom")) {
                alternate_names.set(App.normalize_app_id(alt_name), alt_name);
            }

            if (desktop_app_info.get_boolean ("X-GNOME-UsesNotifications")) {
                apps_that_have_notified.unset(app.normalized_app_id);
                apps.@set (app.app_id, app);
            } else if (apps_that_have_notified.has_key(app.normalized_app_id)) {
                // Notifications in this category don't necessarily declare
                // that they send notifications in their desktop file, but
                // we've recorded them sending at least one notification.

                // We use the desktop entry given in the application's
                // notification hint (instead of the desktop file's id) because
                // some apps use a different formal name than the name that
                // they send notifications as. For example, 'firefox' sends
                // notifications belonging to 'Firefox' (note the case
                // difference).
                var desktop_entry = apps_that_have_notified.get(app.normalized_app_id);
                apps_that_have_notified.unset(app.normalized_app_id);
                apps.@set (desktop_entry, app);
            } else {
                foreach (var entry in alternate_names.entries) {
                    var normalized_alt_name = entry.key;
                    var alt_name = entry.value;

                    // e.g.: Installing 'Ungoogled Chromium' from Flatpak gives
                    // you a formal name of
                    // 'com.github.Eloston.UngoogledChromium', but
                    // notifications send as 'chromium-browser'. Similar to the
                    // non-notification-declaring applications above, we want
                    // to use the application's notification hint's desktop
                    // entry.
                    if (apps_that_have_notified.has_key(normalized_alt_name)) {
                        var desktop_entry = apps_that_have_notified.get(normalized_alt_name);
                        apps_that_have_notified.unset(normalized_alt_name);
                        apps.@set(desktop_entry, app);
                    }
                }
            }
        }

        // At this point, all that's left are applications that have sent
        // notifications that either have no formal application (e.g.:
        // `gnome-power-panel`), or send a different notification desktop entry
        // hint that cannot be matched with their formal name (through
        // normalization).
        //
        // Some apps that appear in this collection still might not send
        // notifications if enabled from the panel: if the application disables
        // notifications internally (e.g.: `nm-applet` can disable
        // notifications *before* they're even handed off to elementary).
        foreach (var name in apps_that_have_notified.values) {
            // XXX Here is where I want to create a new `App` for this unknown
            // application, but I don't know where how to start refactoring it,
            // as they rely on Desktop entries, which every app in this
            // category does *not* have.
            // var app = new App.with_desktop_entry(name);
        }
        // XXX At this point, we're going to overwrite
        // `io.elementary.notifications.applications` with whatever's left in
        // `apps_that_have_notified`, which will just be a list of the above collection.
        //
        // Also, as new notifications are added to
        // `io.elementary.notifications.applications`, we need to use a signal
        // to update the app list in real-time.
    }
}

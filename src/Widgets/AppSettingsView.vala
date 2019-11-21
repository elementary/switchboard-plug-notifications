/*
 * Copyright 2011-2019 elementary, Inc. (https://elementary.io)
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

public class Widgets.AppSettingsView : Granite.SimpleSettingsPage {
    private const string BUBBLES_KEY = "bubbles";
    private const string SOUNDS_KEY = "sounds";
    private const string REMEMBER_KEY = "remember";

    private Backend.App? selected_app = null;

    private Gtk.Switch bubbles_switch;
    private SettingsOption bubbles_option;

    private Gtk.Switch sound_switch;
    private SettingsOption sound_option;

    private Gtk.Switch remember_switch;
    private SettingsOption remember_option;

    construct {
        bubbles_option = new SettingsOption (
            "/io/elementary/switchboard/bubbles.svg",
            _("Bubbles"),
            _("Bubbles appear in the top right corner of the display and disappear automatically."),
            bubbles_switch = new Gtk.Switch ());

        sound_option = new SettingsOption (
            "/io/elementary/switchboard/sounds.svg",
            _("Sounds"),
            _("Sounds play once when a new notification arrives."),
            sound_switch = new Gtk.Switch ());

        remember_option = new SettingsOption (
            "/io/elementary/switchboard/notify-center.svg",
            _("Notification Center"),
            _("Show missed notifications in Notification Center."),
            remember_switch = new Gtk.Switch ());

        content_area.row_spacing = 32;
        content_area.attach (bubbles_option, 0, 1);
        content_area.attach (sound_option, 0, 2);
        content_area.attach (remember_option, 0, 3);

        update_selected_app ();
        create_bindings ();
        update_header ();

        Backend.NotifyManager.get_default ().notify["selected-app-id"].connect (() => {
            remove_bindings ();
            update_selected_app ();
            create_bindings ();
            update_header ();
        });
    }

    private void remove_bindings () {
        Settings.unbind (bubbles_option.widget, "state");
        Settings.unbind (sound_option.widget, "state");
        Settings.unbind (remember_option.widget, "state");
    }

    private void update_selected_app () {
        Backend.NotifyManager notify_manager = Backend.NotifyManager.get_default ();
        string app_id = notify_manager.selected_app_id;
        selected_app = notify_manager.apps.get (app_id);
    }

    private void create_bindings () {
        selected_app.settings.bind (BUBBLES_KEY, bubbles_option.widget, "state", GLib.SettingsBindFlags.DEFAULT);
        selected_app.settings.bind (SOUNDS_KEY, sound_option.widget, "state", GLib.SettingsBindFlags.DEFAULT);
        selected_app.settings.bind (REMEMBER_KEY, remember_option.widget, "state", GLib.SettingsBindFlags.DEFAULT);
    }

    private void update_header () {
        title = selected_app.app_info.get_display_name ();
        icon_name = selected_app.app_info.get_icon ().to_string ();
    }
}

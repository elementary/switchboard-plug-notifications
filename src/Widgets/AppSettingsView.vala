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

public class Widgets.AppSettingsView : Gtk.Grid {
    private Gtk.Image app_image;
    private Gtk.Label app_label;

    private Gtk.Stack stack;
    private Gtk.Revealer bypass_do_not_disturb_revealer;

    private SettingsOption bubbles_option;
    private SettingsOption sound_option;
    private SettingsOption remember_option;
    private Gtk.Switch bypass_do_not_disturb_switch;

    construct {
        app_image = new Gtk.Image () {
            margin = 12,
            pixel_size = 48
        };

        app_label = new Gtk.Label (null) {
            use_markup = true,
            halign = Gtk.Align.START,
            hexpand = true
        };
        app_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

        var header = new Gtk.Grid () {
            column_spacing = 12
        };
        header.attach (app_image, 0, 0);
        header.attach (app_label, 1, 0);

        bubbles_option = new SettingsOption (
            "/io/elementary/switchboard/bubbles.svg",
            _("Bubbles"),
            _("Bubbles appear in the top right corner of the display and disappear automatically."),
            new Gtk.Switch ()
        );

        sound_option = new SettingsOption (
            "/io/elementary/switchboard/sounds.svg",
            _("Sounds"),
            _("Sounds play once when a new notification arrives."),
            new Gtk.Switch ()
        );

        remember_option = new SettingsOption (
            "/io/elementary/switchboard/notify-center.svg",
            _("Notification Center"),
            _("Show missed notifications in Notification Center."),
            new Gtk.Switch ()
        );

        var settings_grid = new Gtk.Grid () {
            expand = true,
            margin = 12,
            row_spacing = 32
        };
        settings_grid.attach (bubbles_option, 0, 1);
        settings_grid.attach (sound_option, 0, 2);
        settings_grid.attach (remember_option, 0, 3);

        var description = _("While in Do Not Disturb mode, notifications and alerts will be hidden and notification sounds will be silenced.");
        description += "\n\n";
        description += _("System notifications, such as volume and display brightness, will be unaffected.");

        var alert_view = new Granite.Widgets.AlertView (
            _("elementary OS is in Do Not Disturb mode"),
            description,
            "notification-disabled"
        );
        alert_view.show_all ();

        stack = new Gtk.Stack ();
        stack.add_named (settings_grid, "settings-grid");
        stack.add_named (alert_view, "alert-view");

        var bypass_do_not_disturb_label = new Granite.HeaderLabel (_("Bypass Do Not Disturb")) {
            margin_start = 3
        };

        bypass_do_not_disturb_switch = new Gtk.Switch () {
            margin = 6,
            margin_end = 3
        };
        bypass_do_not_disturb_switch.notify["state"].connect (update_view);

        var bypass_do_not_disturb_action_bar = new Gtk.ActionBar ();
        bypass_do_not_disturb_action_bar.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
        bypass_do_not_disturb_action_bar.pack_start (bypass_do_not_disturb_label);
        bypass_do_not_disturb_action_bar.pack_end (bypass_do_not_disturb_switch);

        bypass_do_not_disturb_revealer = new Gtk.Revealer () {
            transition_type = Gtk.RevealerTransitionType.SLIDE_UP,
            reveal_child = false
        };
        bypass_do_not_disturb_revealer.add (bypass_do_not_disturb_action_bar);

        attach (header, 0, 1);
        attach (stack, 0, 2);
        attach (bypass_do_not_disturb_revealer, 0, 3);

        update_selected_app ();
        update_view ();

        Backend.NotifyManager.get_default ().notify["selected-app-id"].connect (() => {
            remove_bindings ();
            update_selected_app ();
        });

        NotificationsPlug.notify_settings.changed["do-not-disturb"].connect (update_view);
    }

    private void remove_bindings () {
        Settings.unbind (bubbles_option.widget, "state");
        Settings.unbind (sound_option.widget, "state");
        Settings.unbind (remember_option.widget, "state");
    }

    private void update_selected_app () {
        var notify_manager = Backend.NotifyManager.get_default ();
        var app_id = notify_manager.selected_app_id;
        var selected_app = notify_manager.apps.get (app_id);

        selected_app.settings.bind ("bubbles", bubbles_option.widget, "state", GLib.SettingsBindFlags.DEFAULT);
        selected_app.settings.bind ("sounds", sound_option.widget, "state", GLib.SettingsBindFlags.DEFAULT);
        selected_app.settings.bind ("remember", remember_option.widget, "state", GLib.SettingsBindFlags.DEFAULT);

        app_label.label = selected_app.app_info.get_display_name ();
        app_image.gicon = selected_app.app_info.get_icon ();

        update_view ();
    }

    public void update_view () {
        if (NotificationsPlug.notify_settings.get_boolean ("do-not-disturb") && !bypass_do_not_disturb_switch.state) {
            stack.visible_child_name = "alert-view";
            bypass_do_not_disturb_revealer.reveal_child = true;
        } else {
            stack.visible_child_name = "settings-grid";
            bypass_do_not_disturb_revealer.reveal_child = bypass_do_not_disturb_switch.state;
        }
    }
}

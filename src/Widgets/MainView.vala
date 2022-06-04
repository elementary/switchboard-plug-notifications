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

public class Widgets.MainView : Gtk.Widget {
    private Gtk.Paned main_widget;
    private Gtk.Stack stack;

    static construct {
        set_layout_manager_type (typeof (Gtk.BinLayout));
    }

    construct {
        var sidebar = new Sidebar ();

        var app_settings_view = new AppSettingsView ();
        // app_settings_view.show_all ();

        var description = _("While in Do Not Disturb mode, notifications and alerts will be hidden and notification sounds will be silenced.");
        description += "\n\n";
        description += _("System notifications, such as volume and display brightness, will be unaffected.");

        var alert_view = new Granite.Placeholder (_("elementary OS is in Do Not Disturb mode")) {
            description = description,
            icon = new ThemedIcon ("notification-disabled")
        };
        // alert_view.show_all ();

        stack = new Gtk.Stack ();
        stack.add_named (app_settings_view, "app-settings-view");
        stack.add_named (alert_view, "alert-view");

        main_widget = new Gtk.Paned (Gtk.Orientation.HORIZONTAL) {
            start_child = sidebar,
            end_child = stack,
            resize_start_child = true,
            shrink_start_child = false,
            resize_end_child = true,
            shrink_end_child = false,
            position = 240
        };
        main_widget.set_parent (this);

        update_view ();

        NotificationsPlug.notify_settings.changed["do-not-disturb"].connect (update_view);
    }

    private void update_view () {
        if (NotificationsPlug.notify_settings.get_boolean ("do-not-disturb")) {
            stack.visible_child_name = "alert-view";
        } else {
            stack.visible_child_name = "app-settings-view";
        }
    }

    ~MainView () {
        while (this.get_last_child () != null) {
            this.get_last_child ().unparent ();
        }
    }
}

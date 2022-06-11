/*
 * Copyright 2011-2020 elementary, Inc (https://elementary.io)
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

public class Widgets.Sidebar : Gtk.Grid {
    private const string FALLBACK_APP_ID = "gala-other.desktop";

    construct {
        var app_list = new Gtk.ListBox () {
            hexpand = true,
            vexpand = true,
            selection_mode = Gtk.SelectionMode.SINGLE
        };
        app_list.set_sort_func (sort_func);

        var scrolled_window = new Gtk.ScrolledWindow () {
            child = app_list
        };

        var do_not_disturb_label = new Granite.HeaderLabel (_("Do Not Disturb")) {
            margin_start = 3
        };

        var do_not_disturb_switch = new Gtk.Switch () {
            margin_start = 6,
            margin_top = 6,
            margin_bottom = 6,
            margin_end = 3
        };

        var footer = new Gtk.ActionBar ();
        footer.add_css_class ("inline-footer");
        footer.pack_start (do_not_disturb_label);
        footer.pack_end (do_not_disturb_switch);

        attach (scrolled_window, 0, 0);
        attach (footer, 0, 1);

        app_list.row_selected.connect (show_row);

        NotificationsPlug.notify_settings.bind (
            "do-not-disturb",
            app_list,
            "sensitive",
            SettingsBindFlags.INVERT_BOOLEAN
        );

        NotificationsPlug.notify_settings.bind (
            "do-not-disturb",
            do_not_disturb_switch,
            "state",
            SettingsBindFlags.DEFAULT
        );

        Backend.NotifyManager.get_default ().apps.@foreach ((entry) => {
            AppEntry app_entry = new AppEntry (entry.value);
            app_list.append (app_entry);

            return true;
        });

        var children = app_list.observe_children ();
        if (children.get_n_items () > 0) {
            Gtk.ListBoxRow row = ((Gtk.ListBoxRow) children.get_item (0));

            app_list.select_row (row);
            show_row (row);
        }
    }

    private int sort_func (Gtk.ListBoxRow row1, Gtk.ListBoxRow row2) {
        if (!(row1 is AppEntry && row2 is AppEntry)) {
            return 0;
        }

        if (((AppEntry)row1).app.app_info.get_id () == FALLBACK_APP_ID) {
            return 1;
        } else if (((AppEntry)row2).app.app_info.get_id () == FALLBACK_APP_ID) {
            return -1;
        }

        string row_name1 = ((AppEntry)row1).app.app_info.get_display_name ();
        string row_name2 = ((AppEntry)row2).app.app_info.get_display_name ();

        int order = strcmp (row_name1, row_name2);

        return order.clamp (-1, 1);
    }

    private void show_row (Gtk.ListBoxRow? row) {
        if (row == null || !(row is AppEntry)) {
            return;
        }

        Backend.NotifyManager.get_default ().selected_app_id = ((AppEntry)row).app.app_id;
    }
}

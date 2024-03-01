/*
 * Copyright 2011-2023 elementary, Inc (https://elementary.io)
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

public class Widgets.Sidebar : Gtk.Box {
    private const string FALLBACK_APP_ID = "gala-other.desktop";

    private Gtk.SearchEntry search_entry;

    class construct {
        set_css_name ("settingssidebar");
    }

    construct {
        search_entry = new Gtk.SearchEntry () {
            placeholder_text = _("Search Apps"),
            margin_top = 6,
            margin_bottom = 6,
            margin_start = 6,
            margin_end = 6,
            hexpand = true
        };

        var search_revealer = new Gtk.Revealer () {
            child = search_entry
        };

        var search_toggle = new Gtk.ToggleButton () {
            icon_name = "edit-find-symbolic",
            tooltip_text = _("Search Apps")
        };

        var headerbar = new Adw.HeaderBar () {
            show_end_title_buttons = false,
            show_title = false
        };
        headerbar.pack_end (search_toggle);

        var app_list = new Gtk.ListBox () {
            hexpand = true,
            vexpand = true,
            selection_mode = Gtk.SelectionMode.SINGLE
        };
        app_list.set_filter_func (filter_function);
        app_list.set_sort_func (sort_func);

        var scrolled_window = new Gtk.ScrolledWindow () {
            child = app_list
        };

        var do_not_disturb_label = new Gtk.Label (_("Do Not Disturb")) {
            margin_start = 3
        };
        do_not_disturb_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

        var do_not_disturb_switch = new Gtk.Switch () {
            margin_start = 6,
            margin_top = 6,
            margin_bottom = 6,
            margin_end = 3
        };

        var footer = new Gtk.ActionBar ();
        footer.add_css_class (Granite.STYLE_CLASS_FLAT);
        footer.pack_start (do_not_disturb_label);
        footer.pack_end (do_not_disturb_switch);

        var toolbarview = new Adw.ToolbarView () {
            content = scrolled_window,
            top_bar_style = FLAT
        };
        toolbarview.add_top_bar (headerbar);
        toolbarview.add_top_bar (search_revealer);
        toolbarview.add_bottom_bar (footer);

        append (toolbarview);

        app_list.row_selected.connect (show_row);

        search_entry.search_changed.connect (() => {
            app_list.invalidate_filter ();
        });

        search_toggle.bind_property ("active", search_revealer, "reveal-child");

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

        if (app_list.get_first_child () != null) {
            var row = ((Gtk.ListBoxRow) app_list.get_first_child ());

            app_list.select_row (row);
            show_row (row);
        }
    }

    private bool filter_function (Gtk.ListBoxRow row) {
        if (search_entry.text != "") {
            var search_term = search_entry.text.down ();
            var row_name = ((AppEntry) row).app.app_info.get_display_name ().down ();

            return search_term in row_name;
        }

        return true;
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

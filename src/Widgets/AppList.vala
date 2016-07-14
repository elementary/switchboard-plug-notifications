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

public class Widgets.AppList : Gtk.ListBox {
    private const string FALLBACK_APP_ID = "gala-other.desktop";

    construct {
        this.selection_mode = Gtk.SelectionMode.SINGLE;
        this.set_sort_func (sort_func);

        create_list ();
        connect_signals ();
        select_first_item ();
    }

    private void create_list () {
        Backend.NotifyManager.get_default ().apps.@foreach ((entry) => {
            AppEntry app_entry = new AppEntry (entry.value);
            this.add (app_entry);

            return true;
        });
    }

    private void connect_signals () {
        this.row_selected.connect (show_row);
    }

    private void show_row (Gtk.ListBoxRow? row) {
        if (row == null) {
            return;
        }

        if (!(row is AppEntry)) {
            return;
        }

        Backend.NotifyManager.get_default ().selected_app_id = ((AppEntry)row).app.app_id;
    }

    private void select_first_item () {
        List<weak Gtk.Widget> children = this.get_children ();

        if (children.length () > 0) {
            Gtk.ListBoxRow row = ((Gtk.ListBoxRow)children.nth_data (0));

            this.select_row (row);
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
}

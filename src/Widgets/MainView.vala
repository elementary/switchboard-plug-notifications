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

    static construct {
        set_layout_manager_type (typeof (Gtk.BinLayout));
    }

    construct {
        var sidebar = new Sidebar ();

        var app_settings_view = new AppSettingsView ();

        main_widget = new Gtk.Paned (Gtk.Orientation.HORIZONTAL) {
            start_child = sidebar,
            end_child = app_settings_view,
            resize_start_child = false,
            shrink_start_child = false,
            shrink_end_child = false
        };
        main_widget.set_parent (this);
    }

    ~MainView () {
        while (this.get_last_child () != null) {
            this.get_last_child ().unparent ();
        }
    }
}

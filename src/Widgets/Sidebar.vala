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
 * Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

public class Widgets.Sidebar : Gtk.Box {
    private Gtk.ScrolledWindow scrolled_window;
    private AppList app_list;

    private Footer footer;

    construct {
        build_ui ();
        create_bindings ();
    }

    private void build_ui () {
        this.orientation = Gtk.Orientation.VERTICAL;

        scrolled_window = create_scrolled_window ();

        footer = new Footer ();

        this.pack_start (scrolled_window);
        this.pack_end (footer, false, false);
    }

    private void create_bindings () {
        Backend.NotifyManager.get_default ().bind_property ("do-not-disturb",
                                                            app_list,
                                                            "sensitive",
                                                            BindingFlags.INVERT_BOOLEAN | BindingFlags.SYNC_CREATE);
    }

    private Gtk.ScrolledWindow create_scrolled_window () {
        var scrolled_window = new Gtk.ScrolledWindow (null, null);

        app_list = new AppList ();

        scrolled_window.add (app_list);

        return scrolled_window;
    }
}

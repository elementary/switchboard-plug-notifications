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

public class Widgets.SettingsHeader : Gtk.Grid {
    private Gtk.Image app_image;
    private Gtk.Label app_label;

    construct {
        build_ui ();
    }

    public void set_title (string title) {
        app_label.set_label (title);
        app_label.get_style_context ().add_class ("h2");
    }

    public void set_icon (Icon icon) {
        app_image.set_from_gicon (icon, Gtk.IconSize.DIALOG);
        app_image.set_pixel_size (48);
    }

    private void build_ui () {
        this.column_spacing = 12;

        app_image = new Gtk.Image ();

        app_label = new Gtk.Label (null);
        app_label.use_markup = true;
        app_label.halign = Gtk.Align.START;
        app_label.hexpand = true;

        this.attach (app_image, 0, 0, 1, 1);
        this.attach (app_label, 1, 0, 1, 1);
    }
}

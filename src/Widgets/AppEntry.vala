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

public class Widgets.AppEntry : Gtk.ListBoxRow {
    private static const string BUBBLES_KEY = "bubbles";
    private static const string SOUNDS_KEY = "sounds";
    private static const string REMEMBER_KEY = "remember";

    public Backend.App app { get; construct; }

    private Gtk.Grid grid;

    private Gtk.Image image;
    private Gtk.Label title_label;
    private Gtk.Label description_label;

    public AppEntry (Backend.App app) {
        Object (app: app);

        build_ui ();
        connect_signals ();
    }

    private void build_ui () {
        grid = new Gtk.Grid ();
        grid.margin = 6;
        grid.column_spacing = 6;

        image = new Gtk.Image.from_gicon (app.app_info.get_icon (), Gtk.IconSize.DND);
        image.pixel_size = 32;

        title_label = new Gtk.Label (app.app_info.get_display_name ());
        title_label.get_style_context ().add_class ("h3");
        title_label.ellipsize = Pango.EllipsizeMode.END;
        ((Gtk.Misc) title_label).xalign = 0;
        title_label.valign = Gtk.Align.END;

        description_label = new Gtk.Label (get_permissions_string (app));
        description_label.use_markup = true;
        description_label.ellipsize = Pango.EllipsizeMode.END;
        ((Gtk.Misc) description_label).xalign = 0;
        description_label.valign = Gtk.Align.START;

        grid.attach (image, 0, 0, 1, 2);
        grid.attach (title_label, 1, 0, 1, 1);
        grid.attach (description_label, 1, 1, 1, 1);

        this.add (grid);
    }

    private void connect_signals () {
        app.settings.changed.connect (() => {
            description_label.set_markup (get_permissions_string (app));
        });
    }

    private string get_permissions_string (Backend.App app) {
        string[] items = {};

        if (app.settings.get_boolean (BUBBLES_KEY)) {
            items += _("Bubbles");
        }

        if (app.settings.get_boolean (SOUNDS_KEY)) {
            items += _("Sounds");
        }

        if (app.settings.get_boolean (REMEMBER_KEY)) {
            items += _("Notification Center");
        }

        if (items.length == 0) {
            items += _("Disabled");
        }

        return "<span font_size=\"small\">%s</span>".printf (Markup.escape_text (string.joinv (", ", items)));
    }
}

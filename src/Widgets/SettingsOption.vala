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

public class Widgets.SettingsOption : Gtk.Grid {
    public string image_path { get; construct; }
    public string title { get; construct; }
    public string description { get; construct; }
    public Gtk.Widget widget { get; construct; }

    public SettingsOption (string image_path, string title, string description, Gtk.Widget widget) {
        Object (
            image_path: image_path,
            title: title,
            description: description,
            widget: widget
        );
    }

    construct {
        var image = new Gtk.Image.from_resource (image_path);
        image.halign = Gtk.Align.START;
        image.hexpand = false;

        var title_label = new Gtk.Label (title);
        title_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        title_label.halign = Gtk.Align.START;
        title_label.valign = Gtk.Align.END;
        title_label.hexpand = true;
        title_label.vexpand = false;

        widget.halign = Gtk.Align.START;
        widget.valign = Gtk.Align.CENTER;
        widget.hexpand = false;
        widget.vexpand = false;

        var description_label = new Gtk.Label (description);
        description_label.xalign = 0;
        description_label.valign = Gtk.Align.START;
        description_label.hexpand = true;
        description_label.vexpand = false;
        description_label.wrap = true;
        description_label.justify = Gtk.Justification.LEFT;

        column_spacing = 12;
        row_spacing = 6;
        margin_start = 60;
        margin_end = 30;
        attach (image, 0, 0, 1, 3);
        attach (title_label, 1, 0);
        attach (widget, 1, 1);
        attach (description_label, 1, 2);
    }
}

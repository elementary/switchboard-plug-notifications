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

public class Widgets.SettingsOption : Gtk.Grid {
    public string image_path { get; construct; }
    public string title { get; construct; }
    public string description { get; construct; }
    public Gtk.Widget widget { get; construct; }

    private Gtk.Image image;
    private Gtk.Label title_label;
    private Gtk.Widget option_widget;
    private Gtk.Label description_label;

    public SettingsOption (string image_path, string title, string description, Gtk.Widget widget) {
        Object (image_path: image_path,
                title: title,
                description: description,
                widget: widget);

        build_ui ();
    }

    private void build_ui () {
        this.column_spacing = 6;
        this.row_spacing = 6;
        this.margin_start = 60;
        this.margin_end = 30;

        image = new Gtk.Image.from_file (image_path);
        image.halign = Gtk.Align.START;
        image.hexpand = false;

        title_label = new Gtk.Label ("<span font_weight=\"bold\" size=\"large\">" + title + "</span>");
        title_label.use_markup = true;
        title_label.halign = Gtk.Align.START;
        title_label.valign = Gtk.Align.END;
        title_label.hexpand = true;
        title_label.vexpand = false;

        option_widget = widget;
        option_widget.halign = Gtk.Align.START;
        option_widget.valign = Gtk.Align.CENTER;
        option_widget.hexpand = false;
        option_widget.vexpand = false;

        description_label = new Gtk.Label (description);
        description_label.halign = Gtk.Align.START;
        description_label.valign = Gtk.Align.START;
        description_label.hexpand = true;
        description_label.vexpand = false;
        description_label.wrap = true;
        description_label.justify = Gtk.Justification.FILL;

        this.attach (image, 0, 0, 1, 3);
        this.attach (title_label, 1, 0, 1, 1);
        this.attach (option_widget, 1, 1, 1, 1);
        this.attach (description_label, 1, 2, 1, 1);
    }
}
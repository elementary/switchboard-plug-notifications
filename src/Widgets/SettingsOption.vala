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

public class Widgets.SettingsOption : Gtk.Grid {
    public string image_path { get; construct; }
    public string title { get; construct; }
    public string description { get; construct; }
    public Gtk.Switch widget { get; private set; }

    private Gtk.Grid card;
    private Gtk.Settings gtk_settings;

    public SettingsOption (string image_path, string title, string description) {
        Object (
            image_path: image_path,
            title: title,
            description: description
        );
    }

    construct {
        card = new Gtk.Grid () {
            halign = START
        };
        card.add_css_class (image_path);
        card.add_css_class (Granite.STYLE_CLASS_CARD);
        card.add_css_class (Granite.STYLE_CLASS_ROUNDED);

        widget = new Gtk.Switch () {
            valign = START
        };
        widget.bind_property ("state", widget, "active", SYNC_CREATE | BIDIRECTIONAL);

        var header_label = new Granite.HeaderLabel (title) {
            hexpand = true,
            halign = FILL,
            secondary_text = description,
            mnemonic_widget = widget
        };

        column_spacing = 12;
        attach (header_label, 0, 0);
        attach (widget, 1, 0);
        attach (card, 0, 1, 2);

        gtk_settings = Gtk.Settings.get_default ();
        gtk_settings.notify["gtk-application-prefer-dark-theme"].connect (() => {
            update_image_resource ();
        });

        update_image_resource ();
    }

    private void update_image_resource () {
        if (gtk_settings.gtk_application_prefer_dark_theme) {
            card.add_css_class ("dark");
        } else {
            card.remove_css_class ("dark");
        }
    }
}

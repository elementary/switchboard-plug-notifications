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

public class Widgets.Footer : Gtk.ActionBar {
    construct {
        get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);

        var do_not_disturb_label = new Granite.HeaderLabel (_("Do Not Disturb"));
        do_not_disturb_label.margin_start = 6;

        var do_not_disturb_switch = new Gtk.Switch ();
        do_not_disturb_switch.margin = 12;
        do_not_disturb_switch.margin_end = 6;

        pack_start (do_not_disturb_label);
        pack_end (do_not_disturb_switch);

        NotificationsPlug.notify_settings.bind ("do-not-disturb", do_not_disturb_switch, "state", SettingsBindFlags.DEFAULT);
    }
}

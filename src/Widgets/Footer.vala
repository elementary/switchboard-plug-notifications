/***
	BEGIN LICENSE

	Copyright (C) 2014 elementary Developers
	This program is free software: you can redistribute it and/or modify it
	under the terms of the GNU Lesser General Public License version 3, as published
	by the Free Software Foundation.

	This program is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranties of
	MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
	PURPOSE.  See the GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with this program.  If not, see <http://www.gnu.org/licenses/>

	END LICENSE
	Written By: Marcus Wichelmann <admin@marcusw.de>

***/

public class Widgets.Footer : Gtk.Grid {
	private Gtk.Label do_not_disturb_label;
	private Gtk.Switch do_not_disturb_switch;

	public Footer () {
		// FIXME: There can't be a margin on the right, because the Gtk.Switch has its own.
		this.margin_top = 12;
		this.margin_bottom = 12;
		this.margin_start = 12;
		this.column_spacing = 12;

		do_not_disturb_label = new Gtk.Label ("<b>" + _("Do Not Disturb") + "</b>");
		do_not_disturb_label.use_markup = true;
		do_not_disturb_label.halign = Gtk.Align.START;

		do_not_disturb_switch = new Gtk.Switch ();
		do_not_disturb_switch.hexpand = true;
		do_not_disturb_switch.halign = Gtk.Align.END;

		this.attach (do_not_disturb_label, 0, 0, 1, 1);
		this.attach (do_not_disturb_switch, 1, 0, 1, 1);

		NotifySettings.get_default ().settings.bind ("do-not-disturb", do_not_disturb_switch, "active", SettingsBindFlags.DEFAULT);
	}
}

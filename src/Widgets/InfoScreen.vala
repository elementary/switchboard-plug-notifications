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

public class Widgets.InfoScreen : Gtk.Frame {
	private Gtk.Grid grid;

	private Gtk.Image image;
	private Gtk.Label title;
	private Gtk.Label description;

	// Compareable to the widget of switchboard-plug-security-privacy.
	public InfoScreen () {
		this.expand = true;
		this.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);

		grid = new Gtk.Grid ();
		grid.vexpand = false;
		grid.valign = Gtk.Align.CENTER;
		grid.halign = Gtk.Align.CENTER;
		grid.border_width = 24;
		grid.row_spacing = 12;
		grid.column_spacing = 12;

		image = new Gtk.Image.from_icon_name ("notification-do-not-disturb", Gtk.IconSize.DIALOG);
		image.valign = Gtk.Align.START;
		image.halign = Gtk.Align.END;

		grid.attach (image, 0, 0, 1, 2);

		title = new Gtk.Label (_("elementary OS is in Do Not Disturb mode"));
		title.halign = Gtk.Align.START;
		title.justify = Gtk.Justification.FILL;
		title.get_style_context ().add_class ("h2");
		grid.attach (title, 1, 0, 1, 1);

		description = new Gtk.Label ("%s\n\n%s".printf (
				_("While in Do Not Disturb mode, notifications and alerts will be hidden and notification sounds will be silenced."),
				_("Confirmations like the brightness display aren't affected.")));
		description.halign = Gtk.Align.START;
		description.set_line_wrap (true);
		description.justify = Gtk.Justification.FILL;
		grid.attach (description, 1, 1, 1, 1);

		grid.show_all ();

		this.add (grid);
	}
}

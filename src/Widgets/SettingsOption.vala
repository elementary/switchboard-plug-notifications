/***
	BEGIN LICENSE

	Copyright (C) 2014-2015 elementary Developers
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

public class Widgets.SettingsOption : Gtk.Grid {
	private Gtk.Image image;
	private Gtk.Label title_label;
	private Gtk.Widget option_widget;
	private Gtk.Label description_label;

	public SettingsOption (string image_path, string title, string description, Gtk.Widget widget) {
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

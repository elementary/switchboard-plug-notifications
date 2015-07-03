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

public class Widgets.AppEntry : Gtk.ListBoxRow {
	private Backend.App app;

	private Gtk.Grid grid;

	private Gtk.Image image;
	private Gtk.Label title_label;
	private Gtk.Label description_label;

	public AppEntry (Backend.App app) {
		this.app = app;

		build_ui ();
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
		title_label.halign = Gtk.Align.START;
		title_label.valign = Gtk.Align.END;

		description_label = new Gtk.Label (get_permissions_string (app.permissions));
		description_label.ellipsize = Pango.EllipsizeMode.END;
		description_label.halign = Gtk.Align.START;
		description_label.valign = Gtk.Align.START;

		grid.attach (image, 0, 0, 1, 2);
		grid.attach (title_label, 1, 0, 1, 1);
		grid.attach (description_label, 1, 1, 1, 1);

		this.add (grid);
	}

	private string get_permissions_string (Backend.App.Permissions permissions) {
		if (permissions.enable_bubbles && permissions.enable_sounds) return _("Sounds and Bubbles");
		if (permissions.enable_bubbles) return _("Bubbles");
		if (permissions.enable_sounds) return _("Sounds");

		return _("Disabled");
	}
}

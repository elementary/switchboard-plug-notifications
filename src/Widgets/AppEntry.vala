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
	private bool notify_center_installed = false;

	private Backend.App app;

	private Gtk.Grid grid;

	private Gtk.Image image;
	private Gtk.Label title_label;
	private Gtk.Label description_label;

	public AppEntry (Backend.App app) {
		this.app = app;

		notify_center_installed = Backend.NotifyManager.get_default ().notify_center_blacklist.is_installed;

		build_ui ();
		connect_signals ();
	}

	public Backend.App get_app () {
		return app;
	}

	public string get_title () {
		return app.app_info.get_display_name ();
	}

	private void build_ui () {
		grid = new Gtk.Grid ();
		grid.margin = 6;
		grid.column_spacing = 6;

		image = new Gtk.Image.from_gicon (app.app_info.get_icon (), Gtk.IconSize.DND);
		image.pixel_size = 32;

		title_label = new Gtk.Label (Markup.escape_text (app.app_info.get_display_name ()));
		title_label.get_style_context ().add_class ("h3");
		title_label.ellipsize = Pango.EllipsizeMode.END;
		title_label.halign = Gtk.Align.START;
		title_label.valign = Gtk.Align.END;

		description_label = new Gtk.Label (get_permissions_string (app));
		description_label.ellipsize = Pango.EllipsizeMode.END;
		description_label.halign = Gtk.Align.START;
		description_label.valign = Gtk.Align.START;

		grid.attach (image, 0, 0, 1, 2);
		grid.attach (title_label, 1, 0, 1, 1);
		grid.attach (description_label, 1, 1, 1, 1);

		this.add (grid);
	}

	private void connect_signals () {
		app.notify["permissions"].connect (() => {
			description_label.set_label (get_permissions_string (app));
		});

		if (notify_center_installed) {
			Backend.NotifyManager.get_default ().notify_center_blacklist.notify["blacklist"].connect (() => {
				description_label.set_label (get_permissions_string (app));
			});
		}
	}

	private string get_permissions_string (Backend.App app) {
		Backend.App.Permissions permissions = app.permissions;
		bool sinc = false;

		if (notify_center_installed)
			sinc = !(app.app_id in Backend.NotifyManager.get_default ().notify_center_blacklist.blacklist);

		string[] items = {};

		if (permissions.enable_bubbles)
			items += _("Bubbles");
		if (permissions.enable_sounds)
			items +=_("Sounds");
		if (sinc)
			items += _("Notification-Center");

		if (items.length == 0)
			return _("Disabled");

		return string.joinv (", ", items);
	}
}

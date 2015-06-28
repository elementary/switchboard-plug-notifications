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

public class Widgets.SettingsHeader : Gtk.Grid {
	private Gtk.Image app_image;
	private Gtk.Label app_label;

	public SettingsHeader () {
		app_image = new Gtk.Image ();

		app_label = new Gtk.Label (null);
		app_label.halign = Gtk.Align.START;
		app_label.hexpand = true;

		this.attach (app_image, 0, 0, 1, 1);
		this.attach (app_label, 1, 0, 1, 1);
	}
}

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

public class Widgets.Sidebar : Gtk.Box {
	private Gtk.ScrolledWindow scrolled_window;
	private AppList app_list;

	private Footer footer;

	public Sidebar () {
		this.orientation = Gtk.Orientation.VERTICAL;

		scrolled_window = create_scrolled_window ();

		footer = new Footer ();

		this.pack_start (scrolled_window);
		this.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false);
		this.pack_end (footer, false, false);
	}

	private Gtk.ScrolledWindow create_scrolled_window () {
		var scrolled_window = new Gtk.ScrolledWindow (null, null);

		app_list = new AppList ();

		scrolled_window.add (app_list);

		return scrolled_window;
	}
}

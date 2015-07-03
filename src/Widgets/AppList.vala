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

public class Widgets.AppList : Gtk.ListBox {
	public AppList () {
		this.selection_mode = Gtk.SelectionMode.SINGLE;

		create_list ();
		sort_list ();
	}

	private void create_list () {
		Backend.NotifyManager.get_default ().apps.@foreach ((entry) => {
			AppEntry app_entry = new AppEntry (entry.value);

			this.add (app_entry);

			return true;
		});
	}

	private void sort_list () {
		// TODO
	}
}

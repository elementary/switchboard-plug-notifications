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
		this.set_sort_func (sort_func);

		create_list ();
		connect_signals ();
		select_first_item ();
	}

	private void create_list () {
		Backend.NotifyManager.get_default ().apps.foreach ((entry) => {
			AppEntry app_entry = new AppEntry (entry.value);

			this.add (app_entry);

			return true;
		});
	}

	private void connect_signals () {
		this.row_selected.connect ((row) => {
			show_row (row);
		});
	}

	private void show_row (Gtk.ListBoxRow? row) {
		if (row == null)
			return;

		if (!(row is AppEntry))
			return;

		Backend.NotifyManager.get_default ().selected_app_id = ((AppEntry)row).get_app ().app_id;
	}

	private void select_first_item () {
		List<weak Gtk.Widget> children = this.get_children ();

		if (children.length () > 0) {
			Gtk.ListBoxRow row = ((Gtk.ListBoxRow)children.nth_data (0));

			this.select_row (row);
			show_row (row);
		}
	}

	private int sort_func (Gtk.ListBoxRow row1, Gtk.ListBoxRow row2) {
		if (!(row1 is AppEntry && row2 is AppEntry))
			return 0;

		string row_name1 = ((AppEntry)row1).get_title ();
		string row_name2 = ((AppEntry)row2).get_title ();

		int order = strcmp (row_name1, row_name2);

		return order.clamp (-1, 1);
	}
}

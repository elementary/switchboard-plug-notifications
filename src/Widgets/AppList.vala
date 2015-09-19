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

public class Widgets.AppList : Gtk.ListBox {
	private int item_count;
	private Cancellable list_apps_cancellable;

	public signal void item_changed (AppItem item);
	public signal void list_loaded (int length);

	public AppItem selected_row;

	public AppList () {
		this.selection_mode = Gtk.SelectionMode.SINGLE;
		this.row_selected.connect ((row) => {
			if (row != null) {
				selected_row = row as AppItem;
				item_changed (row as AppItem);
			}
		});

		list_apps_cancellable = new Cancellable ();
		NotifySettings.get_default ().apps_changed.connect (() => {
			if (NotifySettings.get_default ().apps.length != item_count) {
				list_apps ();
			}
		});

		list_apps ();
	}

	private void list_apps () {
		list_apps_cancellable.cancel ();
		this.get_children ().foreach ((row) => {
			this.remove (row);
			});
		list_apps_cancellable.reset ();
		list_apps_async.begin ();
	}

	private async void list_apps_async () {
		var apps = NotifySettings.get_default ().apps;
		item_count = apps.length;

		foreach (var app in apps) {
			var idle_handler = Idle.add (list_apps_async.callback);
			var cancellable_handler = list_apps_cancellable.connect (() => {
				Source.remove(idle_handler);
			});
			yield;
			list_apps_cancellable.disconnect (cancellable_handler);

			var parameters = app.split (":");

			if (parameters.length == 2) {
				var properties = parameters[1].split (",");

				if (properties.length == 2 && parameters[0] != "notify-send") {
					var item = new AppItem (parameters[0], properties);
					this.add (item);
				}
			}

			if (selected_row == null && NotifySettings.get_default ().do_not_disturb == false)
				select_first ();

			this.show_all ();
			list_loaded (item_count);
		}
	}

	public void select_first () {
		if (item_count > 0) {
			var first_row = this.get_row_at_index (0);

			this.select_row (first_row);
			selected_row = first_row as AppItem;
		}
	}

	public void select_none () {
		this.select_row (null);
	}
}

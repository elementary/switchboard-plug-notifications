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

public class Widgets.AppsView : Granite.Widgets.ThinPaned {
	private AppList applist;

	private AppSettings appsettings;

	public AppsView () {
		applist = new AppList ();
		appsettings = new AppSettings ();

		this.add1 (applist);
		this.add2 (appsettings);
		this.set_position (220);

		select_app (applist.selected_row);

		applist.item_changed.connect (select_app);

		appsettings.bubbles_changed.connect ((priority) => {
			var selected_item = applist.selected_row as AppItem;
			selected_item.set_priority (priority);
		});
		appsettings.allow_sounds_changed.connect ((allow_sounds) => {
			(applist.selected_row as AppItem).set_allow_sounds (allow_sounds);
		});

		NotifySettings.get_default ().do_not_disturb_changed.connect ((do_not_disturb) => {
			this.set_sensitive (do_not_disturb == false);
		});
	}

	private void select_app (AppItem item) {
		appsettings.set_appicon (item.get_icon ());
		appsettings.set_apptitle (item.get_title ());
		appsettings.set_priority (item.get_priority ());
		appsettings.set_allow_sounds (item.get_allow_sounds () == "on");
		appsettings.set_sensitive (true);
	}
}

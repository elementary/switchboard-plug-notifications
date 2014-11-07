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

		applist.item_selected.connect ((item) => {
			appsettings.appicon.set_from_gicon ((item as AppItem).get_icon (), Gtk.IconSize.DIALOG);
			appsettings.apptitle.set_label ((item as AppItem).get_title ());
			appsettings.appdescription.set_label ((item as AppItem).get_description ());
		});
	}
}
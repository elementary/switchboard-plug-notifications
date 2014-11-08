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

public class Widgets.AppList : Granite.Widgets.SourceList {
	private Granite.Widgets.SourceList.ExpandableItem root_item;

	private Granite.Widgets.SourceList.ExpandableItem group_enabled;
	private Granite.Widgets.SourceList.ExpandableItem group_disabled;

	public AppList () {
		root_item = new Granite.Widgets.SourceList.ExpandableItem ();
		group_enabled = new Granite.Widgets.SourceList.ExpandableItem (_("Enabled"));
		group_enabled.expanded = true;

		group_disabled = new Granite.Widgets.SourceList.ExpandableItem (_("Disabled"));
		group_disabled.expanded = true;

		root_item.add (group_enabled);
		root_item.add (group_disabled);

		this.root = root_item;
		this.show_all ();

		list_apps ();

		NotifySettings.get_default ().apps_changed.connect (() => {
			group_enabled.clear ();
			group_disabled.clear ();
			list_apps ();
		});
	}

	private void list_apps () {
		for (int i = 0; i < NotifySettings.get_default ().apps.length; i++) {
			var parameters = NotifySettings.get_default ().apps[i].split (":");
			var item = new AppItem (parameters[0]);
			if (parameters[1].split (",")[0] == "0") {
				group_disabled.add (item);
			} else {
				group_enabled.add (item);
			}
		}

		var first_item = this.get_first_child (group_enabled);

		if (first_item == null)
			first_item = this.get_first_child (group_disabled);

		if (first_item != null)
			this.selected = first_item;
	}
}
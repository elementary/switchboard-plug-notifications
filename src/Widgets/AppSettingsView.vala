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

public class Widgets.AppSettingsView : Gtk.Grid {
	private SettingsHeader header;

	private Gtk.Switch bubbles_switch;
	private SettingsOption bubbles_option;

	private Gtk.Switch sound_switch;
	private SettingsOption sound_option;

	private Gtk.Switch sinc_switch; // sinc = show in notifications center
	private SettingsOption sinc_option;

	public AppSettingsView () {
		this.margin = 12;
		this.row_spacing = 60;

		header = new SettingsHeader ();

		bubbles_option = new SettingsOption (
				Constants.PKGDATADIR + "/bubbles.svg",
				_("Bubbles"),
				_("Bubbles appear in the top right corner of the display and disappear automatically."),
				bubbles_switch = new Gtk.Switch ());

		sound_option = new SettingsOption (
				Constants.PKGDATADIR + "/sounds.svg",
				_("Sounds"),
				_("Sounds play once when a new notification arrives."),
				sound_switch = new Gtk.Switch ());

		sinc_option = new SettingsOption (
				Constants.PKGDATADIR + "/notify-center.svg",
				_("Notification Center"),
				_("Show missed notifications in Notification Center."),
				sinc_switch = new Gtk.Switch ());

		this.attach (header, 0, 0, 1, 1);
		this.attach (bubbles_option, 0, 1, 1, 1);
		this.attach (sound_option, 0, 2, 1, 1);
		this.attach (sinc_option, 0, 3, 1, 1);
	}
}

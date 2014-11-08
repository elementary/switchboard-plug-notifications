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

public class Widgets.AppSettings : Gtk.Grid {
	private Gtk.Image appicon;
	private Gtk.Label apptitle;

	private Gtk.Image bubblesimage;
	private Gtk.Label bubblestitle;
	private Gtk.ComboBoxText bubblescombobox;
	private Gtk.Label bubblesinfo;

	private Gtk.Image soundsimage;
	private Gtk.Label soundstitle;
	private Gtk.Switch soundsswitch;
	private Gtk.Label soundsinfo;

	public AppSettings () {
		this.margin = 12;
		this.row_spacing = 12;
		this.column_spacing = 12;

		appicon = new Gtk.Image ();
		this.attach (appicon, 0, 0, 1, 1);

		apptitle = new Gtk.Label (null);
		apptitle.halign = Gtk.Align.START;
		apptitle.hexpand = true;
		this.attach (apptitle, 1, 0, 2, 1);

		bubblesimage = new Gtk.Image.from_file (Constants.PKGDATADIR + "/bubbles.svg");
		bubblesimage.halign = Gtk.Align.START;
		bubblesimage.hexpand = false;
		bubblesimage.margin_top = 50;
		this.attach (bubblesimage, 1, 1, 1, 3);

		bubblestitle = new Gtk.Label ("<span font_weight=\"bold\" size=\"large\">" + _("Bubbles") + "</span>");
		bubblestitle.use_markup = true;
		bubblestitle.halign = Gtk.Align.START;
		bubblestitle.valign = Gtk.Align.START;
		bubblestitle.hexpand = true;
		bubblestitle.vexpand = false;
		bubblestitle.margin_top = 50 + 5;
		this.attach (bubblestitle, 2, 1, 1, 1);

		bubblescombobox = new Gtk.ComboBoxText ();
		bubblescombobox.append_text (_("Show all"));							// 0
		bubblescombobox.append_text (_("Disable low notifications"));			// 1
		bubblescombobox.append_text (_("Show critical notifications only"));	// 2
		bubblescombobox.append_text (_("Don't show any"));						// 3
		bubblescombobox.halign = Gtk.Align.START;
		bubblescombobox.valign = Gtk.Align.CENTER;
		bubblescombobox.hexpand = false;
		bubblescombobox.vexpand = false;
		this.attach (bubblescombobox, 2, 2, 1, 1);

		bubblesinfo = new Gtk.Label (_("Bubbles appear in the top right corner of the display and disappear automatically."));
		bubblesinfo.halign = Gtk.Align.START;
		bubblesinfo.valign = Gtk.Align.START;
		bubblesinfo.hexpand = true;
		bubblesinfo.vexpand = false;
		bubblesinfo.margin_bottom = 9;
		this.attach (bubblesinfo, 2, 3, 1, 1);

		soundsimage = new Gtk.Image.from_file (Constants.PKGDATADIR + "/sounds.svg");
		soundsimage.halign = Gtk.Align.START;
		soundsimage.hexpand = false;
		soundsimage.margin_top = 50;
		this.attach (soundsimage, 1, 4, 1, 3);

		soundstitle = new Gtk.Label ("<span font_weight=\"bold\" size=\"large\">" + _("Sounds") + "</span>");
		soundstitle.use_markup = true;
		soundstitle.halign = Gtk.Align.START;
		soundstitle.valign = Gtk.Align.START;
		soundstitle.hexpand = true;
		soundstitle.vexpand = false;
		soundstitle.margin_top = 50 + 5;
		this.attach (soundstitle, 2, 4, 1, 1);

		soundsswitch = new Gtk.Switch ();
		soundsswitch.halign = Gtk.Align.START;
		soundsswitch.valign = Gtk.Align.CENTER;
		soundsswitch.hexpand = false;
		soundsswitch.vexpand = false;
		this.attach (soundsswitch, 2, 5, 1, 1);

		soundsinfo = new Gtk.Label (_("Sounds play once when a new notification arrives."));
		soundsinfo.halign = Gtk.Align.START;
		soundsinfo.valign = Gtk.Align.START;
		soundsinfo.hexpand = true;
		soundsinfo.vexpand = false;
		soundsinfo.margin_bottom = 9;
		this.attach (soundsinfo, 2, 6, 1, 1);

		this.show_all ();
	}

	public void set_appicon (Icon icon) {
		appicon.set_from_gicon (icon, Gtk.IconSize.DIALOG);
	}

	public void set_apptitle (string title) {
		apptitle.set_label (@"<span font_weight=\"bold\" size=\"x-large\">$title</span>");
		apptitle.set_use_markup (true);
	}

	public void set_priority (string priority) {
		switch (priority) {
			case "0":
				bubblescombobox.set_active (3);
				break;
			case "1":
				bubblescombobox.set_active (2);
				break;
			case "2":
				bubblescombobox.set_active (1);
				break;
			case "3":
				bubblescombobox.set_active (0);
				break;
		}
	}

	public void set_allow_sounds (bool allow_sounds) {
		soundsswitch.set_active (allow_sounds);
	}
}
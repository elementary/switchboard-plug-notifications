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

	private Gtk.Image soundsimage;
	private Gtk.Label soundstitle;

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
		this.attach (bubblesimage, 1, 1, 1, 1);

		bubblestitle = new Gtk.Label ("<span font_weight=\"bold\" size=\"large\">" + _("Bubbles") + "</span>");
		bubblestitle.use_markup = true;
		bubblestitle.halign = Gtk.Align.START;
		bubblestitle.valign = Gtk.Align.START;
		bubblestitle.hexpand = true;
		bubblestitle.vexpand = false;
		bubblestitle.margin_top = 50;
		this.attach (bubblestitle, 2, 1, 1, 1);

		soundsimage = new Gtk.Image.from_file (Constants.PKGDATADIR + "/sounds.svg");
		soundsimage.halign = Gtk.Align.START;
		soundsimage.hexpand = false;
		soundsimage.margin_top = 50;
		soundsimage.margin_bottom = 20;
		this.attach (soundsimage, 1, 2, 1, 1);

		soundstitle = new Gtk.Label ("<span font_weight=\"bold\" size=\"large\">" + _("Sounds") + "</span>");
		soundstitle.use_markup = true;
		soundstitle.halign = Gtk.Align.START;
		soundstitle.valign = Gtk.Align.START;
		soundstitle.hexpand = true;
		soundstitle.vexpand = false;
		soundstitle.margin_top = 50;
		this.attach (soundstitle, 2, 2, 1, 1);

		this.show_all ();
	}

	public void set_appicon (Icon icon) {
		appicon.set_from_gicon (icon, Gtk.IconSize.DIALOG);
	}

	public void set_apptitle (string title) {
		apptitle.set_label (@"<span font_weight=\"bold\" size=\"x-large\">$title</span>");
		apptitle.set_use_markup (true);
	}
}
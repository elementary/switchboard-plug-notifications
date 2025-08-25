/*
 * SPDX-FileCopyrightText: 2011-2025 elementary, Inc. (https://elementary.io)
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

public class NotificationsPlug : Switchboard.Plug {
    public static GLib.Settings notify_settings;

    private Adw.ToolbarView placeholder_view;
    private Gtk.Stack stack;
    private Widgets.MainView main_view;

    public NotificationsPlug () {
        GLib.Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");

        var settings = new Gee.TreeMap<string, string?> (null, null);
        settings.set ("notifications", null);
        Object (category: Category.PERSONAL,
                code_name: "io.elementary.settings.notifications",
                display_name: _("Notifications"),
                description: _("Configure notification bubbles, sounds, and notification center"),
                icon: "preferences-system-notifications",
                supported_settings: settings);
    }

    static construct {
        if (GLib.SettingsSchemaSource.get_default ().lookup ("io.elementary.notifications", true) != null) {
            debug ("Using io.elementary.notifications server");
            notify_settings = new GLib.Settings ("io.elementary.notifications");
        } else {
            debug ("Using notifications in gala");
            notify_settings = new GLib.Settings ("org.pantheon.desktop.gala.notifications");
        }
    }

    public override Gtk.Widget get_widget () {
        if (stack != null) {
            return stack;
        }

        main_view = new Widgets.MainView ();

        var alert_view = new Granite.Placeholder (_("Apps with configurable notifications will appear here once installed.")) {
            description = _("Notifications preferences are for configuring which apps make use of notifications, for changing how an app's notifications appear, and for setting when you do not want to be disturbed by notifications."),
            icon = new ThemedIcon ("dialog-information")
        };

        placeholder_view = new Adw.ToolbarView () {
            content = alert_view
        };
        placeholder_view.add_top_bar (new Adw.HeaderBar ());

        stack = new Gtk.Stack () {
            vhomogeneous = false
        };
        stack.add_child (main_view);
        stack.add_child (placeholder_view);

        return stack;
    }

    public override void shown () {
        if (Backend.NotifyManager.get_default ().apps.size > 0) {
            stack.visible_child = main_view;
        } else {
            stack.visible_child = placeholder_view;
        }
    }

    public override void hidden () {
    }

    public override void search_callback (string location) {
    }

    public override async Gee.TreeMap<string, string> search (string search) {
        var search_results = new Gee.TreeMap<string, string> ((GLib.CompareDataFunc<string>)strcmp, (Gee.EqualDataFunc<string>)str_equal);
        search_results.set ("%s → %s".printf (display_name, _("Do Not Disturb")), "");
        search_results.set ("%s → %s".printf (display_name, _("Notifications Center")), "");
        search_results.set ("%s → %s".printf (display_name, _("Sound")), "");
        search_results.set ("%s → %s".printf (display_name, _("Bubbles")), "");
        return search_results;
    }
}

public Switchboard.Plug get_plug (Module module) {
    debug ("Activating Notifications plug");
    var plug = new NotificationsPlug ();

    return plug;
}

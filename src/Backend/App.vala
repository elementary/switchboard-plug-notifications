/*
 * Copyright (c) 2011-2015 elementary Developers
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

public class Backend.App : Object {
    private static const string CHILD_SCHEMA_ID = "org.pantheon.desktop.gala.notifications.application";
    private static const string CHILD_PATH = "/org/pantheon/desktop/gala/notifications/applications/%s/";

    public DesktopAppInfo app_info { get; construct; }
    public string app_id { get; private set; }
    public Settings settings { get; private set; }

    public App (DesktopAppInfo app_info) {
        Object (app_info: app_info);

        app_id = app_info.get_id ().replace (".desktop", "");
        settings = new Settings.full (SettingsSchemaSource.get_default ().lookup (CHILD_SCHEMA_ID, false), null, CHILD_PATH.printf (app_id));
    }
}
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
    public struct Permissions {
        public bool enable_bubbles;
        public bool enable_sounds;
    }

    public string app_id { get; private set; }
    public DesktopAppInfo app_info { get; private set; }
    public Permissions permissions { get; set; }

    public App (string app_id, DesktopAppInfo app_info, Permissions permissions) {
        this.app_id = app_id;
        this.app_info = app_info;
        this.permissions = permissions;
    }
}
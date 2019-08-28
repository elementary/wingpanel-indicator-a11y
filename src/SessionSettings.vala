/*
* Copyright (c) 2015-2019 elementary, Inc. (https://elementary.io)
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
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

public class A11Y.A11ySettings : Granite.Services.Settings {
    public bool always_show_universal_access_status { get; set; }

    public A11ySettings () {
        base ("org.gnome.desktop.a11y");
    }
}

public class A11Y.ApplicationsSettings : Granite.Services.Settings {
    public bool screen_reader_enabled { get; set; }
    public bool screen_keyboard_enabled { get; set; }

    public ApplicationsSettings () {
        base ("org.gnome.desktop.a11y.applications");
    }
}

public class A11Y.KeyboardSettings : Granite.Services.Settings {
    public bool slowkeys_enable { get; set; }
    public bool bouncekeys_enable { get; set; }
    public bool stickykeys_enable { get; set; }

    public KeyboardSettings () {
        base ("org.gnome.desktop.a11y.keyboard");
    }
}

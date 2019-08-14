/*
* Copyright (c) 2015-2018 elementary, Inc. (https://elementary.io)
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
*
* Authored by: Felipe Escoto <felescoto95@hotmail.com>
*/

public class A11Y.DesktopInterface : Granite.Services.Settings {
    private const string HIGH_CONTRAST_THEME = "HighContrast";

    public string gtk_theme { get; set; }
    public string icon_theme { get; set; }

    private WmSettings wm_settings;

    public DesktopInterface () {
        base ("org.gnome.desktop.interface");
        wm_settings = new WmSettings ();
    }

    public bool get_high_contrast () {
        if (gtk_theme == HIGH_CONTRAST_THEME) {
            return true;
        } else {
            return false;
        }
    }

    public void set_high_contrast (bool state) {
        if (state) {
            gtk_theme = HIGH_CONTRAST_THEME;
            icon_theme = HIGH_CONTRAST_THEME;
        } else {
            schema.reset ("gtk-theme");
            schema.reset ("icon-theme");
            wm_settings.schema.reset ("theme");
        }
    }
}

public class A11Y.A11ySettings : Granite.Services.Settings {
    public bool always_show_universal_access_status { get; set; }

    public A11ySettings () {
        base ("org.gnome.desktop.a11y");
    }
}

public class A11Y.WmSettings : Granite.Services.Settings {
    public string? theme { get; set; }
    public WmSettings () {
        base ("org.gnome.desktop.wm.preferences");
    }
}

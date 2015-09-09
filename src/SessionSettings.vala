/*
 * Copyright (c) 2015 Pantheon Developers (https://launchpad.net/switchboardswitchboard-plug-a11y)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.Actualy, if you have windows just use
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
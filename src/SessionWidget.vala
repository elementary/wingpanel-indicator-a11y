/*
 * Copyright (c) 2011-2018 elementary, Inc. (https://elementary.io)
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
 * Boston, MA 02110-1301 USA.
 */

public class A11Y.SessionWidget : Gtk.Grid {
    public SessionWidget () {
        /*var desktop_interface = new DesktopInterface ();

        var high_contrast = new Wingpanel.Widgets.Switch (_("HighContrast"), false);
        high_contrast.switched.connect (() => {
            desktop_interface.set_high_contrast (high_contrast.get_active ());
        });
        attach (high_contrast, 0, 0, 1, 1);
        high_contrast.active = desktop_interface.get_high_contrast ();
        desktop_interface.notify["gtk-theme"].connect (() => {
            high_contrast.active = desktop_interface.get_high_contrast ();
        });*/
    }
}

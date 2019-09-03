/*
 * Copyright (c) 2011-2019 elementary, Inc. (https://elementary.io)
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

public class A11Y.Indicator : Wingpanel.Indicator {
    private Wingpanel.Widgets.OverlayIcon panel_icon;
    private Gtk.Grid main_grid;

    public Wingpanel.IndicatorManager.ServerType server_type { get; construct set; }

    public Indicator (Wingpanel.IndicatorManager.ServerType indicator_server_type) {
        Object (code_name: "a11y",
                display_name: _("Accessibility"),
                description: _("Accessibility indicator"),
                server_type: indicator_server_type);
    }

    public override Gtk.Widget get_display_widget () {
        if (panel_icon == null) {
            panel_icon = new Wingpanel.Widgets.OverlayIcon ("preferences-desktop-accessibility-symbolic");

            if (server_type == Wingpanel.IndicatorManager.ServerType.GREETER) {
                this.visible = true;
            } else {
                var visible_settings = new Settings ("org.gnome.desktop.a11y");
                visible_settings.bind ("always-show-universal-access-status", this, "visible", SettingsBindFlags.DEFAULT);
            }
        }

        return panel_icon;
    }

    public override Gtk.Widget? get_widget () {
        if (main_grid == null) {
            if (server_type == Wingpanel.IndicatorManager.ServerType.GREETER) {
                main_grid = new GreeterWidget ();
            } else {
                main_grid = new SessionWidget ();
            }
        }

        return main_grid;
    }

    public override void opened () {
    }

    public override void closed () {
    }
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("Activating Accessibility Indicator");
    return new A11Y.Indicator (server_type);
}

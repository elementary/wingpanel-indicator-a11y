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
    private Gtk.Image panel_icon;
    private Gtk.Widget main_widget;

    public Wingpanel.IndicatorManager.ServerType server_type { get; construct set; }

    public Indicator (Wingpanel.IndicatorManager.ServerType indicator_server_type) {
        GLib.Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        GLib.Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");

        Object (code_name: Wingpanel.Indicator.ACCESSIBILITY,
                server_type: indicator_server_type);
    }

    public override Gtk.Widget get_display_widget () {
        if (panel_icon == null) {
            panel_icon = new Gtk.Image.from_icon_name ("preferences-desktop-accessibility-symbolic");

            if (server_type == Wingpanel.IndicatorManager.ServerType.GREETER) {
                this.visible = true;
            } else {
                var visible_settings = new Settings ("io.elementary.desktop.wingpanel.a11y");
                visible_settings.bind ("show-indicator", this, "visible", SettingsBindFlags.DEFAULT);
            }
        }

        return panel_icon;
    }

    public override Gtk.Widget? get_widget () {
        if (main_widget == null) {
            if (server_type == Wingpanel.IndicatorManager.ServerType.GREETER) {
                //  main_widget = new GreeterWidget ();
            } else {
                main_widget = new SessionWidget ();
            }
        }

        return main_widget;
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

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

public class A11Y.SessionWidget : Gtk.Grid {
    private Gtk.Button zoom_default_button;
    private Gtk.Button zoom_in_button;
    private Gtk.Button zoom_out_button;
    private Settings interface_settings;

    construct {
        zoom_out_button = new Gtk.Button.from_icon_name ("zoom-out-symbolic", Gtk.IconSize.MENU);
        zoom_out_button.tooltip_text = _("Decrease text size");

        zoom_default_button = new Gtk.Button.with_label ("100%");
        zoom_default_button.tooltip_text = _("Default text size");

        zoom_in_button = new Gtk.Button.from_icon_name ("zoom-in-symbolic", Gtk.IconSize.MENU);
        zoom_in_button.tooltip_text = _("Increase text size");

        var font_size_grid = new Gtk.Grid ();
        font_size_grid.column_homogeneous = true;
        font_size_grid.hexpand = true;
        font_size_grid.margin = 12;
        font_size_grid.margin_bottom = font_size_grid.margin_top = 6;
        font_size_grid.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);
        font_size_grid.add (zoom_out_button);
        font_size_grid.add (zoom_default_button);
        font_size_grid.add (zoom_in_button);

        var screen_reader = new Wingpanel.Widgets.Switch (_("Screen Reader"));

        var onscreen_keyboard = new Wingpanel.Widgets.Switch (_("Onscreen Keyboard"));

        var slow_keys = new Wingpanel.Widgets.Switch (_("Slow Keys"));

        var bounce_keys = new Wingpanel.Widgets.Switch (_("Bounce Keys"));

        var sticky_keys = new Wingpanel.Widgets.Switch (_("Sticky Keys"));

        var settings_button = new Gtk.ModelButton ();
        settings_button.text = _("Universal Access Settings…");

        orientation = Gtk.Orientation.VERTICAL;
        add (font_size_grid);
        add (screen_reader);
        add (onscreen_keyboard);
        add (slow_keys);
        add (bounce_keys);
        add (sticky_keys);
        add (new Wingpanel.Widgets.Separator ());
        add (settings_button);

        settings_button.clicked.connect (() => {
            try {
                AppInfo.launch_default_for_uri ("settings://universal-access", null);
            } catch (Error e) {
                warning ("Failed to open universal access settings: %s", e.message);
            }
        });

        zoom_default_button.clicked.connect (() => {
            interface_settings.reset ("text-scaling-factor");
        });

        zoom_in_button.clicked.connect (() => {
            var scaling_factor = interface_settings.get_double ("text-scaling-factor");
            interface_settings.set_double ("text-scaling-factor", scaling_factor + 0.25);
        });

        zoom_out_button.clicked.connect (() => {
            var scaling_factor = interface_settings.get_double ("text-scaling-factor");
            interface_settings.set_double ("text-scaling-factor", scaling_factor - 0.25);
        });

        var applications_settings = new Settings ("org.gnome.desktop.a11y.applications");
        applications_settings.bind ("screen-keyboard-enabled", onscreen_keyboard, "active", SettingsBindFlags.DEFAULT);
        applications_settings.bind ("screen-reader-enabled", screen_reader, "active", SettingsBindFlags.DEFAULT);

        interface_settings = new Settings ("org.gnome.desktop.interface");
        interface_settings.changed["text-scaling-factor"].connect (update_zoom_buttons);

        var keyboard_settings = new Settings ("org.gnome.desktop.a11y.keyboard");
        keyboard_settings.bind ("bouncekeys-enable", bounce_keys, "active", SettingsBindFlags.DEFAULT);
        keyboard_settings.bind ("slowkeys-enable", slow_keys, "active", SettingsBindFlags.DEFAULT);
        keyboard_settings.bind ("stickykeys-enable", sticky_keys, "active", SettingsBindFlags.DEFAULT);
    }

    private void update_zoom_buttons () {
        var scaling_factor = interface_settings.get_double ("text-scaling-factor");
        zoom_in_button.sensitive = scaling_factor < 1.5;
        zoom_out_button.sensitive = scaling_factor > 0.75;
        zoom_default_button.label = "%.0f%%".printf (scaling_factor * 100);
    }
}

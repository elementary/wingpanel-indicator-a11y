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
    construct {
        var screen_reader = new Wingpanel.Widgets.Switch (_("Screen Reader"));

        var onscreen_keyboard = new Wingpanel.Widgets.Switch (_("Onscreen Keyboard"));

        var slow_keys = new Wingpanel.Widgets.Switch (_("Slow Keys"));

        var bounce_keys = new Wingpanel.Widgets.Switch (_("Bounce Keys"));

        var sticky_keys = new Wingpanel.Widgets.Switch (_("Sticky Keys"));

        var settings_button = new Gtk.ModelButton ();
        settings_button.text = _("Universal Access Settings…");

        orientation = Gtk.Orientation.VERTICAL;
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

        var applications_settings = new Settings ("org.gnome.desktop.a11y.applications");
        applications_settings.bind ("screen-keyboard-enabled", onscreen_keyboard, "active", SettingsBindFlags.DEFAULT);
        applications_settings.bind ("screen-reader-enabled", screen_reader, "active", SettingsBindFlags.DEFAULT);

        var keyboard_settings = new Settings ("org.gnome.desktop.a11y.keyboard");
        keyboard_settings.bind ("bouncekeys-enable", bounce_keys, "active", SettingsBindFlags.DEFAULT);
        keyboard_settings.bind ("slowkeys-enable", slow_keys, "active", SettingsBindFlags.DEFAULT);
        keyboard_settings.bind ("stickykeys-enable", sticky_keys, "active", SettingsBindFlags.DEFAULT);
    }
}

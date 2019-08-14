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
    private A11Y.ApplicationsSettings applications_settings;
    private A11Y.KeyboardSettings keyboard_settings;

    public SessionWidget () {
        applications_settings = new A11Y.ApplicationsSettings ();
        keyboard_settings = new A11Y.KeyboardSettings ();

        int position = 0;
        var screen_reader = new Wingpanel.Widgets.Switch (_("Screen Reader"), applications_settings.screen_reader_enabled);
        applications_settings.schema.bind ("screen-reader-enabled", screen_reader, "active", SettingsBindFlags.DEFAULT);
        attach (screen_reader, 0, position++, 1, 1);

        var onscreen_keyboard = new Wingpanel.Widgets.Switch (_("Onscreen Keyboard"), applications_settings.screen_keyboard_enabled);
        applications_settings.schema.bind ("screen-keyboard-enabled", onscreen_keyboard, "active", SettingsBindFlags.DEFAULT);
        attach (onscreen_keyboard, 0, position++, 1, 1);

        var slow_keys = new Wingpanel.Widgets.Switch (_("Slow Keys"), keyboard_settings.slowkeys_enable);
        keyboard_settings.schema.bind ("slowkeys-enable", slow_keys, "active", SettingsBindFlags.DEFAULT);
        attach (slow_keys, 0, position++, 1, 1);

        var bounce_keys = new Wingpanel.Widgets.Switch (_("Bounce Keys"), keyboard_settings.bouncekeys_enable);
        keyboard_settings.schema.bind ("bouncekeys-enable", bounce_keys, "active", SettingsBindFlags.DEFAULT);
        attach (bounce_keys, 0, position++, 1, 1);

        var sticky_keys = new Wingpanel.Widgets.Switch (_("Sticky Keys"), keyboard_settings.stickykeys_enable);
        keyboard_settings.schema.bind ("stickykeys-enable", sticky_keys, "active", SettingsBindFlags.DEFAULT);
        attach (sticky_keys, 0, position++, 1, 1);

        attach (new Wingpanel.Widgets.Separator (), 0, position++, 1, 1);

        var settings_button = new Gtk.ModelButton ();
        settings_button.text = _("Universal Access Settings…");
        attach (settings_button, 0, position++, 1, 1);

        settings_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("settings://universal-access", null);
                } catch (Error e) {
                    warning ("Failed to open universal access settings: %s", e.message);
                }
            });
    }
}

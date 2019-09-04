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
    public Wingpanel.IndicatorManager.ServerType server_type { get; construct; }

    private KeyFile settings;
    private Gtk.Window keyboard_window;

    private int status;
    private int reader_pid;
    private int keyboard_pid;

    public SessionWidget (Wingpanel.IndicatorManager.ServerType server_type) {
        Object (server_type: server_type);
    }

    construct {
        var screen_reader = new Wingpanel.Widgets.Switch (_("Screen Reader"));

        var onscreen_keyboard = new Wingpanel.Widgets.Switch (_("Onscreen Keyboard"));

        var slow_keys = new Wingpanel.Widgets.Switch (_("Slow Keys"));

        var bounce_keys = new Wingpanel.Widgets.Switch (_("Bounce Keys"));

        var sticky_keys = new Wingpanel.Widgets.Switch (_("Sticky Keys"));

        orientation = Gtk.Orientation.VERTICAL;
        add (screen_reader);
        add (onscreen_keyboard);
        add (new Wingpanel.Widgets.Separator ());
        add (slow_keys);
        add (bounce_keys);
        add (sticky_keys);

        if (server_type == Wingpanel.IndicatorManager.ServerType.SESSION) {
            var settings_button = new Gtk.ModelButton ();
            settings_button.text = _("Universal Access Settings…");

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
        } else {
            settings = new KeyFile ();
            settings.set_boolean ("greeter", "onscreen-keyboard", false);

            screen_reader.notify["active"].connect (() => {
                toggle_screen_reader (screen_reader.active);
            });

            onscreen_keyboard.notify["active"].connect (() => {
                toggle_keyboard (onscreen_keyboard.active);
            });

            try {
                onscreen_keyboard.active = settings.get_boolean ("greeter", "onscreen-keyboard");
            } catch (Error e) {
                warning (e.message);
            }
        }

        var keyboard_settings = new Settings ("org.gnome.desktop.a11y.keyboard");
        keyboard_settings.bind ("bouncekeys-enable", bounce_keys, "active", SettingsBindFlags.DEFAULT);
        keyboard_settings.bind ("slowkeys-enable", slow_keys, "active", SettingsBindFlags.DEFAULT);
        keyboard_settings.bind ("stickykeys-enable", sticky_keys, "active", SettingsBindFlags.DEFAULT);
    }

    ~SessionWidget () {
        if (keyboard_pid != 0) {
            Posix.kill (keyboard_pid, Posix.Signal.KILL);
            Posix.waitpid (keyboard_pid, out status, 0);
            keyboard_pid = 0;
        }

        if (reader_pid != 0) {
            Posix.kill (reader_pid, Posix.Signal.KILL);
            Posix.waitpid (reader_pid, out status, 0);
            reader_pid = 0;
        }
    }

    private void toggle_screen_reader (bool active) {
        if (active) {
            try {
                string[] argv;
                Shell.parse_argv ("orca --replace", out argv);
                Process.spawn_async (null, argv, null, SpawnFlags.SEARCH_PATH, null, out reader_pid);
            } catch (Error e) {
                warning (e.message);
            }
        } else {
            Posix.kill (reader_pid, Posix.Signal.KILL);
            Posix.waitpid (reader_pid, out status, 0);
            reader_pid = 0;
        }
    }

    private void toggle_keyboard (bool active) {
        if (keyboard_window != null) {
            keyboard_window.visible = active;
            settings.set_boolean ("greeter", "onscreen-keyboard", active);

            return;
        }

        int id = 0;
        int onboard_stdout_fd;

        try {
            string[] argv;
            Shell.parse_argv ("onboard --xid", out argv);
            Process.spawn_async_with_pipes (null, argv, null, SpawnFlags.SEARCH_PATH, null, out keyboard_pid, null, out onboard_stdout_fd, null);

            var f = FileStream.fdopen (onboard_stdout_fd, "r");
            var stdout_text = new char[1024];
            f.gets (stdout_text);
            id = int.parse ((string)stdout_text);
        } catch (Error e) {
            warning (e.message);
        }

        var keyboard_socket = new Gtk.Socket ();
        keyboard_window = new Gtk.Window ();
        keyboard_window.type_hint = Gdk.WindowTypeHint.DOCK;
        keyboard_window.accept_focus = false;
        keyboard_window.focus_on_map = false;
        keyboard_window.add (keyboard_socket);
        keyboard_socket.add_id (id);

        var display = Gdk.Display.get_default ();
        var monitor = display.get_primary_monitor ();
        int keyboard_width, keyboard_height;
        Gdk.Rectangle geom = monitor.get_geometry ();

        keyboard_window.resize (geom.width / 2, geom.height / 4);
        keyboard_window.get_size (out keyboard_width, out keyboard_height);
        keyboard_window.move (geom.x + keyboard_width / 2, geom.y + (geom.height - keyboard_height));
        keyboard_window.set_keep_above (true);

        keyboard_window.show_all ();
        settings.set_boolean ("greeter", "onscreen-keyboard", true);
    }
}

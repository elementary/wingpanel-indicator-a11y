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

public class A11Y.GreeterWidget : Gtk.Grid {
    private KeyFile settings;
    private Gtk.Window keyboard_window;
    private int keyboard_pid;

    public GreeterWidget () {
        settings = new KeyFile ();

        settings.set_boolean ("greeter", "onscreen-keyboard", false);

        int position = 0;
        var screen_reader = new Wingpanel.Widgets.Switch (_("Screen Reader"), false);
        screen_reader.switched.connect (() => {
            toggle_screen_reader (screen_reader.active);
        });
        attach (screen_reader, 0, position++, 1, 1);

        var onscreen_keyboard = new Wingpanel.Widgets.Switch (_("Onscreen Keyboard"), false);
        onscreen_keyboard.switched.connect (() => {
            toggle_keyboard (onscreen_keyboard.active);
        });
        attach (onscreen_keyboard, 0, position++, 1, 1);
        try {
            onscreen_keyboard.active = settings.get_boolean ("greeter", "onscreen-keyboard");
        } catch (Error e) {
            warning (e.message);
        }
    }

    ~GreeterWidget () {
        if (keyboard_pid != 0) {
            Posix.kill (keyboard_pid, Posix.Signal.KILL);
            int status;
            Posix.waitpid (keyboard_pid, out status, 0);
            keyboard_pid = 0;
        }
    }

    private void toggle_screen_reader (bool active) {

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

        var screen = Gdk.Screen.get_default ();
        var monitor = screen.get_primary_monitor ();
        int keyboard_width, keyboard_height;
        Gdk.Rectangle geom;

        screen.get_monitor_geometry (monitor, out geom);
        keyboard_window.resize (geom.width / 2, geom.height / 4);
        keyboard_window.get_size (out keyboard_width, out keyboard_height);
        keyboard_window.move (geom.x + keyboard_width / 2, geom.y + (geom.height - keyboard_height));
        keyboard_window.set_keep_above (true);

        keyboard_window.show_all ();
        settings.set_boolean ("greeter", "onscreen-keyboard", true);
    }
}

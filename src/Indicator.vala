/*
 * Copyright (c) 2011-2015 Wingpanel Developers (http://launchpad.net/wingpanel)
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
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

public class A11Y.Indicator : Wingpanel.Indicator {
    Wingpanel.Widgets.OverlayIcon panel_icon;
    Gtk.Grid main_grid;

    KeyFile settings;
    Gtk.Window keyboard_window;
    int keyboard_pid;

    public Indicator () {
        Object (code_name: "a11y",
                display_name: _("Accessibility"),
                description: _("Accessibility indicator"));

        this.visible = true;
        settings = new KeyFile ();

        /*
         * we could load /etc/lightdm/pantheon-greeter.conf but all keys are commented there.
         * setting defaults instead to prevent needless warnings
         */
        settings.set_boolean ("greeter", "high-contrast", false);
        settings.set_boolean ("greeter", "onscreen-keyboard", false);
        /*
         * try {
         *     settings.load_from_file ("/etc/lightdm/pantheon-greeter.conf",
         *                              KeyFileFlags.KEEP_COMMENTS);
         * } catch (Error e) {
         *     warning (e.message);
         * }
         */
    }

    ~Indicator () {
        if (keyboard_pid != 0) {
            Posix.kill (keyboard_pid, Posix.SIGKILL);
            int status;
            Posix.waitpid (keyboard_pid, out status, 0);
            keyboard_pid = 0;
        }
    }

    public override Gtk.Widget get_display_widget () {
        if (panel_icon == null) {
            panel_icon = new Wingpanel.Widgets.OverlayIcon ("preferences-desktop-accessibility-symbolic");
        }

        return panel_icon;
    }

    public override Gtk.Widget? get_widget () {
        if (main_grid == null) {
            int position = 0;
            main_grid = new Gtk.Grid ();

            var onscreen_keyboard = new Wingpanel.Widgets.Switch (_("Onscreen Keyboard"), false);
            onscreen_keyboard.switched.connect (() => {
                toggle_keyboard (onscreen_keyboard.get_active ());
            });
            main_grid.attach (onscreen_keyboard, 0, position++, 1, 1);
            try {
                onscreen_keyboard.set_active (settings.get_boolean ("greeter", "onscreen-keyboard"));
            } catch (Error e) {
                warning (e.message);
            }

            var high_contrast = new Wingpanel.Widgets.Switch (_("HighContrast"), false);
            high_contrast.switched.connect (() => {
                Gtk.Settings.get_default ().gtk_theme_name = high_contrast.get_active () ? "HighContrastInverse" : "elementary";
                settings.set_boolean ("greeter", "high-contrast", high_contrast.get_active ());
            });
            main_grid.attach (high_contrast, 0, position++, 1, 1);
            try {
                high_contrast.set_active (settings.get_boolean ("greeter", "high-contrast"));
            } catch (Error e) {
                warning (e.message);
            }
        }

        return main_grid;
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
        keyboard_window.accept_focus = false;
        keyboard_window.focus_on_map = false;
        keyboard_window.add (keyboard_socket);
        keyboard_socket.add_id (id);

        var screen = Gdk.Screen.get_default ();
        var monitor = screen.get_primary_monitor ();
        Gdk.Rectangle geom;
        screen.get_monitor_geometry (monitor, out geom);
        keyboard_window.move (geom.x, geom.y + geom.height - 200);
        keyboard_window.resize (geom.width, 200);
        keyboard_window.set_keep_above (true);

        keyboard_window.show_all ();
        settings.set_boolean ("greeter", "onscreen-keyboard", true);
    }

    public override void opened () {
    }

    public override void closed () {
    }
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("Activating Accessibility Indicator");

    /* Only show a11y in greeter */
    if (server_type == Wingpanel.IndicatorManager.ServerType.GREETER) {
        return new A11Y.Indicator ();
    }

    return null;
}
namespace PhpTester {
public class Preferences : Gtk.Dialog {

    private Settings settings = new Settings ("com.github.bartzaalberg.php-tester");
    SourceViewManager source_view_manager = SourceViewManager.get_instance ();
    private Gtk.ComboBoxText style_scheme;

    public Preferences () {
        title = _("Preferences");
        set_default_size (630, 430);
        resizable = false;
        deletable = false;

        var general_header = new HeaderLabel (_("Preferences"));

        style_scheme = new Gtk.ComboBoxText ();
        populate_style_scheme ();
        settings.bind ("style-scheme", style_scheme, "active-id", SettingsBindFlags.DEFAULT);

        var use_custom_font_label = new Gtk.Label (_("Custom font:"));
        var use_custom_font = new Gtk.Switch ();
            use_custom_font.halign = Gtk.Align.START;
            settings.bind ("use-system-font", use_custom_font, "active", SettingsBindFlags.INVERT_BOOLEAN);

        var select_font = new Gtk.FontButton ();
            select_font.hexpand = true;
            settings.bind ("font", select_font, "font-name", SettingsBindFlags.DEFAULT);
            settings.bind ("use-system-font", select_font, "sensitive", SettingsBindFlags.INVERT_BOOLEAN);

        var theme_label = new Gtk.Label (_("Theme:"));

        var php_path_label = new Gtk.Label (_("PHP path:"));
        var php_path_entry = new Gtk.Entry ();
        php_path_entry.set_text (settings.get_string ("php-path"));
        php_path_entry.set_tooltip_text (_("This path will be used to find php"));

        var restartNoteLabel = new Gtk.Label (_("You need to restart after changing the PHP path"));

        var close_button = new Gtk.Button.with_label (_("Close"));
        close_button.margin_right = 6;
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        var save_button = new Gtk.Button.with_label (_("Save"));
        save_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        save_button.clicked.connect (() => {
            settings.set_string ("style-scheme", style_scheme.get_active_id ());
            source_view_manager.set_theme (settings.get_string ("style-scheme"));
            source_view_manager.set_font (settings.get_string ("font"));

            if (php_path_entry.text == "") {
                settings.set_string ("php-path", "/usr/bin");
            } else {
                settings.set_string ("php-path", php_path_entry.text);
            }

            this.destroy ();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (close_button);
        button_box.pack_end (save_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        var general_grid = new Gtk.Grid ();
        general_grid.row_spacing = 6;
        general_grid.column_spacing = 12;
        general_grid.margin = 12;
        general_grid.attach (general_header, 0, 0, 2, 1);

        general_grid.attach (theme_label, 0, 1, 1, 1);
        general_grid.attach (style_scheme, 1, 1, 2, 1);
        general_grid.attach (use_custom_font_label, 0, 2, 1, 1);
        general_grid.attach (use_custom_font, 1, 2, 1, 1);
        general_grid.attach (select_font, 2, 2, 1, 1);
        general_grid.attach (php_path_label, 0, 3, 1, 1);
        general_grid.attach (php_path_entry, 1, 3, 1, 1);
        general_grid.attach (restartNoteLabel, 1, 4, 1, 1);

        var main_grid = new Gtk.Grid ();
        main_grid.attach (general_grid, 0, 0, 1, 1);
        main_grid.attach (button_box, 0, 1, 1, 1);

        ((Gtk.Container) get_content_area ()).add (main_grid);
        this.show_all ();
    }

    private void populate_style_scheme () {
        string[] scheme_ids;
        var scheme_manager = new Gtk.SourceStyleSchemeManager ();
        scheme_ids = scheme_manager.get_scheme_ids ();

        foreach (string scheme_id in scheme_ids) {
            var scheme = scheme_manager.get_scheme (scheme_id);
            style_scheme.append (scheme.id, scheme.name);
        }
    }
}
}

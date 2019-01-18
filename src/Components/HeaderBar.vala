using Granite.Widgets;

namespace PhpTester {
public class HeaderBar : Gtk.HeaderBar {

    static HeaderBar? instance;

    private Settings settings = new Settings ("com.github.bartzaalberg.php-tester");
    private SourceViewManager source_view_manager = SourceViewManager.get_instance ();
    private FileManager file_manager = FileManager.get_instance ();
    private PhpVersionManager php_version_manager = PhpVersionManager.get_instance ();

    Gtk.Clipboard clipboard = Gtk.Clipboard.get (Gdk.SELECTION_CLIPBOARD);
    Gtk.Button start_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
    Gtk.MenuButton copy_menu_button = new Gtk.MenuButton ();
    Gtk.Menu copy_menu = new Gtk.Menu ();
    Gtk.MenuButton menu_button = new Gtk.MenuButton ();
    Gtk.Menu settings_menu = new Gtk.Menu ();
    Gtk.ComboBox combo_box = new Gtk.ComboBox ();

    enum Column {
        VERSION
    }

    HeaderBar () {
        Utils.set_color_primary (this, Constants.BRAND_COLOR);

        generate_versions_dropdown ();

        if (settings.get_string ("php-version") == "" && php_version_manager.get_versions ().length != 0) {
            settings.set_string ("php-version", php_version_manager.get_versions ()[0]);
        }

        get_active_dropdown_index_and_set ();
        generate_start_button ();
        generate_copy_menu ();
        generate_settings_menu ();

        this.add (combo_box);
        this.pack_start (start_button);
        this.pack_start (copy_menu_button);
        this.pack_end (menu_button);
        this.show_close_button = true;
    }

    public static HeaderBar get_instance () {
        if (instance == null) {
            instance = new HeaderBar ();
        }
        return instance;
    }

    public void disable_all_buttons_except_options () {
        combo_box.set_sensitive (false);
        start_button.set_sensitive (false);
        copy_menu_button.popup = null;
    }

    private void generate_versions_dropdown () {
        Gtk.ListStore liststore = new Gtk.ListStore (1, typeof (string));

        for (int i = 0; i < php_version_manager.get_versions ().length; i++) {
            Gtk.TreeIter iter;
            liststore.append (out iter);
            liststore.set (iter, Column.VERSION, php_version_manager.get_versions ()[i]);
        }

        Gtk.CellRendererText cell = new Gtk.CellRendererText ();

        combo_box.set_model (liststore);
        combo_box.pack_start (cell, false);
        combo_box.set_attributes (cell, "text", Column.VERSION);
        combo_box.set_active (0);
        combo_box.changed.connect (this.item_changed);
    }

    void item_changed (Gtk.ComboBox combo) {
        settings.set_string ("php-version", php_version_manager.get_versions () [combo.get_active ()]);
    }

    private void get_active_dropdown_index_and_set () {
        for (int i = 0; i < php_version_manager.get_versions ().length; i++) {
            if (php_version_manager.get_versions ()[i] == settings.get_string ("php-version")) {
                combo_box.set_active (i);
            }
        }
    }

    private void generate_start_button () {
        start_button.set_tooltip_text (_("Run the code"));
        start_button.clicked.connect (() => {
            file_manager.run_code ();
        });
    }

    private void generate_copy_menu () {
        copy_menu_button.has_tooltip = true;
        copy_menu_button.tooltip_text = (_("Copy input or output"));
        copy_menu_button.set_image (new Gtk.Image.from_icon_name ("edit-copy-symbolic", Gtk.IconSize.SMALL_TOOLBAR));

         var copy_input = new Gtk.MenuItem.with_label (_("Copy Input"));
        copy_input.activate.connect (() => {
            clipboard.set_text (source_view_manager.get_view ().buffer.text, -1);
        });

        var copy_output = new Gtk.MenuItem.with_label (_("Copy Output"));
        copy_output.activate.connect (() => {
            clipboard.set_text (source_view_manager.get_result ().buffer.text, -1);
        });

        copy_menu.add (copy_input);
        copy_menu.add (new Gtk.SeparatorMenuItem ());
        copy_menu.add (copy_output);
        copy_menu.show_all ();

        copy_menu_button.popup = copy_menu;
    }

    private void generate_settings_menu () {
        menu_button.has_tooltip = true;
        menu_button.tooltip_text = (_("Settings"));
        menu_button.set_image (new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR));

        var cheatsheet = new Gtk.MenuItem.with_label (_("Markdown Cheatsheet"));
        cheatsheet.activate.connect (() => {
            new Cheatsheet ();
        });

        var preferences = new Gtk.MenuItem.with_label (_("Preferences"));
        preferences.activate.connect (() => {
            new Preferences ();
        });

        settings_menu.add (cheatsheet);
        settings_menu.add (new Gtk.SeparatorMenuItem ());
        settings_menu.add (preferences);
        settings_menu.show_all ();

        menu_button.popup = settings_menu;
    }
}
}

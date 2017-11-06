using Granite.Widgets;

namespace PhpTester {
public class HeaderBar : Gtk.HeaderBar {

    private Settings settings = new Settings ("com.github.bartzaalberg.php-tester");
    SourceViewManager sourceViewManager = SourceViewManager.get_instance();
    FileManager fileManager = FileManager.get_instance();
    Gtk.Clipboard clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD);

    string[] phpVersions = {};

    enum Column {
		VERSION
	}

	void item_changed (Gtk.ComboBox combo) {
        settings.set_string("php-version", phpVersions [combo.get_active ()]);
	}

    construct {

        try {
            string directory = "/usr/bin";
            Dir dir = Dir.open (directory, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (directory, name);
                string type = "";

                if (!(FileUtils.test (path, FileTest.IS_EXECUTABLE))) {
                    continue;
                }

                if(!("php" in name)) {
                    continue;
                }

                if((name.substring (0, 3) != "php")){
                    continue;                    
                }

                string shortString = name.substring (-3);
                int number = int.parse(shortString);

                if(number == 0){
                    continue;
                }
                phpVersions += name;
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }

        if(phpVersions.length == 0){
            new Alert("No PHP was found.","This application requires at least 1 PHP version installed in your /usr/bin folder. Please install it.");
        }

        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);


        Gtk.ListStore liststore = new Gtk.ListStore (1, typeof (string));

		for (int i = 0; i < phpVersions.length; i++){
			Gtk.TreeIter iter;
			liststore.append (out iter);
			liststore.set (iter, Column.VERSION, phpVersions[i]);
		}


        Gtk.ComboBox combobox = new Gtk.ComboBox.with_model (liststore);
		Gtk.CellRendererText cell = new Gtk.CellRendererText ();
		combobox.pack_start (cell, false);

		combobox.set_attributes (cell, "text", Column.VERSION);

		/* Set the first item in the list to be selected (active). */
		combobox.set_active (0);

		/* Connect the 'changed' signal of the combobox
		 * to the signal handler (aka. callback function).
		 */
		combobox.changed.connect (this.item_changed);

		/* Add the combobox to this window */
		this.add (combobox);

        var start_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
        start_button.set_tooltip_text("Run the code");
        start_button.clicked.connect (() => {
            fileManager.runCode();
        });

        var copy_menu_button = new Gtk.MenuButton ();
        copy_menu_button.has_tooltip = true;
        copy_menu_button.tooltip_text = ("Copy input or output");
        copy_menu_button.set_image (new Gtk.Image.from_icon_name ("edit-copy-symbolic", Gtk.IconSize.SMALL_TOOLBAR));

        var copy_input = new Gtk.MenuItem.with_label ("Copy Input");
        copy_input.activate.connect (() => {
            clipboard.set_text(sourceViewManager.getView().buffer.text, -1);
        });

        var copy_output = new Gtk.MenuItem.with_label ("Copy Output");
        copy_output.activate.connect (() => {
            clipboard.set_text(sourceViewManager.getResult().buffer.text, -1);
        });

        var copy_menu = new Gtk.Menu ();
        copy_menu.add (copy_input);
        copy_menu.add (new Gtk.SeparatorMenuItem ());
        copy_menu.add (copy_output);
        copy_menu.show_all ();

        copy_menu_button.popup = copy_menu;

        var menu_button = new Gtk.MenuButton ();
        menu_button.has_tooltip = true;
        menu_button.tooltip_text = ("Settings");
        menu_button.set_image (new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR));

        var cheatsheet = new Gtk.MenuItem.with_label ("Markdown Cheatsheet");
        cheatsheet.activate.connect (() => {
            new Cheatsheet();
        });

        var preferences = new Gtk.MenuItem.with_label ("Preferences");
        preferences.activate.connect (() => {
            new Preferences();
        });

        var settings_menu = new Gtk.Menu ();
        settings_menu.add (cheatsheet);
        settings_menu.add (new Gtk.SeparatorMenuItem ());
        settings_menu.add (preferences);
        settings_menu.show_all ();

        menu_button.popup = settings_menu;

        this.pack_start (start_button);
        this.pack_start (copy_menu_button);
        this.pack_end (menu_button);
        this.show_close_button = true;
    }
}
}

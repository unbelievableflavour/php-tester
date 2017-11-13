using Granite.Widgets;

namespace PhpTester {
public class HeaderBar : Gtk.HeaderBar {

    static HeaderBar? instance;

    private Settings settings = new Settings ("com.github.bartzaalberg.php-tester");
    private SourceViewManager sourceViewManager = SourceViewManager.get_instance();
    private FileManager fileManager = FileManager.get_instance();
    private PhpVersionManager phpVersionManager = PhpVersionManager.get_instance();

    Gtk.Clipboard clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD);
    Gtk.Button start_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
    Gtk.MenuButton copy_menu_button = new Gtk.MenuButton ();
    Gtk.Menu copy_menu = new Gtk.Menu ();
    Gtk.MenuButton menu_button = new Gtk.MenuButton ();
    Gtk.Menu settings_menu = new Gtk.Menu ();
    Gtk.ComboBox combobox = new Gtk.ComboBox();

    enum Column {
		VERSION
	}

    HeaderBar() {
        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);

        generateVersionsDropdown();
        
        if(settings.get_string("php-version") == ""){
            settings.set_string("php-version", phpVersionManager.getVersions()[0]);
        }

        getActiveDropdownIndexAndSet();
        generateStartButton();
        generateCopyMenu();
        generateSettingsMenu();

		this.add (combobox);
        this.pack_start (start_button);
        this.pack_start (copy_menu_button);
        this.pack_end (menu_button);
        this.show_close_button = true;
    }

   public static HeaderBar get_instance() {
        if (instance == null) {
            instance = new HeaderBar();
        }
        return instance;
    }

    public void disableAllButtons(){
        combobox.set_sensitive(false);
        start_button.set_sensitive(false);
        copy_menu.set_sensitive(false);
        settings_menu.set_sensitive(false);    
    }

    private void generateVersionsDropdown(){
        Gtk.ListStore liststore = new Gtk.ListStore (1, typeof (string));

		for (int i = 0; i < phpVersionManager.getVersions().length; i++){
			Gtk.TreeIter iter;
			liststore.append (out iter);
			liststore.set (iter, Column.VERSION, phpVersionManager.getVersions()[i]);
		}

		Gtk.CellRendererText cell = new Gtk.CellRendererText ();

        combobox.set_model (liststore);
		combobox.pack_start (cell, false);
		combobox.set_attributes (cell, "text", Column.VERSION);
		combobox.set_active (0);
		combobox.changed.connect (this.item_changed);
    }

    void item_changed (Gtk.ComboBox combo) {
        settings.set_string("php-version", phpVersionManager.getVersions() [combo.get_active ()]);
	}

    private void getActiveDropdownIndexAndSet(){
        for (int i = 0; i < phpVersionManager.getVersions().length; i++){
		    if(phpVersionManager.getVersions()[i] == settings.get_string("php-version")){
                combobox.set_active(i);
            }
	    }
    }

    private void generateStartButton(){
        start_button.set_tooltip_text(_("Run the code"));
        start_button.clicked.connect (() => {
            fileManager.runCode();
        });
    }

    private void generateCopyMenu(){
        copy_menu_button.has_tooltip = true;
        copy_menu_button.tooltip_text = (_("Copy input or output"));
        copy_menu_button.set_image (new Gtk.Image.from_icon_name ("edit-copy-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
        
         var copy_input = new Gtk.MenuItem.with_label (_("Copy Input"));
        copy_input.activate.connect (() => {
            clipboard.set_text(sourceViewManager.getView().buffer.text, -1);
        });

        var copy_output = new Gtk.MenuItem.with_label (_("Copy Output"));
        copy_output.activate.connect (() => {
            clipboard.set_text(sourceViewManager.getResult().buffer.text, -1);
        });

        copy_menu.add (copy_input);
        copy_menu.add (new Gtk.SeparatorMenuItem ());
        copy_menu.add (copy_output);
        copy_menu.show_all ();

        copy_menu_button.popup = copy_menu;
    }

    private void generateSettingsMenu(){
        menu_button.has_tooltip = true;
        menu_button.tooltip_text = (_("Settings"));
        menu_button.set_image (new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR));

        var cheatsheet = new Gtk.MenuItem.with_label (_("Markdown Cheatsheet"));
        cheatsheet.activate.connect (() => {
            new Cheatsheet();
        });

        var preferences = new Gtk.MenuItem.with_label (_("Preferences"));
        preferences.activate.connect (() => {
            new Preferences();
        });

        settings_menu.add (cheatsheet);
        settings_menu.add (new Gtk.SeparatorMenuItem ());
        settings_menu.add (preferences);
        settings_menu.show_all ();

        menu_button.popup = settings_menu;
    }
}
}

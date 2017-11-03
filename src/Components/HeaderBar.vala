using Granite.Widgets;

namespace PhpTester {
public class HeaderBar : Gtk.HeaderBar {

    SourceViewManager sourceViewManager = SourceViewManager.get_instance();
    FileManager fileManager = FileManager.get_instance();
    Gtk.Clipboard clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD);

    construct {

        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);

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

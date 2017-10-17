using Granite.Widgets;

namespace RepositoriesManager {
public class HeaderBar : Gtk.HeaderBar {

    SourceViewManager sourceViewManager = SourceViewManager.get_instance();
    FileManager fileManager = FileManager.get_instance();
    Gtk.Clipboard clipboard;
    
    construct {

        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);

        clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD);

        var start_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
        start_button.set_tooltip_text("Run the code");
        start_button.clicked.connect (() => {
            fileManager.runCode();
        });

        var copy_input_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic");
        copy_input_button.set_tooltip_text("Copy input");
        copy_input_button.clicked.connect (() => {
            clipboard.set_text(sourceViewManager.getView().buffer.text, -1);
        });

        var copy_result_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic");
        copy_result_button.set_tooltip_text("Copy output");
        copy_result_button.clicked.connect (() => {
           clipboard.set_text(sourceViewManager.getResult().get_text(), -1);
        });

        var settings_button = new Gtk.Button.from_icon_name ("document-properties-symbolic");
        settings_button.set_tooltip_text("Open settings");
        settings_button.clicked.connect (() => {
            new Cheatsheet();
        });

        this.show_close_button = true;

        this.pack_start (start_button);
        this.pack_start (copy_input_button);
        this.pack_start (copy_result_button);
        this.pack_end (settings_button);
    }
}
}

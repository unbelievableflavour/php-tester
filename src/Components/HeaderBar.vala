using Granite.Widgets;

namespace RepositoriesManager {
public class HeaderBar : Gtk.HeaderBar {

    SourceViewManager sourceViewManager = SourceViewManager.get_instance();
    FileManager fileManager = FileManager.get_instance();
    Gtk.Clipboard clipboard;
    
    public HeaderBar(){
        
        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);

        clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD);

        var start_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
        start_button.clicked.connect (() => {
            fileManager.runCode();
        });

        var copy_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic");
        copy_button.clicked.connect (() => {
            clipboard.set_text(sourceViewManager.getView().buffer.text, -1);
        });

        var settings_button = new Gtk.Button.from_icon_name ("document-properties-symbolic");
        settings_button.clicked.connect (() => {
            new Cheatsheet();
        });

        this.show_close_button = true;

        this.pack_start (start_button);
        this.pack_start (copy_button);
        this.pack_end (settings_button);
    }
}
}

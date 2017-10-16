using Granite.Widgets;

namespace RepositoriesManager {
public class HeaderBar : Gtk.HeaderBar {

    SourceViewManager sourceViewManager = SourceViewManager.get_instance();
    FileManager fileManager = FileManager.get_instance();
    Gtk.Clipboard clipboard;
    
    public HeaderBar(){
        clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD);

        var start_button = new Gtk.Button.with_label ("Run");
        start_button.margin_end = 12;
        start_button.clicked.connect (() => {
            fileManager.runCode();
        });

        var copy_button = new Gtk.Button.with_label ("Copy");
        
        copy_button.margin_end = 12;
        copy_button.clicked.connect (() => {
            clipboard.set_text(sourceViewManager.getView().buffer.text, -1);
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.START);
        button_box.pack_start (start_button);
        button_box.pack_start (copy_button);

        this.show_close_button = true;

        this.pack_start (button_box);
    }
}
}

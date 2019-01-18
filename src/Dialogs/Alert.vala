using Granite;

namespace PhpTester {
public class Alert : Object {

    public Alert (string title, string description) {
        var message_dialog = new MessageDialog.with_image_from_icon_name (title, description, "dialog-warning");
        message_dialog.window_position = Gtk.WindowPosition.CENTER_ON_PARENT;
        message_dialog.show_all ();

        if (message_dialog.run () == Gtk.ResponseType.CLOSE) {
            message_dialog.destroy ();
        }
    }
}
}
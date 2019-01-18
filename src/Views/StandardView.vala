using Granite.Widgets;

namespace PhpTester {
public class StandardView : Gtk.ScrolledWindow {

    private SourceViewManager source_view_manager = SourceViewManager.get_instance ();
    private FileManager file_manager = FileManager.get_instance ();

    public StandardView () {
        var view = source_view_manager.get_view ();
        view.set_wrap_mode (Gtk.WrapMode.CHAR);
        view.buffer.text = file_manager.get_code_test_file_as_string ();

        Gtk.ScrolledWindow view_box = new Gtk.ScrolledWindow (null, null);
        view_box.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        view_box.set_size_request (200,200);
        view_box.add (view);

        Gtk.ScrolledWindow result_box = new Gtk.ScrolledWindow (null, null);
        result_box.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        result_box.set_size_request (200,200);
        result_box.add (source_view_manager.get_result ());

        var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        pane.expand = true;
        pane.pack1 (view_box, false, false);
        pane.pack2 (result_box, false, false);

        add (pane);
    }
}
}

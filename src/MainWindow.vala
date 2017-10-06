using Granite.Widgets;

namespace RepositoriesManager {
public class MainWindow : Gtk.Window{

    private ListManager listManager = ListManager.get_instance();
   
    Gtk.TextView view;
    Gtk.Label resultLabel;    

    construct {
        set_default_size(700, 500);
        set_titlebar (new HeaderBar());

        view = listManager.getView();
		view.buffer.text = "<?php\n";

        Gtk.ScrolledWindow result_box = new Gtk.ScrolledWindow(null, null);
        result_box.set_border_width (10);
        result_box.set_size_request (200,200);

        resultLabel = listManager.getResult();
        
        result_box.add(resultLabel);
        
        var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            pane.expand = true;
            pane.pack1 (view, true, false);
            pane.pack2 (result_box, false, false);

        add (pane);
    }
}
}

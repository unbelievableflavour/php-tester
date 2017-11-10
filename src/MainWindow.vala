using Granite.Widgets;

namespace PhpTester {
public class MainWindow : Gtk.Window{

    private SourceViewManager sourceViewManager = SourceViewManager.get_instance();
    private FileManager fileManager = FileManager.get_instance();
    private Gtk.Clipboard clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD);

    construct {
        set_default_size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT);
        set_titlebar (new HeaderBar());

        var view = sourceViewManager.getView();
		view.buffer.text = fileManager.getCodeTestFileAsString();

        Gtk.ScrolledWindow view_box = new Gtk.ScrolledWindow(null, null);
        view_box.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        view_box.set_size_request (200,200);
        view_box.add(view);

        Gtk.ScrolledWindow result_box = new Gtk.ScrolledWindow(null, null);
        result_box.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
        result_box.set_size_request (200,200);
        result_box.add(sourceViewManager.getResult());
        
        var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
            pane.expand = true;
            pane.pack1 (view_box, true, false);
            pane.pack2 (result_box, false, false);

        add (pane);
        addShortcuts();
    }

    private void addShortcuts(){
        key_press_event.connect ((e) => { 
            switch (e.keyval) { 
                case Gdk.Key.r:    
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {  
                    fileManager.runCode(); 
                  } 
                  break;
                case Gdk.Key.h:    
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {  
                    new Cheatsheet(); 
                  } 
                  break;
                case Gdk.Key.i:    
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {  
                    clipboard.set_text(sourceViewManager.getView().buffer.text, -1);
                  } 
                  break; 
                case Gdk.Key.o:    
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {  
                    clipboard.set_text(sourceViewManager.getResult().buffer.text, -1);
                  } 
                  break; 
            } 
 
            return false; 
        });            
    }
}
}

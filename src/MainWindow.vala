using Granite.Widgets;

namespace PhpTester {
public class MainWindow : Gtk.Window{

    private SourceViewManager sourceViewManager = SourceViewManager.get_instance();
    private FileManager fileManager = FileManager.get_instance();
    private Gtk.Clipboard clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD);
    private StackManager stackManager = StackManager.get_instance();

    construct {
        set_default_size(Constants.APPLICATION_WIDTH, Constants.APPLICATION_HEIGHT);

        stackManager.loadViews(this);

        set_titlebar (new HeaderBar());

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

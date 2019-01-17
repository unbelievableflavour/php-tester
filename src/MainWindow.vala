using Granite.Widgets;

namespace PhpTester {
public class MainWindow : Gtk.Window{

    private SourceViewManager sourceViewManager = SourceViewManager.get_instance();
    private FileManager fileManager = FileManager.get_instance();
    private Gtk.Clipboard clipboard = Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD);
    private StackManager stackManager = StackManager.get_instance();
    private HeaderBar headerBar = HeaderBar.get_instance();
    private PhpVersionManager phpVersionManager = PhpVersionManager.get_instance();

    public MainWindow (Gtk.Application application) {
        Object (application: application,
                resizable: true,
                height_request: Constants.APPLICATION_HEIGHT,
                width_request: Constants.APPLICATION_WIDTH);
    }

    construct {
        stackManager.loadViews(this);

        set_titlebar(headerBar);

        if(phpVersionManager.noVersionsFound()){
            stackManager.getStack().visible_child_name = "no-php-found-view";
        }

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
                case Gdk.Key.q:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    this.destroy();
                  }
                  break;
            }

            return false;
        });
    }
}
}

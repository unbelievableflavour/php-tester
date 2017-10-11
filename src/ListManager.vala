namespace RepositoriesManager {
public class ListManager : Object {
    
    static ListManager? instance;

    Gtk.SourceView view;
    Gtk.Label result;

    // Private constructor
    ListManager() {
        view = new Gtk.SourceView ();
        view.set_show_line_numbers (true);
        view.set_left_margin (10);
        result = new Gtk.Label("Result will show up here");
    }
 
    // Public constructor
    public static ListManager get_instance() {
        if (instance == null) {
            instance = new ListManager();
        }
        return instance;
    }

    public Gtk.SourceView getView() {
        return this.view;
    }
    
    public void setView(Gtk.SourceView newView) {
        this.view = newView;
    }

     public Gtk.Label getResult() {
        return this.result;
    }

    public void setResult(string result){
        this.result.set_text(result);
    }
}
}

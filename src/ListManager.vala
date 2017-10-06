namespace RepositoriesManager {
public class ListManager : Object {
    
    static ListManager? instance;

    Gtk.TextView view;
    Gtk.Label result;

    // Private constructor
    ListManager() {
        view = new Gtk.TextView();
        result = new Gtk.Label("Result will show up here");
    }
 
    // Public constructor
    public static ListManager get_instance() {
        if (instance == null) {
            instance = new ListManager();
        }
        return instance;
    }

    public Gtk.TextView getView() {
        return this.view;
    }
    
    public void setView(Gtk.TextView newView) {
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

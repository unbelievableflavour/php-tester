namespace PhpTester {
public class StackManager : Object {
    
    static StackManager? instance;

    private Gtk.Stack stack;
    private const string STANDARD_VIEW_ID = "standard-view";
    private const string NO_PHP_FOUND_VIEW_ID = "no-php-found-view";

    // Private constructor
    StackManager() {
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    }
 
    // Public constructor
    public static StackManager get_instance() {
        if (instance == null) {
            instance = new StackManager();
        }
        return instance;
    }

    public Gtk.Stack getStack() {
        return this.stack;
    }

    public void loadViews(Gtk.Window window){
        stack.add_named (new StandardView(), STANDARD_VIEW_ID);
        stack.add_named (new NoPhpFoundView(), NO_PHP_FOUND_VIEW_ID);

        window.add(stack);
        window.show_all();
   }
}
}

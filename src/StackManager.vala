namespace PhpTester {
public class StackManager : Object {

    static StackManager? instance;

    private Gtk.Stack stack;
    private const string STANDARD_VIEW_ID = "standard-view";
    private const string NO_PHP_FOUND_VIEW_ID = "no-php-found-view";

    StackManager () {
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    }

    public static StackManager get_instance () {
        if (instance == null) {
            instance = new StackManager ();
        }
        return instance;
    }

    public Gtk.Stack get_stack () {
        return this.stack;
    }

    public void load_views (Gtk.Window window) {
        stack.add_named (new StandardView (), STANDARD_VIEW_ID);
        stack.add_named (new NoPhpFoundView (), NO_PHP_FOUND_VIEW_ID);

        stack.notify["visible-child"].connect (() => {
            var header_bar = HeaderBar.get_instance ();

            if (stack.get_visible_child_name () == NO_PHP_FOUND_VIEW_ID) {
                header_bar.disable_all_buttons_except_options ();
            }
        });

        window.add (stack);
        window.show_all ();
    }
}
}

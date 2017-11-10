using Granite.Widgets;

namespace PhpTester {
public class NoPhpFoundView : Gtk.ScrolledWindow {

    public NoPhpFoundView(){ 
        var no_php_found_view = new Welcome("No PHP versions found", "Please install a versions of PHP and try again.");

        this.add(no_php_found_view);
    }
}
}

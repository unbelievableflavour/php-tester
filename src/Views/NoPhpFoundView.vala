using Granite.Widgets;

namespace PhpTester {
public class NoPhpFoundView : Gtk.ScrolledWindow {

    public NoPhpFoundView () {
        var no_php_found_view = new Welcome (
            _("No PHP versions found"),
            _("Please install a versions of PHP and restart the application.")
        );

        this.add (no_php_found_view);
    }
}
}

namespace PhpTester {
public class SourceViewManager : Object {

    static SourceViewManager? instance;

    private Settings settings = new Settings ("com.github.bartzaalberg.php-tester");
    public Gtk.SourceView view;
    public Gtk.SourceBuffer buffer;
    public Gtk.TextView result;

    SourceViewManager () {
        try {
            var file = this.get_code_test_file ();
            var info = file.query_info ("standard::*", FileQueryInfoFlags.NONE, null);
            var mime_type = ContentType.get_mime_type (
                info.get_attribute_as_string (FileAttribute.STANDARD_CONTENT_TYPE)
            );

            buffer = new Gtk.SourceBuffer (null);
            buffer.highlight_syntax = true;

            set_theme (settings.get_string ("style-scheme"));

            var manager = Gtk.SourceLanguageManager.get_default ();
            buffer.language = manager.guess_language (file.get_path (), mime_type);

            view = new Gtk.SourceView ();
            view.set_show_line_numbers (true);
            view.set_left_margin (10);
            view.buffer = buffer;

            set_font (settings.get_string ("font"));

        } catch (Error e) {
            error ("%s", e.message);
        }

        result = new Gtk.TextView ();
        result.set_wrap_mode (Gtk.WrapMode.CHAR);
        result.set_editable (false);
        result.set_left_margin (10);
        result.set_right_margin (10);
        result.set_top_margin (10);
        result.set_bottom_margin (10);
        result.buffer.text = _("Result will show up here");
    }

    public static SourceViewManager get_instance () {
        if (instance == null) {
            instance = new SourceViewManager ();
        }
        return instance;
    }

    public Gtk.SourceView get_view () {
        return this.view;
    }

    public void set_view (Gtk.SourceView new_view) {
        this.view = new_view;
    }

     public Gtk.TextView get_result () {
        return this.result;
    }

    public void set_result (string result) {
        this.result.buffer.text = result;
    }

    public File get_code_test_file () {

        var file = File.new_for_path ("phptest.php");
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                get_code_test_file ();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }
        return file;
    }

    public void set_theme (string theme_name) {
        var style_scheme_manager = new Gtk.SourceStyleSchemeManager ();
        buffer.style_scheme = style_scheme_manager.get_scheme (theme_name);
    }

    public void set_font (string font) {
        if (settings.get_boolean ("use-system-font")) {
            font = "Monospace 9";
        }

        view.override_font (Pango.FontDescription.from_string (font));
    }
}
}

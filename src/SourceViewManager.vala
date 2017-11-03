namespace PhpTester {
public class SourceViewManager : Object {
    
    static SourceViewManager? instance;

    private Settings settings = new Settings ("com.github.bartzaalberg.php-tester");
    public Gtk.SourceView view;
    public Gtk.SourceBuffer buffer;
    public Gtk.TextView result;

    // Private constructor
    SourceViewManager() {   
        try {
            var file = this.getCodeTestFile();
            var info = file.query_info ("standard::*", FileQueryInfoFlags.NONE, null);
            var mime_type = ContentType.get_mime_type (info.get_attribute_as_string (FileAttribute.STANDARD_CONTENT_TYPE));      

            buffer = new Gtk.SourceBuffer (null);
            buffer.highlight_syntax = true;

            setTheme(settings.get_string ("style-scheme"));

            var manager = Gtk.SourceLanguageManager.get_default ();
            buffer.language = manager.guess_language (file.get_path(), mime_type);
        
            view = new Gtk.SourceView ();
            view.set_show_line_numbers (true);
            view.set_left_margin (10);
            view.buffer = buffer;

            setFont(settings.get_string ("font"));

        } catch (Error e) {
            error ("%s", e.message);
        }

        result = new Gtk.TextView ();
        result.set_wrap_mode(Gtk.WrapMode.WORD);
        result.set_editable (false);
        result.set_left_margin (10);
        result.set_right_margin (10);
        result.set_top_margin (10);
        result.set_bottom_margin (10);
        result.buffer.text = "Result will show up here";
    }
 
    // Public constructor
    public static SourceViewManager get_instance() {
        if (instance == null) {
            instance = new SourceViewManager();
        }
        return instance;
    }

    public Gtk.SourceView getView() {
        return this.view;
    }
    
    public void setView(Gtk.SourceView newView) {
        this.view = newView;
    }

     public Gtk.TextView getResult() {
        return this.result;
    }

    public void setResult(string result){
        this.result.buffer.text = result;
    }

    public File getCodeTestFile(){

        var file = File.new_for_path ("phptest.php");
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                getCodeTestFile();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }
        return file;
    }

    public void setTheme(string themeName){
        var style_scheme_manager = new Gtk.SourceStyleSchemeManager ();
        buffer.style_scheme = style_scheme_manager.get_scheme (themeName);
    }

    public void setFont(string font){
        if(settings.get_boolean ("use-system-font")){
            font = "Monospace 9";
        }
        
        view.override_font (Pango.FontDescription.from_string (font));
    }
}
}

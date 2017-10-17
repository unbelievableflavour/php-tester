namespace PhpTester {
public class SourceViewManager : Object {
    
    static SourceViewManager? instance;

    public Gtk.SourceView view;

    Gtk.Label result;

    // Private constructor
    SourceViewManager() {
        
        try {
            var file = this.getCodeTestFile();
            var info = file.query_info ("standard::*", FileQueryInfoFlags.NONE, null);
            var mime_type = ContentType.get_mime_type (info.get_attribute_as_string (FileAttribute.STANDARD_CONTENT_TYPE));      

            var buffer = new Gtk.SourceBuffer (null);
            buffer.highlight_syntax = true;

            var manager = Gtk.SourceLanguageManager.get_default ();
            buffer.language = manager.guess_language (file.get_path(), mime_type);
        
            view = new Gtk.SourceView ();
            view.set_show_line_numbers (true);
            view.set_left_margin (10);
            view.buffer = buffer;
  
        } catch (Error e) {
            error ("%s", e.message);
        }

        result = new Gtk.Label("Result will show up here");
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

     public Gtk.Label getResult() {
        return this.result;
    }

    public void setResult(string result){
        this.result.set_text(result);
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
}
}

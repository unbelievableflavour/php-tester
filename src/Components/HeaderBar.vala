using Granite.Widgets;

namespace RepositoriesManager {
public class HeaderBar : Gtk.HeaderBar {

    ListManager listManager = ListManager.get_instance();
    
    public HeaderBar(){
        var start_button = new Gtk.Button.with_label ("Run Code");
        start_button.margin_end = 12;
        start_button.clicked.connect (() => {
            writeToFile();

            string result;
	        string error;
	        int status;
            
            try {
		        Process.spawn_command_line_sync ("php phptest.php",
									        out result,
									        out error,
									        out status);

                listManager.setResult(result);                
                if(error != null && error != ""){
                    listManager.setResult(error);                
                }
		     
            } catch (SpawnError e) {
	            new Alert("An error occured", e.message);
            }
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.START);
        button_box.pack_start (start_button);

        this.show_close_button = true;

        this.pack_start (button_box);
    }

     public void writeToFile(){
        var file = getCodeTestFile();

        try {
            if(file.query_exists() == true){

                file.delete(null);
                FileOutputStream fos = file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);
                dos.put_string (listManager.getView().buffer.text, null);
            }
        } catch (Error e) {
            new Alert ("An error Occurred", e.message);
        }
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

using Granite.Widgets;

namespace RepositoriesManager {
public class HeaderBar : Gtk.HeaderBar {

    ListManager listManager = ListManager.get_instance();
    
    public HeaderBar(){
        var start_button = new Gtk.Button.with_label ("Run Code");
        start_button.margin_end = 12;
        start_button.clicked.connect (() => {
            var fileWriter = new FileWriter();
            fileWriter.writeToFile();

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
                    new Alert("PHP error",error);                
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
}
}

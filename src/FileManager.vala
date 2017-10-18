using Granite.Widgets;

namespace PhpTester {
public class FileManager : Object {

    SourceViewManager sourceViewManager = SourceViewManager.get_instance();

    static FileManager? instance;
   
     // Private constructor
    FileManager() {
    }

    // Public constructor
    public static FileManager get_instance() {
        if (instance == null) {
            instance = new FileManager();
        }
        return instance;
    }

    public void writeToFile(){
        var file = getCodeTestFile();

        try {
            if(file.query_exists() == true){
                file.delete(null);
                FileOutputStream fos = file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);
                dos.put_string (sourceViewManager.getView().buffer.text, null);
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

    public void runCode(){
        writeToFile();
        string result;
        string error;
        int status;
        
        try {
	        Process.spawn_command_line_sync ("php phptest.php",
								        out result,
								        out error,
								        out status);

            sourceViewManager.setResult(result);                
            if(error != null && error != ""){
                new Alert("PHP error",error);                
            }
	     
        } catch (SpawnError e) {
            new Alert("An error occured", e.message);
        }
    }
}
}

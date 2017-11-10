using Granite.Widgets;

namespace PhpTester {
public class FileManager : Object {

    private Settings settings = new Settings ("com.github.bartzaalberg.php-tester");
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
        
        try {
            if (!file.query_exists ()) {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                getCodeTestFile();
            }
        } catch (Error e) {
            error ("%s", e.message);
        }

        return file;
    }

    public string getCodeTestFileAsString(){
        var file = getCodeTestFile();
        
        try {
            // Open file for reading and wrap returned FileInputStream into a
            // DataInputStream, so we can read line by line
            var lines = new DataInputStream (file.read ());

            string line;
            string fileAsString = "";

            // Read lines until end of file (null) is reached
            while ((line = lines.read_line (null)) != null) {
                fileAsString += line + "\n";
            }

            if (fileAsString == ""){
                fileAsString = "<?php\n";
            }
           return fileAsString;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public void runCode(){
        writeToFile();
        string result;
        string error;
        int status;
        
        var phpversion = settings.get_string ("php-version");

        try {
	        Process.spawn_command_line_sync ("/usr/bin/" + phpversion + " phptest.php",
								        out result,
								        out error,
								        out status);

            sourceViewManager.setResult(result);                
            if(error != null && error != ""){
                sourceViewManager.setResult(error);
            }
	     
        } catch (SpawnError e) {
            new Alert("An error occured", e.message);
        }
    }
}
}

using Granite.Widgets;

namespace PhpTester {
public class FileManager : Object {

    private Settings settings = new Settings ("com.github.bartzaalberg.php-tester");
    SourceViewManager source_view_manager = SourceViewManager.get_instance ();

    static FileManager? instance;

    FileManager () {
    }

    public static FileManager get_instance () {
        if (instance == null) {
            instance = new FileManager ();
        }
        return instance;
    }

    public void write_to_file () {
        var file = get_code_test_file ();

        try {
            if (file.query_exists () == true) {
                file.delete (null);
                FileOutputStream fos = file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                DataOutputStream dos = new DataOutputStream (fos);
                dos.put_string (source_view_manager.get_view ().buffer.text, null);
            }
        } catch (Error e) {
            new Alert ("An error Occurred", e.message);
        }
    }

    public File get_code_test_file () {
        var file = File.new_for_path ("phptest.php");

        try {
            if (!file.query_exists ()) {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                get_code_test_file ();
            }
        } catch (Error e) {
            error ("%s", e.message);
        }

        return file;
    }

    public string get_code_test_file_as_string () {
        var file = get_code_test_file ();

        try {
            // Open file for reading and wrap returned FileInputStream into a
            // DataInputStream, so we can read line by line
            var lines = new DataInputStream (file.read ());

            string line;
            string file_as_string = "";

            // Read lines until end of file (null) is reached
            while ((line = lines.read_line (null)) != null) {
                file_as_string += line + "\n";
            }

            if (file_as_string == "") {
                file_as_string = "<?php\n";
            }
           return file_as_string;

        } catch (Error e) {
            error ("%s", e.message);
        }
    }

    public void run_code () {
        write_to_file ();
        string result;
        string error;
        int status;

        var phpversion = settings.get_string ("php-version");

        try {
            Process.spawn_command_line_sync ("/usr/bin/" + phpversion + " phptest.php",
            out result,
            out error,
            out status
        );

            source_view_manager.set_result (result);
            if (error != null && error != "") {
                source_view_manager.set_result (error);
            }

        } catch (SpawnError e) {
            new Alert (_("An error occured"), e.message);
        }
    }
}
}

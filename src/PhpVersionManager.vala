namespace PhpTester {
public class PhpVersionManager : Object {
    
    static PhpVersionManager? instance;

    private Gtk.Stack stack;
    string[] phpVersions = {};

    // Private constructor
    PhpVersionManager() {
        getPhpVersions();
    }
 
    // Public constructor
    public static PhpVersionManager get_instance() {
        if (instance == null) {
            instance = new PhpVersionManager();
        }
        return instance;
    }

    private void getPhpVersions(){
        try {
            string directory = "/usr/bin";
            Dir dir = Dir.open (directory, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (directory, name);
                string type = "";

                if (!(FileUtils.test (path, FileTest.IS_EXECUTABLE))) {
                    continue;
                }

                if(!("php" in name)) {
                    continue;
                }

                if((name.substring (0, 3) != "php")){
                    continue;                    
                }

                string shortString = name.substring (-3);
                int number = int.parse(shortString);

                if(number == 0){
                    continue;
                }
                phpVersions += name;
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }
    }

    public string[] getVersions() {
        return this.phpVersions;
    }

    public bool noVersionsFound() {
        return getVersions().length == 0;
    }
}
}

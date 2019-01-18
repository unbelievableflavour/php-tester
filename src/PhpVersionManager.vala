namespace PhpTester {
public class PhpVersionManager : Object {

    static PhpVersionManager? instance;
    private Settings settings = new Settings ("com.github.bartzaalberg.php-tester");
    string[] php_versions = {};

    PhpVersionManager () {
        get_php_versions ();
    }

    public static PhpVersionManager get_instance () {
        if (instance == null) {
            instance = new PhpVersionManager ();
        }
        return instance;
    }

    private void get_php_versions () {
        try {
            string directory = settings.get_string ("php-path");

            if (directory == "") {
                directory = "/usr/bin";
                settings.set_string ("php-path", directory);
            }

            Dir dir = Dir.open (directory, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                string path = Path.build_filename (directory, name);

                if (!(FileUtils.test (path, FileTest.IS_EXECUTABLE))) {
                    continue;
                }

                if (!("php" in name)) {
                    continue;
                }

                if ((name.substring (0, 3) != "php")) {
                    continue;
                }

                if (name != "php" && !fourth_char_is_number (name)) {
                    continue;
                }

                string short_string = name.substring (-3);
                int number = int.parse (short_string);

                if (name != "php" && number == 0) {
                    continue;
                }

                php_versions += name;
            }

            if ( !current_saved_version_is_available ()) {
                settings.set_string ("php-version", php_versions[0]);
            }

        } catch (FileError err) {
            stderr.printf (err.message);
        }
    }

    public bool current_saved_version_is_available () {
        if (no_versions_found ()) {
            return false;
        }
        if (!(settings.get_string ("php-version") in php_versions)) {
            return true;
        }
        return true;
    }

    public string[] get_versions () {
        return this.php_versions;
    }

    public bool no_versions_found () {
        return get_versions ().length == 0;
    }

    public bool fourth_char_is_number (string name) {

        if (name.length < 4) {
            return false;
        }

        var fourth_char = name.substring (3, 1);

        if ( int.parse (fourth_char) == 0) {
            return false;
        }

        return true;
    }
}
}

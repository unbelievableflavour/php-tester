using Granite.Widgets;

namespace RepositoriesManager {
public class FileWriter : Object {

    ListManager listManager = ListManager.get_instance();
   
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

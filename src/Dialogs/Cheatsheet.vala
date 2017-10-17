namespace PhpTester {
public class Cheatsheet : Gtk.Dialog {
  
    public Cheatsheet(){
        title = "Cheatsheet";
        resizable = false;
        deletable = false;

        var general_header = new HeaderLabel ("Cheatsheet");
        
        var runLabel = generateLabel ("Run the code");
        var runEntry = generateEntry ("ctrl + r");

        var copyInputLabel = generateLabel ("Copy input");
        var copyInputEntry = generateEntry ("ctrl + i");

        var copyOutputLabel = generateLabel ("Copy output"); 
        var copyOutputEntry = generateEntry ("ctrl + o");

        var cheatsheetLabel = generateLabel ("Open the cheatsheet");
        var cheatsheetEntry = generateEntry ("ctrl + h");
        
        var close_button = new Gtk.Button.with_label ("Close");
        close_button.margin_right = 6;
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (close_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        var general_grid = new Gtk.Grid ();
        general_grid.row_spacing = 6;
        general_grid.column_spacing = 12;
        general_grid.margin = 12;
        general_grid.attach (general_header, 0, 0, 2, 1);

        general_grid.attach (runLabel, 0, 1, 1, 1);
        general_grid.attach (runEntry, 1, 1, 1, 1);
        general_grid.attach (copyInputLabel, 0, 2, 1, 1);
        general_grid.attach (copyInputEntry, 1, 2, 1, 1);
        general_grid.attach (copyOutputLabel, 0, 3, 1, 1);
        general_grid.attach (copyOutputEntry, 1, 3, 1, 1);
        general_grid.attach (cheatsheetLabel, 0, 4, 1, 1);
        general_grid.attach (cheatsheetEntry, 1, 4, 1, 1);

        var main_grid = new Gtk.Grid ();
        main_grid.attach (general_grid, 0, 0, 1, 1);
        main_grid.attach (button_box, 0, 1, 1, 1);
        
        ((Gtk.Container) get_content_area ()).add (main_grid);
        this.show_all ();
    }

    public Gtk.Label generateLabel (string labelText){
        var label = new Gtk.Label (labelText);
        label.halign = Gtk.Align.START;

        return label;
    }
    
    public Gtk.Label generateEntry (string entryText){
        var entry = new Gtk.Label (null);
        entry.set_markup("<b>" + entryText + "</b>");

        return entry;
    }
    
}
}

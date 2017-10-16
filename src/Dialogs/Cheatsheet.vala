namespace RepositoriesManager {
public class Cheatsheet : Gtk.Dialog {
  
    public Cheatsheet(){
        title = "Cheatsheet";
        resizable = false;
        deletable = false;

        var general_header = new HeaderLabel ("Cheatsheet");
        
        var runLabel = new Gtk.Label ("Run the code");
        runLabel.halign = Gtk.Align.START;
        var runEntry = new Gtk.Label (null);
        runEntry.set_markup("<b>ctrl + r</b>");

        var cheatsheetLabel = new Gtk.Label ("Open the cheatsheet");
        cheatsheetLabel.halign = Gtk.Align.START;        
        var cheatsheetEntry = new Gtk.Label (null);
        cheatsheetEntry.set_markup("<b>ctrl + h</b>");        
        
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
        general_grid.attach (cheatsheetLabel, 0, 2, 1, 1);
        general_grid.attach (cheatsheetEntry, 1, 2, 1, 1);
    
        var main_grid = new Gtk.Grid ();
        main_grid.attach (general_grid, 0, 0, 1, 1);
        main_grid.attach (button_box, 0, 1, 1, 1);
        
        ((Gtk.Container) get_content_area ()).add (main_grid);
        this.show_all ();
    }
}
}

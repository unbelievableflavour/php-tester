using Granite.Widgets;

namespace PhpTester {
public class App:Granite.Application {

    public static MainWindow window = null;

    construct {
        program_name = Constants.APPLICATION_NAME;
    }

    protected override void activate () {
        new_window ();
    }

    public void new_window () {
        if (window != null) {
            window.present ();
            return;
        }

        window = new MainWindow (this);
        window.show_all ();
    }

    public static int main (string[] args) {
        var app = new PhpTester.App ();
        return app.run (args);
    }

}
}


using Granite.Widgets;

namespace PhpTester {
public class App:Granite.Application{

    public static MainWindow window = null;

    construct {
        application_id = Constants.APPLICATION_ID;
        program_name = Constants.APP_NAME;
        app_years = Constants.APP_YEARS;
        exec_name = Constants.EXEC_NAME;
        app_launcher = Constants.DESKTOP_NAME;
        build_version = Constants.VERSION;
        app_icon = Constants.ICON;
        main_url = Constants.MAIN_URL;
        bug_url = Constants.BUG_URL;
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


project('com.github.bartzaalberg.php-tester', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Constants.vala',
    'src/SourceViewManager.vala',
    'src/StackManager.vala',
    'src/PhpVersionManager.vala',
    'src/FileManager.vala',
    'src/Dialogs/Alert.vala',
    'src/Dialogs/Cheatsheet.vala',
    'src/Dialogs/Preferences.vala',
    'src/Components/HeaderBar.vala',
    'src/Components/HeaderLabel.vala',
    'src/Views/StandardView.vala',
    'src/Views/NoPhpFoundView.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('gtksourceview-3.0'),
        dependency('granite')
    ],
    install: true
)

subdir('data')
subdir('po')

install_data(
    join_paths('data',meson.project_name() + '.gschema.xml'),
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

install_data(
    join_paths('data', meson.project_name() + '.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications')
)

install_data(
    join_paths('data', meson.project_name() + '.appdata.xml'),
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

python3 = import('python3').find_python()
run_command(python3, '-c', 'import shutil; shutil.copy("hooks/pre-commit.hook", ".git/hooks/pre-commit")')

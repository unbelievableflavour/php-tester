# PHP Tester
Test your PHP code easily

<p align="center">
    <a href="<p align="center">
    <a href="https://appcenter.elementary.io/com.github.bartzaalberg.php-tester">
        <img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter">
    </a>
</p>

<p align="center">
    <img
    src="https://raw.githubusercontent.com/bartzaalberg/php-tester/master/screenshot.png" />
</p>

### PHP code without a server!

A Vala application to test PHP snippets without having to start a server.

## Installation

First you will need to install elementary SDK

 `sudo apt install elementary-sdk`

### Dependencies

These dependencies must be present before building
 - `valac`
 - `gtk+-3.0`
 - `granite`
 - `gtksourceview-3.0`

 You can install these on a Ubuntu-based system by executing this command:

 `sudo apt install valac libgtk-3-dev libgranite-dev gtksourceview-3.0`

### Building
```
meson build --prefix=/usr
cd build
ninja
```

### Installing
`sudo ninja install`

### Recompile the schema after installation
`sudo glib-compile-schemas /usr/share/glib-2.0/schemas`

## FAQ

#### I have XAMPP installed but the application can't find PHP. Why is that so?

Unfortunately XAMPP puts PHP in a location that PHP Tester cannot reach. As a workaround you can create a symlink to the default location. Set the PHP path back to `/usr/bin` from the applicatoin and run the following command.

`sudo ln -s /opt/lampp/bin/php /usr/bin/php`

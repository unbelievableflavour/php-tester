# PHP Tester
Test your PHP code easily
 
<p align="center"> 
    <img  
    src="https://raw.githubusercontent.com/bartzaalberg/php-tester/master/screenshot.png" /> 
</p>

### PHP code without a server!

A Vala application to test PHP code without a server.

## Installation

### Dependencies

These dependencies must be present before building
 - `valac`
 - `gtk+-3.0`
 - `granite`

 You can install these on a Ubuntu-based system by executing this command:
 
 `sudo apt install valac libgtk-3-dev libgranite-dev`


### Building
```
mkdir build
cd build
cmake ..
make
```

### Installing
`sudo make install`

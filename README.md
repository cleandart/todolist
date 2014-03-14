TodoList
--------

This is sample application that uses clean framework for data synchronization
and dart-react (dart port of Facebook's React framework for renderring). 

Application should provide superset of TodoMVC todolist's, we add some features
to illustrate the full power of the framework. Current features are:

- live data synchronization (try opening multiple instances of client application)
- asana-like behavior (drag&drop of tasks, navigation by arrows, 
  task adding/deleting by enter/backspace)
 
Installation
------------

- You must have mongoDB instance running on its standart port 
- Download the source code
- Run Dartium
- Navigate dartium to http://127.0.0.1:8080/static/index.html
- Run server (bin/server.dart) (working directory should be set as default)
- Refresh Dartium

warning: currently, if you use other URL than above, you may crash the server;
this will be corrected, however, if it hapens, just restart it.
   
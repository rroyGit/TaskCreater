# TaskCreater
A Ruby CLI that allows new process creation, file i/o operations, and network data transfer. Each task operation is logged - logged data is inserted into a JSON file. Common logged data includes the Process Name, Process ID, User Name, Command-Line Arguments, and Start Time.

Usage:

Choose one of the following options [1-5]:

        1. |Start Process| [path to executable] [optional command-line arguments]

        2. |Create a new file| [location to dir] [file name w/ extension]

        3. |Delete a file| [file path]

        4. |Modify a file| [file path] ["data to add - type String"]

        5. |Transfer a file| [Destinaton address] [Destination port] ["data to send - type String"]

            The above will send the data using the TCP protocol. HTTP protocol is used when the fifth option is used with an URI string, like in the last example.
Examples:

    ruby TaskCreator.rb 1 /bin/cat /etc/hosts

    ruby TaskCreator.rb 1 "C:\Program Files\Git\bin\git.exe" --version
        
        On Windows, the path to the executable and its argument(s) look like this: "C:\Program Files\Git\bin\git.exe" --version
        The open/close quotation marks are critical for a dir name that has a white-space character

    ruby TaskCreator.rb 2 /home/user/src/ hello_world.txt

    ruby TaskCreator.rb 3 /home/user/src/hello_world.txt

    ruby TaskCreator.rb 4 /home/user/src/hello_world.txt "Hello There! General Kenobi"

    ruby TaskCreator.rb 5 192.168.1.23 3000 "It is your Birthday"

    ruby TaskCreator.rb 5 "http://bing-gnc-service.herokuapp.com/temp?sensorId=1&value=45&seqNum=0"
        
        The HTTP functionality is tested by sending the above GET request, visiting https://bing-gnc.herokuapp.com/home/ and clicking on the Start button to begin seeing the new sensor value. Note - on the first visit to the heroku page there is a small delay because the corresponding dynamo process is in a sleep state. 
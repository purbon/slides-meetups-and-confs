# The Berlin UBahn network

![Alt text](https://raw.githubusercontent.com/purbon/eurucamp2014_workshop/master/tasks/images/berlin_map.jpg)

## The Problem

Berlin can be a bit tricky when talking about public transport, in some zones you’ve underground, in other still some nice trams, etc.

In this exercise we aim to load and analyse the Berlin UBahn (underground) network, where we can answer questions like the shortest path between two stations. It’s very important to notice we’re not modeling the hole public transportation network, so there are some stations of the previous map not available in the dataset.

Questions we want to answer:
* From a given line, for example U7, give me all the stations in order.
* Given two stations far away, get the fastest path between them. 

We encourage you to try to create your own loader, but if you get stuck with it you can also use the loader provided with this example.


## The dataset

To do this exercise we’re going to use the custom dataset available at the datasets/ubahn directory, there you will find the next set of files.

*File*

ulines.csv

*Description*
Data about for every ubahn (underground) line in Berlin. 

As you can see within the data sample each row contains a unique identifier for the station, the station name and the line label. Must be noticed that within each line (ex: U7) the stations are in order, so for the sample the first station is Rathaus Spandau and the next one in the line is Altstadt Spandau and so on.

*Sample*

| Cod        | Station           | Line  |
| ------------- |:-------------:| -----:|
| 9029302 | S+U Rathaus Spandau (Berlin) | U7  |
| 9029301 | U Altstadt Spandau (Berlin)  | U7 |
| 9033101 | U Zitadelle (Berlin)  | U7  |
| 9034102 | U Haselhorst (Berlin) | U7  |

*File*
utransfers.csv

*Description*
Contains a record for each transfer between a stations, including the transfer type and the average time between the two stations. Is important to notice that a transfer can be also between the same station, so for example from one line to another, or from one direction to the other. 

*Sample*

| from    | to      | type | time | status |
| ------- |:-------:| ----:| ----:| ------:|
| 9100011 | 9100701 |  2   | 180  |        |
| 9100701 | 9100011 |  2   | 180  |        |
| 9001201 | 9001201 |  2   | 120  |        |
| 9002201 | 9002201 |  2   | 120  |        |



## The model

![graph model](https://raw.githubusercontent.com/purbon/eurucamp2014_workshop/master/tasks/images/transfer_graph.png)

Although we can put in place more complex models for a network of this kind, the most simple one is the one you find in the previous picture.  In our case we’ve stations, including their set of properties [name, line, etc…] and a connection edge [time] between them.

There is also an special edge named transfer [time] that represents a connection between two stations.


## Tips

### Database

As we spoke for this exercise we provide the dataset in a CSV file format, is a choice of the student to create his own model by crafting a custom loader or use the one provided by us. In case you want to create a more complex model feel free to submit any question or discussion you have about pros and cons.

Remember that the default location for the database is under the root directory of your app and using the name db. In case you want a custom one, you can use the Neo4j::Config class to change the storage_path variable to your own location.

### Support classes

They are located in the **lib/ubahn.rb** file, from the console you can load the using the require ‘ubahn’ command.

In this case you can find there a loader and the very simple model classes we described before. 


To use the loader you can do it by:

| Description | Function/Code | 
| ------- |:-------:| 
| To create a new loader object | Bacon::Loader.new |
| To load at the same time the lines info and the transfer between stations. | loader.create(lines_file, transfers_file) |
| To load only the lines data | loader.add_lines_from(lines) |
| To load only the transfer data, keep in mind this relay somehow with the previous item | loader.def add_transfers_from(transfers) |

As you could read in the previous section we provide a sample of both files within the datasets directory.

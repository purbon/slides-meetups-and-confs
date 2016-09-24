# The Bacon Number

## The problem

The Bacon number of an actor or actress is the number of degrees of separation he or she has from Bacon, as defined by the game. This is an application of the Erdős number concept to the Hollywood movie industry. The higher the Bacon number, the farther away from Kevin Bacon the actor is.

The computation of a Bacon number for actor X is a path algorithm, applied to the co-stardom network:

* Kevin Bacon has a Bacon number of 0.
* Those actors who have worked directly with Kevin Bacon have a Bacon number of 1.
* If the lowest Bacon number of any actor with whom X has appeared in any movie is N, X's Bacon number is N+1.

Here is an example, using Elvis Presley:

* Elvis Presley was in Change of Habit (1969) with Edward Asner
* Edward Asner was in JFK (1991) with Kevin Bacon

Therefore, Asner has a Bacon number of 1, and Presley (who never appeared in a film with Bacon) has a Bacon number of 2.
					
<sub> _Reference_ http://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon </sub>

## The dataset

To do this computation we’re going to use the movie dataset provided by neo4j. You can find a copy of this dataset within the datasets directory under the name bacon.

## The model

In our case we face with the next set of nodes and edges:

![Bacon graph](https://raw.githubusercontent.com/purbon/eurucamp2014_workshop/master/tasks/images/bacon_graph.png)

As you can see, we’ve actors who act in a movie with a given role, so we’re going to travel this relationships in order to find the distance between one actor and mister Bacon.

## Tips

### Database 

If you’re using the console for your experimentation, keep in mind the neo4j database should be in the project root directory and use the name db. Otherwise, if you want to have a non standard one, you can use the Neo4j::Config class to change the storage_path variable to the new one.
Support classes

They are located in the lib/bacon.rb file, from the console you can load the using the require ‘bacon’ command.

In this case the only support class added is a mapping to the person index so you’re able to search for actors as we see in the next sections.

### To find and actor

`bacon = Bacon::PersonIndex.find("name: \"Kevin Bacon\"").first`

`kline   = Bacon::PersonIndex.find("name: \"Kevin Kline\"").first`

### To find all the actors

`Bacon::PersonIndex.find(“name: *”)`

### Neo4j algorithms reference

https://github.com/andreasronge/neo4j-core/blob/v2.x/lib/neo4j/algo.rb

### Mr Bacon attributes

* ID: 4728


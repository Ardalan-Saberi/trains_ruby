#H2 Trains Problem Solution in Ruby

# TLDR; = Usage

1- to install dev dependencies
$ bundle install
2- to see tests passing with flying colours
$ rspec
3- to see it print out the solution to sample input from the problem statement
$ rake install
$ rake demo

# Description

The purpose of this problem is to help **(1)Kiwiland's railroad** provide its customers with information about the routes.  In particular, you will **(2)compute the distance along a certain route**, the **(3)number of different routes between two towns**, and the **(4)shortest route between two towns**.

- Nouns
    1- Railroad Network of Kiwiland: Implemented as an adjencency matrix represented by **RailroadSystem** containing a hash of **Stations**. Each station has a hash of distances of neighbouring stations.
    
- Verbs
  2- Compute the distance along route: **RouteDistanceQuery#get_routes_distance** moves a sliding window along the route and sums up the pairwise distances
  3- Count Number of different routes between two towns with either *maximum distance, maximum stops or exact stops constraint* (possibly visiting towns more than once): **RouteCountQuery** module has a method **count_routes_from** starting from route's origin station and visit's stations in BFS manner. On visit it yields to a lambda to accumulate the completed routes, and indicate if the constraint (maximum distance, ...) has been met.
    RouteCouteQuery's **constrainted_reducer** method pareses the constraint and generates the mentioned lambda.
  4- Calculate Shortest route between two towns: **ShortestRouteQuery** module's **get_shortest_route** implement's Dijekstra algorithm (*with an additional step at the end to allow for circular routes)
  5- Create Railroad System from string: **RailroadHelper** module has a static factory **create_railroad_system_from_string** which returns a RailroadSystem
    
# Test/BDD : RSpec
./lib/spec/unit
./lib/spec/integrations

all tests say what they're supposed to do at the top so not much to add here :)
[Will probably add more details here](https://docs.google.com/document/d/1P00T4WOv4HyWcRHiS4p18dsmL-vU4pQbc2sxM8t9qzM/edit?usp=sharing)

Cheers,
Ardalan

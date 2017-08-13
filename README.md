# Trains Problem Solution in Ruby

# TLDR; Usage

1- To install dev dependencies (in trains_ruby directory)  
*$ bundle install*

2- To see tests passing with flying colours  
*$ rspec*

3- If you really really want to try the the file input:D  
*$ ruby main.rb ./sample_input1*  
*$ ruby main.rb ./sample_input2*

# The Story:

The purpose of this problem is to help **Kiwiland's railroad(1)** provide its customers with information about the routes.  In particular, you will **compute the distance along a certain route(2)**, the **number of different routes between two towns(3)**, and the **shortest route between two towns(4)**.

1- Railroad Network of Kiwiland: Implemented as an adjencency matrix represented by **RailroadSystem** containing a hash of **Stations**. Each station has a hash of distances of neighbouring stations.

2- Compute the distance along route: **RouteDistanceQuery#get_routes_distance** moves a sliding window along the route and sums up the pairwise distances

3- Count Number of different routes between two towns with either *maximum distance, maximum stops or exact stops constraint* (possibly visiting towns more than once): **RouteCountQuery** module has a method **count_routes_from** starting from route's origin station and visit's stations in BFS manner. On visit it yields to a lambda to accumulate the completed routes, and indicate if the constraint (maximum distance, ...) has been met.
RouteCouteQuery's **constrainted_reducer** method pareses the constraint and generates the mentioned lambda.

4- Calculate Shortest route between two towns: **ShortestRouteQuery** module's **get_shortest_route** implement's Dijekstra algorithm (*with an additional step at the end to allow for circular routes)

5- Create Railroad System from string: **RailroadHelper** module has a static factory **create_railroad_system_from_string** which returns a RailroadSystem

**_All of above stuff is located in this directory: ./lib/trains_ruby_**
    
# Tests:
Used RSpec so the tests are pretty much self explanatory please look at **./lib/spec/unit** and **./lib/spec/integrations**  

# Input File Format
File's read line by line, each line contains a command as the first arguement and a list of arguements. two examples below. loading new graphs will purge the ones before them.

./sample_input1:     the example from the problem statement  
./sample_input2:    this is more of playing with the edge cases, what if command is not supported, what if arguments are missing, ...  

**load AB4 DE3**   
-> creates a RailroadSystem with tow railroads from station A to B and D to E  
**get_route_distance A B C D**    
-> calculates the distance of route from A to B to C to D  
**count_routes A A max_stops 3**     
-> options for constraints are max_stops, max_distance, exact_stops  
**get_shortest_route A B**   
->shortest route from A to B  

# Output Format
Repeats the command and on the next line will put the response wiht "=>" at the beginning

p.s. ruby version = 2.3.3

Cheers,  
[Might add more details here](https://docs.google.com/document/d/1P00T4WOv4HyWcRHiS4p18dsmL-vU4pQbc2sxM8t9qzM/edit?usp=sharing)



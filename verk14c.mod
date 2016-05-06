set planes;
set cities;

# Cost for issuing flight to specific city cannot be less than 0
var flightRoutes{planes,cities} integer >=0;

# Fligh time consumed from issuing flight
param tripProfits{planes,cities};
# Flight time for each machine cannot be less than 0
param flightTime{planes,cities}>=0;
# Maximum flight time for each class of plane
param maxFlightTimeForPlanes{planes};
# Minimum service of flights for each city
param minimumService{cities};

# Minimization of costs for each route (each plane sent to a city)
minimize tripFlightTimeSum:sum{p in planes, c in cities}(flightTime[p,c]*flightRoutes[p,c]);

# Each class of plane cannot exceed maximum flying time allocated for each class
subject to flightTimeConstraint{p in planes}: sum{c in cities}flightTime[p,c]*flightRoutes[p,c] <= maxFlightTimeForPlanes[p];
# Each city needs a minimum amount of flights
subject to serviceTimeConstraint{c in cities}: sum{p in planes}flightRoutes[p,c] >= minimumService[c];

solve;

display tripFlightTimeSum;
display flightRoutes;

data;

set planes := B707 Electra DC9;
set cities := A B C D;

param tripProfits: A B C D :=
B707    -1000  0      2000  8000
Electra 2000   2000   2000  -100000
DC9     2000   2000   2000  4000 ;

param flightTime: A B C D :=
B707    1 2 5 10
Electra 2 4 8 20
DC9     1 2 6 12 ;

param: maxFlightTimeForPlanes :=
B707 180
Electra 270
DC9 36;

param: minimumService :=
A 4
B 4
C 4
D 2;

end;

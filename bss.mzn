include "alldifferent.mzn";
set of int: STATIONS = 1..21;
int: Q = 60;


array[STATIONS,STATIONS] of int: distance_matrix;
array[STATIONS] of int: demand;


array[1..22] of var STATIONS: route;
array[STATIONS] of var int: operated;
array[STATIONS] of var int: truckload;

var int: total_dist;
var int: unmet_dem;

constraint truckload[1] = Q;
constraint route[1] = 1;
constraint route[22] = 1;
constraint operated[1] = 0;

constraint alldifferent([route[i] | i in 1..21]);  


constraint forall(i in 2..21)(
  if demand[route[i]] > 0 then
    operated[route[i]] = min(demand[route[i]], truckload[route[i]])
  else
    operated[route[i]] = max(demand[route[i]], truckload[route[i]] - Q)
  endif
);

constraint forall(i in 2..21)(
  truckload[route[i]] = truckload[route[i-1]] - operated[route[i-1]]
);

constraint(total_dist = sum(i in 2..22)(distance_matrix[route[i-1], route[i]]));
constraint(unmet_dem = sum(i in 2..21)(abs(demand[route[i]] - operated[route[i]])));

solve minimize total_dist+unmet_dem;

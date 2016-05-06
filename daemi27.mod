set grades;
set schools;
set neighborhoods;
set races;

# How many students from each grade in each neighborhood from a specific race are assigned to a school
var assignStudents{neighborhoods,schools,grades,races}>=0;

# Capacity for certain grade in each school
param capacity{schools,grades}>=0;
# Population of each grade in each neighborhood of specific race
param population{neighborhoods,grades,races}>=0;
# Average distance for student to travel from neighborhood to school
param distance{neighborhoods, schools}>=0;
# Total number of students by grade
param studentCount{grades}>=0;
# Minimum amount of students pertaining to specific race in school
param minRaceInSchool{schools,races}>=0;
# Maxmimum amount of students pertaining to specific race in school
param maxRaceInSchool{schools,races}>=0;

# Minimization of total distance travelled by all students
# Distance is to the power of 2 to discourage model even more to not put students in schools far away
minimize totalDistance:sum{i in neighborhoods,j in schools, g in grades, k in races}assignStudents[i,j,g,k]*(distance[i,j]^2);

# Each school has maximum capacity for each grade
subject to maxCapacity{j in schools, g in grades}:sum{i in neighborhoods, k in races}assignStudents[i,j,g,k] <= capacity[j,g];
# Each student needs to be assigned to one school
subject to studentInSchool{g in grades}:sum{i in neighborhoods, j in schools, k in races}assignStudents[i,j,g,k] = studentCount[g];
# Students from neighborhood and class cannot be more than students from neighborhood and class in all schools
subject to neighborhoodMaximum{i in neighborhoods, g in grades, k in races}:sum{j in schools}assignStudents[i,j,g,k] <= population[i,g,k];
# Ensure that there is a minimum percentage of each race in schools
subject to minimumRace{j in schools, k in races}:sum{i in neighborhoods, g in grades}assignStudents[i,j,g,k] >= minRaceInSchool[j,k];
# Ensure that there is less than or equal to maximum percentage of each race in schools
subject to maximumRace{j in schools, k in races}:sum{i in neighborhoods, g in grades}assignStudents[i,j,g,k] <= maxRaceInSchool[j,k];

solve;

display assignStudents;
printf "Total distance travelled: \n";
printf sum{g in grades, k in races, i in neighborhoods, j in schools}assignStudents[i,j,g,k]*distance[i,j];
printf "\n";

data;

set grades := 4th 5th 6th;
set schools := Burbank Montebello Duarte;
set neighborhoods := Silver_Lake Eagle_Rock Westwood Los_Feliz;
set races := Martians Earthians;

param capacity: 4th 5th 6th :=
Burbank    70  110  40
Montebello 30  60   60
Duarte     140 50   80 ;

param population :=
[*,*,Martians] Silver_Lake 4th 40 Silver_Lake 5th 55 Silver_Lake 6th 25
               Eagle_Rock 4th 20  Eagle_Rock 5th 20  Eagle_Rock 6th 35
               Westwood 4th 40    Westwood 5th 7     Westwood 6th 30
               Los_Feliz 4th 15   Los_Feliz 5th 35   Los_Feliz 6th 20

[*,*,Earthians] Silver_Lake 4th 20 Silver_Lake 5th 30 Silver_Lake 6th 0
               Eagle_Rock 4th 60   Eagle_Rock 5th 40  Eagle_Rock 6th 35
               Westwood 4th 10     Westwood 5th 3     Westwood 6th 20
               Los_Feliz 4th 25    Los_Feliz 5th 25   Los_Feliz 6th 15 ;

param distance: Burbank Montebello Duarte :=
Silver_Lake 35  16  3
Eagle_Rock  38  18  7
Westwood    32  13  9
Los_Feliz   35  17  2 ;

param: studentCount :=
4th 230
5th 215
6th 180 ;

param minRaceInSchool: Martians Earthians :=
Burbank    40 40
Montebello 10 10
Duarte     15 15 ;

param maxRaceInSchool: Martians Earthians :=
Burbank    70  150
Montebello 50  150
Duarte     240 40 ;

end;

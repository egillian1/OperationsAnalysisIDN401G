set Products;
set Resources;

# var = akvordunarbreyta # param = studlar

# Production of each product cannot be less than 0
var Production{Products}>=0;

# Profit cannot be less than 0 (unbounded)
param profit{Products} >= 0;
# Maximum amount of resources that can be used (skordur)
param R_max{Resources};
# How much resources are needed for on unit of each Production
param resourceNeed{Resources, Products} >= 0;

# Maximize profit by multiplying production with product profit
maximize netProfit:sum{p in Products}profit[p]*Production[p];

# Iterate through each line in table and set resource use less than resource cache
subject to skordur{m in Resources}:sum{p in Products}resourceNeed[m,p]*Production[p]<=R_max[m];

solve;

display Production;
display netProfit;

data;

set Products := cloth screen mesh fence;
set Resources := aluminum wiredrawing loom;

param: profit :=
cloth  2
screen 3
mesh   4.2
fence  4;

param resourceNeed: cloth screen mesh fence :=
aluminum      1   3   3   2.5
wiredrawing   1   1   2   1.5
loom          2   1   1.5 2;

param: R_max :=
aluminum    15
wiredrawing 6
loom        10;

end;

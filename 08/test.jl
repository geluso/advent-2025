using Test

include("Point3D.jl")

p1 = line_to_point("123,456,789")
@test p1.xx == 123
@test p1.yy == 456
@test p1.zz == 789

origin = line_to_point("000,000,000")
@test origin.xx == 0
@test origin.yy == 0
@test origin.zz == 0

man_is_five = line_to_point("555,000,000")
devil_is_six = line_to_point("000,666,000")
god_is_seven = line_to_point("000,000,777")

@test distance(origin, man_is_five) == 555
@test distance(origin, devil_is_six) == 666
@test distance(origin, god_is_seven) == 777

# https://www.calculatorsoup.com/calculators/geometry-solids/distance-two-points.php
@test distance(man_is_five, god_is_seven) == 954.8581046417315


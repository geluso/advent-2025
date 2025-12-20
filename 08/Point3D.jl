struct Point3D
    xx::Int
    yy::Int
    zz::Int
end

function point_to_key(pp::Point3D)
  return "$(pp.xx),$(pp.yy),$(pp.zz)"
end

function distance(p1::Point3D, p2::Point3D)
    dx = p1.xx - p2.xx
    dy = p1.yy - p2.yy
    dz = p1.zz - p2.zz
    return sqrt(dx * dx + dy * dy + dz * dz)
end

function line_to_point(line::String)
    xx, yy, zz = split(line, ',')
    pp = Point3D(parse(Int, xx), parse(Int, yy), parse(Int, zz))
    return pp
end

struct PointToPointDistance
  p1::Point3D
  p2::Point3D
  distance::Float64
end

function Base.isless(d1::PointToPointDistance, d2::PointToPointDistance)
  return isless(d1.distance, d2.distance)
end
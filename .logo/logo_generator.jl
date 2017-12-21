
function writeln(f::IOStream, s::String)
  write(f, s*"\n")
end

function rotate(point::Vector{Float64}, ϕ::Float64)
  [cos(ϕ) -sin(ϕ); sin(ϕ) cos(ϕ)]*point
end


function ellipse(a::Float64, b::Float64, t::Float64, ϕ::Float64)
  return rotate([a*cos(t), b*sin(t)], ϕ)
  #[a*cos(t), b*sin(t)]
end




file = open("julia-generated.tex" ,"w")
writeln(file,  "\\begin{tikzpicture}")
# ellipses

function ellipse(a::Float64, b::Float64, t::Float64)
  return (a*cos(t), b*cos(t))
end

a, b = (2., .4)
αs = collect(0.:0.5:2*π)

points = map(α->ellipse(a, b, α, 0.), αs)
radius = 0.3

for i=1:(length(points)-1)
  p1=points[i]
  writeln(file, "\\coordinate (p$i) at $(string(Tuple{Float64,Float64}(p1)));")
  writeln(file, "\\draw[thick, black, fill=black] (p$i) circle ($(radius)ex);")
end

for i=1:(length(points)-2)
  writeln(file, "\\draw[thick] (p$i) edge (p$(i+1));")
end
writeln(file, "\\draw[thick] (p$(length(points)-1)) edge (p1);")

points = map(α->ellipse(a, b, α, 45.), αs)
for i=1:(length(points)-1)
  p1=points[i]
  p2=points[i+1]
  writeln(file, "\\coordinate (r$i) at $(string(Tuple{Float64,Float64}(p1)));")
  writeln(file, "\\draw[thick, black, fill=black] (r$i) circle ($(radius)ex);")
end

points = map(α->ellipse(a, b, α, -45.), αs)
for i=1:(length(points)-1)
  p1=points[i]
  p2=points[i+1]
  writeln(file, "\\coordinate (s$i) at $(string(Tuple{Float64,Float64}(p1)));")
  writeln(file, "\\draw[thick, black, fill=black] (s$i) circle ($(radius)ex);")
end

for i=1:(length(points)-2)
  writeln(file, "\\draw[thick] (p$i) edge (p$(i+1));")
  writeln(file, "\\draw[thick] (r$i) edge (r$(i+1));")
  writeln(file, "\\draw[thick] (s$i) edge (s$(i+1));")
end
writeln(file, "\\draw[thick] (p$(length(points)-1)) edge (p1);")
writeln(file, "\\draw[thick] (r$(length(points)-1)) edge (r1);")
writeln(file, "\\draw[thick] (s$(length(points)-1)) edge (s1);")

# center
writeln(file, "\\coordinate (center) at (0,0);")
writeln(file, "\\draw[thick, red, fill=red] (center) circle ($(radius)ex);")

# additional edges with center
writeln(file, "\\draw[thick] (center) edge (s4);")
#writeln(file, "\\draw[thick] (center) edge (r4);")

# ellpise internal
writeln(file, "\\draw[thick] (s3) edge (s1);")
writeln(file, "\\draw[thick] (s3) edge (s12);")
writeln(file, "\\draw[thick] (s6) edge (s8);")


writeln(file, "\\draw[thick] (r3) edge (r1);")
writeln(file, "\\draw[thick] (r6) edge (r8);")

writeln(file, "\\draw[thick] (p1) edge (p3);")
writeln(file, "\\draw[thick] (p6) edge (p9);")

#external
writeln(file, "\\draw[thick] (p5) edge (s10);")
writeln(file, "\\draw[thick] (p10) edge (s11);")
writeln(file, "\\draw[thick] (p11) edge (s4);")


writeln(file, "\\end{tikzpicture}")
close(file)

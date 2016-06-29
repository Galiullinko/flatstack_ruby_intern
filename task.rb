#Made by Arthur Galiullin, ITIS 11-402, galiullinko@gmail.com
def f(str)
  str.chars.chunk{|c| c}.map{|c,x| [x.size, c]}.join
end
 
puts num = "1"
9.times do
  puts num = f(num)
end
foods = Hash.new { |hash, key| hash[key] = [] }
foods['A'] << "Apple"
foods['A'] << "Avocado"
foods['B'] << "Bacon"
foods['B'] << "Bread"
p foods['A']
p foods['B']
p foods

class CelestialBody
  attr_accessor :type, :name
end
bodies = Hash.new do |hash, key|
  body = CelestialBody.new
  body.type = "planet"
  hash[key] = body
end
bodies['Mars'].name = 'Mars'
bodies['Europa'].name = 'Europa'
bodies['Europa'].type = 'moon'
bodies['Venus'].name = 'Venus'
p bodies
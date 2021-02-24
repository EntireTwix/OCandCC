--water source in front of turtle, lave source to the right
while true do 
  turtle.turnRight()
  while not turtle.place() do os.sleep(0) end
  turtle.turnLeft()
  turtle.place()
  turtle.dig()
end

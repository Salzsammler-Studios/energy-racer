# energy-racer
An educational game about climate change using a real bike and arduino.


# Architecture
In the following chapter, the basic functionality of the classes will be explained 
to ease the game design practices
### score.gd
score is saving the score-points and the corresponding setter functions 
### playerCar.gd
important variables:
- fuelDepletionRate (in seconds)
- MAX_FUEL
- MAX_SPEED
- MIN_SPEED (when fuel is empty. this can be changed)
  - get_reservoir_filling_rate returns reservoir fill rate based on current amount of fuel in the tank
### playerBycicle.gd
- speed: the default speed in pixels/sec
- acceleration - will be the acceleration of the physical bike
  - is also used as the reservoir-fill rate (to be discussed)
### gasStation.gd
- fillRate - amount of fuel refueled (in seconds i think.)
### reservoir.gd
- MAX_CAPACITY - when is the reservoir full?

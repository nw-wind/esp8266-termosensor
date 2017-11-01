local pin = 4
print("LED pin ",pin)
local level=gpio.HIGH
gpio.mode(pin, gpio.OUTPUT)
local mytimer = tmr.create()
mytimer:register(10000, tmr.ALARM_AUTO, function() 
  gpio.write(pin, level)
  level = level == gpio.HIGH and gpio.LOW or gpio.HIGH
end)
mytimer:interval(1000) -- actually, 3 seconds is better!
mytimer:start()

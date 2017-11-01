local ledPin = 4
local dhtPin = 0
local tPin = 1
print("LED pin ",ledPin)
local level=gpio.HIGH
gpio.mode(ledPin, gpio.OUTPUT)
local mytimer = tmr.create()
mytimer:register(10000, tmr.ALARM_AUTO, function() 
  gpio.write(ledPin, level)
  level = level == gpio.HIGH and gpio.LOW or gpio.HIGH
  -- DS18B20
  ds18b20.setup(tPin)
  -- DHT22
  status, temp, humi, temp_dec, humi_dec = dht.read(dhtPin)
  if status == dht.OK then
    print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
          math.floor(temp),
          temp_dec,
          math.floor(humi),
          humi_dec
    ))
  else
    print("Error reading dht22") 
  end
end)
mytimer:interval(1000) -- actually, 3 seconds is better!
mytimer:start()

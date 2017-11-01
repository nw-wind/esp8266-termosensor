local ledPin = 4
local dhtPin = 1
local tPin = 1
local iD = "TEST"
local interval = 300000
print("LED pin ",ledPin)
local level=gpio.HIGH
gpio.mode(ledPin, gpio.OUTPUT)
local mytimer = tmr.create()
mytimer:register(interval, tmr.ALARM_AUTO, function() 
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
    http.get(string.format("http://dkamushkin.ru/cgi-bin/netmeg1.pl?i=%s&h=%d&t1=%d&t2=%d",
      iD,math.floor(temp),math.floor(humi),0),
      nil,nil)
  else
    print("Error reading dht22") 
  end
end)
mytimer:interval(interval) -- actually, 3 seconds is better!
mytimer:start()

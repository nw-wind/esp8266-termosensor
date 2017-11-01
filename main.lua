local ledPin = 2 -- 4 default
local dhtPin = 1
local tPin = 3
local iD = "TEST"
local interval = 600000

local gTemp=-99

ds18b20.setup(tPin)
gpio.mode(ledPin, gpio.OUTPUT)
local mytimer = tmr.create()
mytimer:register(interval, tmr.ALARM_AUTO, function() 
  gpio.write(ledPin, gpio.HIGH)
  -- DS18B20
  gTemp=-99
  ds18b20.read(function(ind,rom,res,temp,tdec,par)
    --print(ind,string.format("%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X",
    --  string.match(rom,"(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")),res,temp,tdec,par)
    gTemp=temp
    print("IN DS18B20="..gTemp)
    -- DHT22
    local status, temp, humi, temp_dec, humi_dec = dht.read(dhtPin)
    if status == dht.OK then
      print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
          math.floor(temp),
          temp_dec,
          math.floor(humi),
          humi_dec
      ))
      http.get(string.format("http://dkamushkin.ru/cgi-bin/netmeg1.pl?i=%s&h=%d&t1=%d&t2=%d",
        iD,math.floor(humi),math.floor(temp),gTemp),
        nil,nil)
    else
      print("Error reading dht22") 
    end
    gpio.write(ledPin, gpio.LOW)
  end,{})
end)
mytimer:start()

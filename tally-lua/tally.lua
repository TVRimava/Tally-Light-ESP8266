-- for sure, disconnect from wifi
wifi.sta.disconnect()
wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASS)
wifi.sta.connect()


-- Wait for connection
function CheckWifi()
   if (wifi.sta.status() == 5) then -- wait till wifi is connected and IP address is aquired from DHCP
      tmr.stop(1)
      print("IP: " .. wifi.sta.getip())
      -- start web daemon
      dofile("web-daemon.lua")
      print("web service started")
      -- register tally to multicast dns, so tally will be reached by http://tally-camX.local/
      mdns.register("tally-cam"..cam_number, { description="Tally Light "..cam_number, service="http", port=80, location=SSID })
      print('BonJour (mDNS) responder started')
      print("System is fully working")
   else 
      print("waiting for connection")
   end;
end

tmr.alarm(1,1000,1, function() CheckWifi() end)

dofile("afterboot.lua")
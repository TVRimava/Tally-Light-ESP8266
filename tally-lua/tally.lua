-- for sure, disconnect from wifi
wifi.sta.disconnect();
wifi.setmode(wifi.STATION);
wifi.sta.config(SSID,PASS);
wifi.sta.connect();

blink_state=0;

-- Wait for connection
function CheckWifi()
   if (wifi.sta.status() == 5) then -- wait till wifi is connected and IP address is aquired from DHCP
      tmr.stop(1);
      -- signalize orange - we got IP
      gpio.write(led1, gpio.LOW);
      gpio.write(led2, gpio.LOW);
      print("IP: " .. wifi.sta.getip());
      -- start web daemon
      dofile("web-daemon.lua");
      print("web service started");
      -- register tally to multicast dns, so tally will be reached by http://tally-camX.local/
      mdns.register("tally-cam"..cam_number, { description="Tally Light "..cam_number, service="http", port=80, location=SSID });
      print('BonJour (mDNS) responder started');
      print("System is fully working");
      -- signalize green - we are ready
      gpio.write(led1, gpio.LOW);
      gpio.write(led2, gpio.HIGH);
   else 
      -- blink red - we waiting to connect to wifi and aquire IP from DHCP
      gpio.write(led1, gpio.HIGH);
      gpio.write(led2, blink_state);
      if (blink_state == 0) then
	blink_state = 1;
      else
	blink_state = 0;
      end;
      print("waiting for connection");
   end;
end

tmr.alarm(1,500,1, function() CheckWifi() end);

dofile("afterboot.lua");
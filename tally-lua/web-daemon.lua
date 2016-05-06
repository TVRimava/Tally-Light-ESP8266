srv=net.createServer(net.TCP);
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1><a href='www.tvrimava.sk'>www.tvrimava.sk</a> - Tally Light ("..cam_number..")</h1>";
        buf = buf.."<p>Status <a href=\"?pin=RED\"><button>RED</button></a>&nbsp;<a href=\"?pin=GREEN\"><button>GREEN</button></a>&nbsp;<a href=\"?pin=OFF\"><button>OFF</button></a></p>";
        local _on,_off = "",""
        if(_GET.pin == "OFF")then
              gpio.write(led1, gpio.HIGH);
              gpio.write(led2, gpio.HIGH);
        elseif(_GET.pin == "RED")then
              gpio.write(led1, gpio.HIGH);
              gpio.write(led2, gpio.LOW);
        elseif(_GET.pin == "GREEN")then
              gpio.write(led1, gpio.LOW);
              gpio.write(led2, gpio.HIGH);
        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)

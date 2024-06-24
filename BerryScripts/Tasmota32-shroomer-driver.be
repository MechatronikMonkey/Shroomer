#! ./berry

#- This is using a VL53L0 time of flight optical sensor from China. TOF200C, to check the current volume
   of the Shroomer Water Tank. The sensor measures the distance from the
   sensor to the water and returns a value in millimeters.
   Calculate Tank percentage from millimeters with the upper and lower calib values.
   We display the data on the web page and send it via MQTT.
   
#- *************************************** -#
import webserver
import json
import string

class MyHttpManager

    def inject_auotReloadScript()
        var content = ("// Funktion, die die"
        " Daten per AJAX abru"
        "ft\r\n"
        "    function fetchDa"
        "ta() {\r\n"
        "                // E"
        "rstelle eine neue XM"
        "LHttpRequest\r\n"
        "        const xhr = "
        "new XMLHttpRequest()"
        ";\r\n\r\n"
        "        // Definiere"
        ", was passieren soll"
        ", wenn die Anfrage e"
        "rfolgreich ist\r\n"
        "        xhr.onreadys"
        "tatechange = ()=>{\r"
        "\n"
        "            if (xhr."
        "readyState === 4 && "
        "xhr.status === 200) "
        "{\r\n"
        "                // V"
        "erarbeite die Antwor"
        "tdaten\r\n"
        "                cons"
        "t data = JSON.parse("
        "xhr.responseText);\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob TankPer"
        "c definiert ist und "
        "aktualisiere den For"
        "tschrittsbalken\r\n"
        "                if ("
        "data.TankPerc !== un"
        "defined) {\r\n"
        "                    "
        "// Aktualisiere den "
        "Inhalt des div-Eleme"
        "nts mit der ID progr"
        "ess-bar\r\n"
        "                    "
        "eb(\'progress-bar\')"
        ".innerText = `${data"
        ".TankPerc}%`;\r\n\r"
        "\n"
        "                    "
        "// Aktualisiere die "
        "Breite des Balkens b"
        "asierend auf TankPer"
        "c\r\n"
        "                    "
        "eb(\'progress-bar\')"
        ".style.width = `${da"
        "ta.TankPerc}%`;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob uv_data"
        " definiert ist und a"
        "ktualisiere den Fort"
        "schrittsbalken\r\n"
        "                if ("
        "data.uv_data !== und"
        "efined) {\r\n"
        "                    "
        "// Aktualisiere den "
        "Inhalt des div-Eleme"
        "nts mit der ID progr"
        "ess-bar\r\n"
        "                    "
        "eb(\'status-uv\').in"
        "nerText = `${data.uv"
        "_data}`;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob fog_dat"
        "a definiert ist und "
        "aktualisiere den For"
        "tschrittsbalken\r\n"
        "                if ("
        "data.fog_data !== un"
        "defined) {\r\n"
        "                    "
        "// Aktualisiere den "
        "Inhalt des div-Eleme"
        "nts mit der ID progr"
        "ess-bar\r\n"
        "                    "
        "eb(\'status-fog\').i"
        "nnerText = `${data.f"
        "og_data}`;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob heat_da"
        "ta definiert ist und"
        " aktualisiere den Fo"
        "rtschrittsbalken\r\n"
        "                if ("
        "data.heat_data !== u"
        "ndefined) {\r\n"
        "                    "
        "// Aktualisiere den "
        "Inhalt des div-Eleme"
        "nts mit der ID progr"
        "ess-bar\r\n"
        "                    "
        "eb(\'status-heat\')."
        "innerText = `${data."
        "heat_data} %`;\r\n"
        "                    "
        "eb(\'heat-bar\').val"
        "ue = `${data.heat_da"
        "ta}`;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob heater_"
        "fan_data definiert i"
        "st und aktualisiere "
        "den Fortschrittsbalk"
        "en\r\n"
        "                if ("
        "data.heat_fan_data !"
        "== undefined) {\r\n"
        "                    "
        "// Aktualisiere den "
        "Inhalt des div-Eleme"
        "nts mit der ID progr"
        "ess-bar\r\n"
        "                    "
        "eb(\'status-heater-f"
        "an\').innerText = `$"
        "{data.heat_fan_data}"
        " %`;\r\n"
        "                    "
        "eb(\'heater-fan-bar"
        "\').value = `${data."
        "heat_fan_data}`;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob fan_dat"
        "a definiert ist und "
        "aktualisiere den For"
        "tschrittsbalken\r\n"
        "                if ("
        "data.fan_data !== un"
        "defined) {\r\n"
        "                    "
        "// Aktualisiere den "
        "Inhalt des div-Eleme"
        "nts mit der ID progr"
        "ess-bar\r\n"
        "                    "
        "eb(\'status-fan\').i"
        "nnerText = `${data.f"
        "an_data} %`;\r\n"
        "                    "
        "eb(\'fan-bar\').valu"
        "e = `${data.fan_data"
        "}`;\r\n"
        "                }\r"
        "\n\r\n"
        "            }\r\n"
        "        };\r\n\r\n"
        "            // Öffne"
        " die Anfrage (GET-Re"
        "quest an den Endpoin"
        "t)\r\n"
        "        xhr.open(\'G"
        "ET\', \'/shr\', true"
        ");\r\n\r\n"
        "            // Sende"
        " die Anfrage\r\n"
        "        xhr.send();"
        "\r\n"
        "    }\r\n"
        "        \r\n"
        "    function sendArg"
        "uments(args){\r\n\r"
        "\n"
        "        if (args != "
        "null && typeof args "
        "== \"string\")\r\n"
        "        {\r\n"
        "            const xh"
        "r = new XMLHttpReque"
        "st();\r\n\r\n"
        "            // Öffne"
        " die Anfrage (GET-Re"
        "quest an den Endpoin"
        "t)\r\n"
        "            xhr.open"
        "(\'GET\', \'/shr?\'+"
        "args, true);\r\n\r\n"
        "            // Sende"
        " die Anfrage\r\n"
        "            xhr.send"
        "();\r\n"
        "        }\r\n"
        "    }   \r\n\r\n"
        "    // Rufe fetchDat"
        "a alle 5 Sekunden au"
        "f (5000 Millisekunde"
        "n)\r\n"
        "    setInterval(fetc"
        "hData, 5000);\r\n\r"
        "\n"
        "    // Initialer Auf"
        "ruf der fetchData-Fu"
        "nktion, damit nicht "
        "5 Sekunden auf den e"
        "rsten Aufruf gewarte"
        "t wird\r\n"
        "    fetchData();")

        webserver.content_send (content)
    end

    def show_tank(tank_perc)

       var content = ("    <div id=\"progre"
       "ss-outer-container\""
       " style=\"width: 100%"
       "; background-color: "
       "#e0e0e0; padding: 20"
       "px; border-radius: 1"
       "0px; position: relat"
       "ive; box-shadow: 0 4"
       "px 8px rgba(0, 0, 0,"
       " 0.1); margin-bottom"
       ": 20px;\">\r\n"
       "        <div id=\"la"
       "bel\" style=\"positi"
       "on: absolute; top: 1"
       "0px; left: 10px; fon"
       "t-size: 16px; font-w"
       "eight: bold; color: "
       "black;\">\r\n"
       "            Tankanze"
       "ige\r\n"
       "        </div>\r\n"
       "        <div id=\"pr"
       "ogress-container\" s"
       "tyle=\"width: 98%; "
       "background-color: #f"
       "3f3f3; border-radius"
       ": 5px; overflow: hid"
       "den; margin-top: 40p"
       "x;\">\r\n"
       "            <div id="
       "\"progress-bar\" sty"
       "le=\"width: 45%; hei"
       "ght: 30px; backgroun"
       "d-color: #0071ff; te"
       "xt-align: center; li"
       "ne-height: 30px; col"
       "or: white;\">\r\n"
       "                45%"
       "\r\n"
       "            </div>\r"
       "\n"
       "        </div>\r\n"
       "    </div>")
        webserver.content_send (content)
    end

    def showManualPanel()

        var content = ("<div style=\"width: "
        "100%; margin-bottom:"
        " 20px; background-co"
        "lor: #e0e0e0; paddin"
        "g: 20px; border-radi"
        "us: 10px; overflow: "
        "hidden;\">\r\n"
        "    <!-- Äußerster C"
        "ontainer mit Übersch"
        "rift -->\r\n"
        "    <div style=\"top"
        ": 10px; left:10px; b"
        "ackground-color: #e0"
        "e0e0; font-weight: b"
        "old; color: black; m"
        "argin-bottom: 20px;"
        "\">\r\n"
        "        Manual contr"
        "ol\r\n"
        "    </div>\r\n\r\n"
        "    <!-- Obere Reihe"
        " -->\r\n"
        "    <div style=\"wid"
        "th: 45%; float: left"
        "; margin-right: 7%; "
        "margin-bottom: 20px;"
        "\">\r\n"
        "        <div style="
        "\"border-radius: 10p"
        "x; border: 2px solid"
        " #6f42c1; background"
        "-color: #ffffff; pad"
        "ding: 20px; text-ali"
        "gn: center;\">\r\n"
        "            <h2 styl"
        "e=\"margin-top: 0; c"
        "olor: black;\">UV</h"
        "2>\r\n"
        "            <div id="
        "\"status-uv\" style="
        "\"font-size: 1.5em; "
        "margin-bottom: 15px;"
        " color: black;\">ON<"
        "/div>\r\n"
        "            <button "
        "onclick=\'sendArgume"
        "nts(\"toggle_uv=1\")"
        ";\' style=\"padding:"
        " 10px 20px; font-siz"
        "e: 1em; cursor: poin"
        "ter;\">Toggle</butto"
        "n>\r\n"
        "        </div>\r\n"
        "    </div>\r\n"
        "    <div style=\"wid"
        "th: 45%; float: left"
        "; margin-bottom: 20p"
        "x;\">\r\n"
        "        <div style="
        "\"border-radius: 10p"
        "x; border: 2px solid"
        " #007bff; background"
        "-color: #ffffff; pad"
        "ding: 20px; text-ali"
        "gn: center;\">\r\n"
        "            <h2 styl"
        "e=\"margin-top: 0; c"
        "olor: black;\">Fog</"
        "h2>\r\n"
        "            <div id="
        "\"status-fog\" style"
        "=\"font-size: 1.5em;"
        " margin-bottom: 15px"
        "; color: black;\">ON"
        "</div>\r\n"
        "            <button "
        "onclick=\'sendArgume"
        "nts(\"toggle_fog=1\""
        ");\' style=\"padding"
        ": 10px 20px; font-si"
        "ze: 1em; cursor: poi"
        "nter;\">Toggle</butt"
        "on>\r\n"
        "        </div>\r\n"
        "    </div>\r\n\r\n"
        "    <!-- Untere Reih"
        "e -->\r\n"
        "    <div style=\"wid"
        "th: 45%; float: left"
        "; margin-right: 7%; "
        "margin-bottom: 20px;"
        "\">\r\n"
        "        <div style="
        "\"border-radius: 10p"
        "x; border: 2px solid"
        " #dc3545; background"
        "-color: #ffffff; pad"
        "ding: 20px; text-ali"
        "gn: center;\">\r\n"
        "            <h2 styl"
        "e=\"margin-top: 0; c"
        "olor: black;\">Heat<"
        "/h2>\r\n"
        "            <div sty"
        "le=\"display: flex; "
        "justify-content: spa"
        "ce-between;\">\r\n"
        "                <div"
        " style=\"width: 48%;"
        " text-align: center;"
        "\">\r\n"
        "                    "
        "<h3 style=\"margin-t"
        "op: 0px; color: blac"
        "k; font-size: 1em;\""
        ">Heater</h3>\r\n"
        "                    "
        "<div id=\"status-hea"
        "t\" style=\"font-siz"
        "e: 1.2em; margin-bot"
        "tom: 5px; color: bla"
        "ck;\">33 %</div>\r\n"
        "                    "
        "<input oninput=\'sen"
        "dArguments(\"send_he"
        "at=\" + this.value);"
        "\' id=\"heat-bar\" t"
        "ype=\"range\" min=\""
        "0\" max=\"100\" valu"
        "e=\"33\" style=\"wid"
        "th: 100%; margin: 5p"
        "x auto 0;\">\r\n"
        "                </di"
        "v>\r\n"
        "                <div"
        " style=\"width: 48%;"
        " text-align: center;"
        "\">\r\n"
        "                    "
        "<h3 style=\"margin-t"
        "op: 0px; color: blac"
        "k; font-size: 1em;\""
        ">Heater FAN</h3>\r\n"
        "                    "
        "<div id=\"status-hea"
        "ter-fan\" style=\"fo"
        "nt-size: 1.2em; marg"
        "in-bottom: 5px; colo"
        "r: black;\">50 %</di"
        "v>\r\n"
        "                    "
        "<input oninput=\'sen"
        "dArguments(\"send_he"
        "at_fan=\" + this.val"
        "ue);\' id=\"heater-f"
        "an-bar\" type=\"rang"
        "e\" min=\"0\" max=\""
        "100\" value=\"50\" s"
        "tyle=\"width: 100%; "
        "margin: 5px auto 0;"
        "\">\r\n"
        "                </di"
        "v>\r\n"
        "            </div>\r"
        "\n"
        "        </div>\r\n"
        "    </div>\r\n"
        "    <div style=\"wid"
        "th: 45%; float: left"
        "; margin-bottom: 20p"
        "x;\">\r\n"
        "        <div style="
        "\"border-radius: 10p"
        "x; border: 2px solid"
        " #28a745; background"
        "-color: #ffffff; pad"
        "ding: 20px; text-ali"
        "gn: center;\">\r\n"
        "            <h2 styl"
        "e=\"margin-top: 0; c"
        "olor: black;\">FAN</"
        "h2>\r\n"
        "            <div id="
        "\"status-fan\" style"
        "=\"font-size: 1.5em;"
        " margin-bottom: 20px"
        "; color: black;\">33"
        " %</div>\r\n"
        "                <inp"
        "ut oninput=\'sendArg"
        "uments(\"send_fan=\""
        " + this.value);\' id"
        "=\"fan-bar\" type=\""
        "range\" min=\"0\" ma"
        "x=\"100\" value=\"33"
        "\" style=\"width: ca"
        "lc(100% - 40px); mar"
        "gin-bottom: 40px; au"
        "to 0;\">\r\n"
        "        </div>\r\n"
        "    </div>\r\n"
        "</div>")
        webserver.content_send (content)
    end
end

class ShroomerTank : Driver

    static buffer = []
    var buff_max
    var calibFull
    var calibEmpty
    var tank_data
    var uv_data
    var fog_data
    var heat_data
    var heat_fan_data
    var fan_data
    var MySensors

    def init()
        self.buff_max = 60
        self.calibFull = 10
        self.calibEmpty = 30
        self.tank_data = 55
        self.uv_data = "OFF"
        self.fog_data = "OFF"
        self.heat_data = 0
        self.heat_fan_data = 0
        self.fan_data = 0
    end
   
    def read_my_sensors()
        self.MySensors = json.load(tasmota.read_sensors())
    end
    def tank_do()

        # Read Sensor data needs to be executed before this line!
        if !(self.MySensors.contains('VL53L0X')) return end
        var d = self.MySensors['VL53L0X']['Distance']
        if (d == nil) return 0 end                      #check for null value (too far away)
        
        #print("Dist: ", d)

        if (self.buffer.size() >= self.buff_max) self.buffer.pop(0) end      # remove oldest entry
        self.buffer.push(d)

        d = 0
        for i : 0 .. (self.buffer.size()-1 )               # let's sum all of the entrys
        #print ("I: ",i)
        d = d + self.buffer.item (i)
        end
        
        #print("Buf: ", self.buffer)
        
        d = d / self.buffer.size()                         # average the sensor data
        #print("Dist-avd: ", d)

        var perc = (self.calibEmpty - d) / (self.calibEmpty - self.calibFull) * 100

        #print(perc)
        if (perc > 100)
            perc = 100
        end

        if (perc < 0)
            perc = 0
        end

        self.tank_data = perc

        return self.tank_data

    end

    # ---------------------

    def every_second()
        if !self.tank_do return nil end
        self.read_my_sensors()
        self.tank_do()
        #print (self.tank_data)
    end

    # ---------------------

    def web_sensor()

    end

    # ---------------------

    def json_append()
        #Tankfüllstand in Prozent anfügen
        if !self.tank_data return nil end
        var msg = string.format(",\"TankPerc\":%i",
                  self.tank_data)
        tasmota.response_append(msg)

        #uv-status anfügen
        if !self.uv_data return nil end
        tasmota.response_append(",\"uv_data\":\"" + self.uv_data + "\"")

        #fog-status anfügen
        if !self.fog_data return nil end
        tasmota.response_append(",\"fog_data\":\"" + self.fog_data + "\"")

        #heat-status anfügen
        msg = string.format(",\"heat_data\":%i",
                  self.heat_data)
        tasmota.response_append(msg)

        #heat-fan-status anfügen
        msg = string.format(",\"heat_fan_data\":%i",
                  self.heat_fan_data)
        tasmota.response_append(msg)
        
        #fan-status anfügen
        msg = string.format(",\"fan_data\":%i",
                  self.fan_data)
        tasmota.response_append(msg)
    end

    # --------------------- 
    
    def web_add_handler()
        webserver.on('/shroomer', / -> self.http_get(), webserver.HTTP_GET)
        webserver.on('/shroomer', / -> self.http_post(), webserver.HTTP_POST)
        webserver.on('/shr', / -> self.http_json_endpoint(), webserver.HTTP_GET)
    end

    def http_get()
        webserver.content_start('The Shroomer Web UI')
        MyHttpManager().inject_auotReloadScript()
        webserver.content_send_style()
        MyHttpManager().showManualPanel()
        var tank_str = string.format("%i", self.tank_data)
        MyHttpManager().show_tank(tank_str)
        webserver.content_stop()
    end

    def http_post()
        self.http_get()
    end

    def http_json_endpoint()

        var myval
        # get sensordata and provide through http
        var MysensorData = tasmota.read_sensors()

        var argument = webserver.arg_name(0)

        # test argument for button clicks
        if argument == "toggle_uv"
            if self.uv_data == "OFF"
                self.uv_data = "ON"
            else
                self.uv_data = "OFF"
            end
        end

        if argument == "toggle_fog"
            if self.fog_data == "OFF"
                self.fog_data = "ON"
            else
                self.fog_data = "OFF"
            end
        end

        if argument == "toggle_fan"
            if self.fan_data == "OFF"
                self.fan_data = "ON"
            else
                self.fan_data = "OFF"
            end
        end

        if argument == "send_heat"
            myval = int(webserver.arg(0))
            if myval > 100
                myval = 100
            end

            if myval < 0
                myval = 0
            end
            self.heat_data = myval
        end

        if argument == "send_heat_fan"
            myval = int(webserver.arg(0))
            if myval > 100
                myval = 100
            end

            if myval < 0
                myval = 0
            end
            self.heat_fan_data = myval
        end

        if argument == "send_fan"
            myval = int(webserver.arg(0))
            if myval > 100
                myval = 100
            end

            if myval < 0
                myval = 0
            end
            self.fan_data = myval
        end

        webserver.content_response(MysensorData)

    end

end

shr_tank = ShroomerTank() # instanz erzeugen
tasmota.add_driver(shr_tank) # tasmota treiber anlegen und sekündlich aufrufen
shr_tank.web_add_handler()

#tasmota.remove_driver(shr_tank)
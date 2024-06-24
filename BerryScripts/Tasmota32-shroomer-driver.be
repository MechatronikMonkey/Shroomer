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
        "        function fet"
        "chData() {\r\n"
        "            // Erste"
        "lle eine neue XMLHtt"
        "pRequest\r\n"
        "            const xh"
        "r = new XMLHttpReque"
        "st();\r\n\r\n"
        "            // Defin"
        "iere, was passieren "
        "soll, wenn die Anfra"
        "ge erfolgreich ist\r"
        "\n"
        "            xhr.onre"
        "adystatechange = () "
        "=> {\r\n"
        "                if ("
        "xhr.readyState === 4"
        " && xhr.status === 2"
        "00) {\r\n"
        "                    "
        "// Verarbeite die An"
        "twortdaten\r\n"
        "                    "
        "const data = JSON.pa"
        "rse(xhr.responseText"
        ");\r\n\r\n"
        "                    "
        "// Überprüfe, ob Tan"
        "kPerc definiert ist "
        "und aktualisiere den"
        " Fortschrittsbalken"
        "\r\n"
        "                    "
        "if (data.TankPerc !="
        "= undefined) {\r\n"
        "                    "
        "    // Aktualisiere "
        "den Inhalt des div-E"
        "lements mit der ID p"
        "rogress-bar\r\n"
        "                    "
        "    eb(\'progress-ba"
        "r\').innerText = `${"
        "data.TankPerc}%`;\r"
        "\n"
        "                    "
        "    \r\n"
        "                    "
        "    // Aktualisiere "
        "die Breite des Balke"
        "ns basierend auf Tan"
        "kPerc\r\n"
        "                    "
        "    eb(\'progress-ba"
        "r\').style.width = `"
        "${data.TankPerc}%`;"
        "\r\n"
        "                    "
        "}\r\n"
        "                }\r"
        "\n"
        "            };\r\n\r"
        "\n"
        "            // Öffne"
        " die Anfrage (GET-Re"
        "quest an den Endpoin"
        "t)\r\n"
        "            xhr.open"
        "(\'GET\', \'/shr\', "
        "true);\r\n\r\n"
        "            // Sende"
        " die Anfrage\r\n"
        "            xhr.send"
        "();\r\n"
        "        }\r\n\r\n"
        "        // Rufe fetc"
        "hData alle 2 Sekunde"
        "n auf (2000 Millisek"
        "unden)\r\n"
        "        setInterval("
        "fetchData, 2000);\r"
        "\n\r\n"
        "        // Initialer"
        " Aufruf der fetchDat"
        "a-Funktion, damit ni"
        "cht 2 Sekunden auf d"
        "en ersten Aufruf gew"
        "artet wird\r\n"
        "        fetchData();")

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
       "tyle=\"width: 100%; "
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
        "    <div style=\"pad"
        "ding: 10px; backgrou"
        "nd-color: #e0e0e0; f"
        "ont-weight: bold; co"
        "lor: black; margin-b"
        "ottom: 20px;\">\r\n"
        "        Manual contr"
        "ol\r\n"
        "    </div>\r\n\r\n"
        "    <!-- Obere Reihe"
        " -->\r\n"
        "    <div style=\"wid"
        "th: 45%; float: left"
        "; margin-right: 5%; "
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
        "onclick=\'la(\\\"&m_"
        "toggle_uv=1\\\");\' "
        "style=\"padding: 10p"
        "x 20px; font-size: 1"
        "em; cursor: pointer;"
        "\">Toggle</button>\r"
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
        "onclick=\'la(\\\"&m_"
        "toggle_fog=1\\\");\'"
        " style=\"padding: 10"
        "px 20px; font-size: "
        "1em; cursor: pointer"
        ";\">Toggle</button>"
        "\r\n"
        "        </div>\r\n"
        "    </div>\r\n\r\n"
        "    <!-- Untere Reih"
        "e -->\r\n"
        "    <div style=\"wid"
        "th: 45%; float: left"
        "; margin-right: 5%; "
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
        "            <div id="
        "\"status-heat\" styl"
        "e=\"font-size: 1.5em"
        "; margin-bottom: 15p"
        "x; color: black;\">3"
        "3 %</div>\r\n"
        "            <input o"
        "ninput=\'la(\\\"&m_s"
        "et_heat=1\\\");\' id"
        "=\"heat-bar\" type="
        "\"range\" id=\"heat-"
        "slider\" min=\"0\" m"
        "ax=\"100\" value=\"3"
        "3\" style=\"width: c"
        "alc(100% - 40px); ma"
        "rgin: 10px auto 0;\""
        ">\r\n"
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
        "olor: black;\">FAN E"
        "xt.</h2>\r\n"
        "            <div id="
        "\"status-fan\" style"
        "=\"font-size: 1.5em;"
        " margin-bottom: 15px"
        "; color: black;\">ON"
        "</div>\r\n"
        "            <button "
        "onclick=\'la(\\\"&m_"
        "toggle_fan=1\\\");\'"
        " style=\"padding: 10"
        "px 20px; font-size: "
        "1em; cursor: pointer"
        ";\">Toggle</button>"
        "\r\n"
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
    var fan_data
    var MySensors

    def init()
        self.buff_max = 60
        self.calibFull = 10
        self.calibEmpty = 30
        self.tank_data = 55
        self.uv_data = 0
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
        if !self.tank_data return nil end
        var msg = string.format(",\"TankPerc\":%i",
                  self.tank_data)
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

        # get sensordata and provide through http
        var MysensorData = tasmota.read_sensors()

        var argument = webserver.arg_name(0)
        var uv = string.format("%i", self.uv_data)

        if argument == "toggle_uv"
            self.uv_data = 1
        end

        webserver.content_response(MysensorData + argument + uv)

    end

end

shr_tank = ShroomerTank() # instanz erzeugen
tasmota.add_driver(shr_tank) # tasmota treiber anlegen und sekündlich aufrufen
shr_tank.web_add_handler()

#tasmota.remove_driver(shr_tank)
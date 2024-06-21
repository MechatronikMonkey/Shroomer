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
        "hData alle 5 Sekunde"
        "n auf (5000 Millisek"
        "unden)\r\n"
        "        setInterval("
        "fetchData, 5000);\r"
        "\n\r\n"
        "        // Initialer"
        " Aufruf der fetchDat"
        "a-Funktion, damit ni"
        "cht 5 Sekunden auf d"
        "en ersten Aufruf gew"
        "artet wird\r\n"
        "        fetchData();")

        webserver.content_send (content)
    end

    def show_tank(tank_perc)

       var content = "    <div id=\"progre"
        "ss-container\">\r\n"
        "        <div id=\"pr"
        "ogress-bar\">"+ tank_perc +"%</di"
        "v>\r\n"
        "    </div>\r\n"
        "    <script>\r\n"
        "        // Styling z"
        "ur Laufzeit hinzufüg"
        "en\r\n"
        "        const style "
        "= document.createEle"
        "ment(\'style\');\r\n"
        "        style.textCo"
        "ntent = `\r\n"
        "            #progres"
        "s-container {\r\n"
        "                widt"
        "h: 100%;\r\n"
        "                back"
        "ground-color: #f3f3f"
        "3;\r\n"
        "                bord"
        "er-radius: 5px;\r\n"
        "                over"
        "flow: hidden;\r\n"
        "            }\r\n\r"
        "\n"
        "            #progres"
        "s-bar {\r\n"
        "                widt"
        "h: "+ tank_perc +"%;\r\n"
        "                heig"
        "ht: 30px;\r\n"
        "                back"
        "ground-color: #0071f"
        "f;\r\n"
        "                text"
        "-align: center;\r\n"
        "                line"
        "-height: 30px;\r\n"
        "                colo"
        "r: white;\r\n"
        "            }\r\n"
        "        `;\r\n"
        "        document.hea"
        "d.appendChild(style)"
        ";\r\n\r\n"
        "    </script>";
        webserver.content_send (content)
    end
end

class ShroomerTank : Driver

    static buffer = []
    var buff_max
    var calibFull
    var calibEmpty
    var tank_data

    def init()
        self.buff_max = 60
        self.calibFull = 10
        self.calibEmpty = 30
        self.tank_data = 55
    end
   
    def tank_do()

        # Read Sensor data
        var MySensors = json.load(tasmota.read_sensors())
        if !(MySensors.contains('VL53L0X')) return end
        var d = MySensors['VL53L0X']['Distance']
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
        self.tank_do()
        #print (self.tank_data)
    end

    # ---------------------

    def web_sensor()

        #if !self.tank_data return nil end               # exit if not initialized
        #var msg = string.format(
        #          "Percent Full: %i",
        #          self.tank_data)
        #tasmota.web_send_decimal(msg)
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
        webserver.content_response(MysensorData)
    end

end

shr_tank = ShroomerTank() # instanz erzeugen
tasmota.add_driver(shr_tank) # tasmota treiber anlegen und sekündlich aufrufen
shr_tank.web_add_handler()

#tasmota.remove_driver(shr_tank)
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
import gpio

#SET GPIOs ACCRODING TO SCHEMATIC HERE
var GPIO_HEATER = 6
var GPIO_HEATFAN = 5
var GPIO_UV_LAMP = 3
var GPIO_HUMIDIFIER = 11
var GPIO_FAN = 4
var HUM_HYSTERESIS = 3
# END

class MyHttpManager

    def show_controlBox()
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
        "        Automatic co"
        "ntrol\r\n"
        "    </div>\r\n\r\n"
        "    <!-- Linker Kast"
        "en -->\r\n"
        "    <div style=\"wid"
        "th: 45%; float: left"
        "; margin-right: 7%; "
        "margin-bottom: 20px;"
        " min-width: 360px;\""
        ">\r\n"
        "        <div style="
        "\"border-radius: 10p"
        "x; border: 2px solid"
        " #dc3545; background"
        "-color: #ffffff; pad"
        "ding: 20px; text-ali"
        "gn: center; box-shad"
        "ow: 0 4px 8px rgba(0"
        ", 0, 0, 0.1);\">\r\n"
        "            <div cla"
        "ss=\"slider-containe"
        "r\">\r\n"
        "              <label"
        " class=\"switch\">\r"
        "\n"
        "                    "
        "<input id=\"heat-aut"
        "o-on\" type=\"checkb"
        "ox\" onchange=\'send"
        "Arguments(\"toggle_h"
        "eat_auto=1\");\'>\r"
        "\n"
        "                    "
        "<span class=\"slider"
        "\"></span>\r\n"
        "                </la"
        "bel>\r\n"
        "            </div>\r"
        "\n"
        "            <h2 styl"
        "e=\"margin-top: -20p"
        "x; margin-bottom: 40"
        "px; color: #dc3545;"
        "\">Heat control</h2>"
        "\r\n"
        "            <div sty"
        "le=\"font-size: 1.2e"
        "m; color: black; mar"
        "gin-bottom: 15px;\">"
        "\r\n"
        "                <div"
        " style=\"margin-bott"
        "om: 40px;\">Current "
        "temperature: <span i"
        "d=\"current-temperat"
        "ure\" style=\"positi"
        "on: relative; top: 3"
        "px; left: 7px; font-"
        "weight: bold; font-s"
        "ize: 1.5em;\">25°C</"
        "span></div>\r\n"
        "                <div"
        ">Current setpoint: <"
        "span id=\"setpoint-h"
        "eat\">25°C</span></d"
        "iv>\r\n"
        "            </div>\r"
        "\n"
        "            <div sty"
        "le=\"margin-bottom: "
        "15px; margin-top: 20"
        "px; display: flex; a"
        "lign-items: center; "
        "justify-content: cen"
        "ter;\">\r\n"
        "                <div"
        " id=\"setpoint-dropd"
        "own\" style=\"font-s"
        "ize: 1.2em; color: b"
        "lack;\">Setpoint:</d"
        "iv>\r\n"
        "                <sel"
        "ect id=\"setpoint-dr"
        "opdown-heat\" onchan"
        "ge=\'sendArguments("
        "\"set_heat_point=\" "
        "+ this.value);\' sty"
        "le=\"width: 75px; fo"
        "nt-size: 1em; paddin"
        "g: 5px; border-radiu"
        "s: 5px;\">\r\n"
        "                    "
        "<option value=\"20\""
        ">20°C</option>\r\n"
        "                    "
        "<option value=\"21\""
        ">21°C</option>\r\n"
        "                    "
        "<option value=\"22\""
        ">22°C</option>\r\n"
        "                    "
        "<option value=\"23\""
        ">23°C</option>\r\n"
        "                    "
        "<option value=\"24\""
        ">24°C</option>\r\n"
        "                    "
        "<option value=\"25\""
        ">25°C</option>\r\n"
        "                    "
        "<option value=\"26\""
        ">26°C</option>\r\n"
        "                    "
        "<option value=\"27\""
        ">27°C</option>\r\n"
        "                    "
        "<option value=\"28\""
        ">28°C</option>\r\n"
        "                    "
        "<option value=\"29\""
        ">29°C</option>\r\n"
        "                    "
        "<option value=\"30\""
        ">30°C</option>\r\n"
        "                    "
        "<option value=\"31\""
        ">31°C</option>\r\n"
        "                    "
        "<option value=\"32\""
        ">32°C</option>\r\n"
        "                    "
        "<option value=\"33\""
        ">33°C</option>\r\n"
        "                    "
        "<option value=\"34\""
        ">34°C</option>\r\n"
        "                    "
        "<option value=\"35\""
        ">35°C</option>\r\n"
        "                </se"
        "lect>\r\n"
        "            </div>\r"
        "\n"
        "        </div>\r\n"
        "    </div>\r\n\r\n"
        "    <!-- Rechter Kas"
        "ten -->\r\n"
        "    <div style=\"wid"
        "th: 45%; float: left"
        "; margin-bottom: 20p"
        "x; min-width: 360px;"
        "\">\r\n"
        "        <div style="
        "\"border-radius: 10p"
        "x; border: 2px solid"
        " #007bff; background"
        "-color: #ffffff; pad"
        "ding: 20px; text-ali"
        "gn: center; box-shad"
        "ow: 0 4px 8px rgba(0"
        ", 0, 0, 0.1);\">\r\n"
        "            <div cla"
        "ss=\"slider-containe"
        "r\">\r\n"
        "              <label"
        " class=\"switch\">\r"
        "\n"
        "                    "
        "<input id=\"hum-auto"
        "-on\" type=\"checkbo"
        "x\" onchange=\'sendA"
        "rguments(\"toggle_hu"
        "m_auto=1\");\'>\r\n"
        "                    "
        "<span class=\"slider"
        "\"></span>\r\n"
        "                </la"
        "bel>\r\n"
        "            </div>\r"
        "\n"
        "            <h2 styl"
        "e=\"margin-top: -20p"
        "x; margin-bottom: 40"
        "px; color: #007bff;"
        "\">Humidity control<"
        "/h2>\r\n"
        "            <div sty"
        "le=\"font-size: 1.2e"
        "m; color: black; mar"
        "gin-bottom: 15px;\">"
        "\r\n"
        "                <div"
        " style=\"margin-bott"
        "om: 40px;\">Current "
        "RH: <span id=\"curre"
        "nt-hum\" style=\"pos"
        "ition: relative; top"
        ": 3px; left: 7px; fo"
        "nt-weight: bold; fon"
        "t-size: 1.5em;\">55 "
        "%</span></div>\r\n"
        "                <div"
        ">Current setpoint: <"
        "span id=\"setpoint-h"
        "um\">55 %</span></di"
        "v>\r\n"
        "            </div>\r"
        "\n"
        "            <div sty"
        "le=\"margin-bottom: "
        "15px; margin-top: 20"
        "px; display: flex; a"
        "lign-items: center; "
        "justify-content: cen"
        "ter;\">\r\n"
        "                <div"
        " id=\"setpoint-dropd"
        "own\" style=\"font-s"
        "ize: 1.2em; color: b"
        "lack;\">Setpoint:</d"
        "iv>\r\n"
        "                <sel"
        "ect id=\"setpoint-dr"
        "opdown-hum\" onchang"
        "e=\'sendArguments(\""
        "set_hum_point=\" + t"
        "his.value);\' style="
        "\"width: 75px; font-"
        "size: 1em; padding: "
        "5px; border-radius: "
        "5px;\">\r\n"
        "                    "
        "<option value=\"85\""
        ">85 %</option>\r\n"
        "                    "
        "<option value=\"86\""
        ">86 %</option>\r\n"
        "                    "
        "<option value=\"87\""
        ">87 %</option>\r\n"
        "                    "
        "<option value=\"88\""
        ">88 %</option>\r\n"
        "                    "
        "<option value=\"89\""
        ">89 %</option>\r\n"
        "                    "
        "<option value=\"90\""
        ">90 %</option>\r\n"
        "                    "
        "<option value=\"91\""
        ">91 %</option>\r\n"
        "                    "
        "<option value=\"92\""
        ">92 %</option>\r\n"
        "                    "
        "<option value=\"93\""
        ">93 %</option>\r\n"
        "                    "
        "<option value=\"94\""
        ">94 %</option>\r\n"
        "                    "
        "<option value=\"95\""
        ">95 %</option>\r\n"
        "                    "
        "<option value=\"96\""
        ">96 %</option>\r\n"
        "                    "
        "<option value=\"97\""
        ">97 %</option>\r\n"
        "                    "
        "<option value=\"98\""
        ">98 %</option>\r\n"
        "                </se"
        "lect>\r\n"
        "            </div>\r"
        "\n"
        "        </div>\r\n"
        "    </div>\r\n"
        "</div>\r\n"
        "<!-- Stile für Slide"
        "r und Switches -->\r"
        "\n"
        "<div style=\"display"
        ": none;\">\r\n"
        "    <style>\r\n"
        "        .slider-cont"
        "ainer {\r\n"
        "            position"
        ": relative;\r\n"
        "            width: 1"
        "00%;\r\n"
        "            height: "
        "100%;\r\n"
        "            display:"
        " flex;\r\n"
        "            justify-"
        "content: flex-start;"
        "\r\n"
        "            align-it"
        "ems: flex-start;\r\n"
        "        }\r\n"
        "        \r\n"
        "        .switch {\r"
        "\n"
        "            position"
        ": relative;\r\n"
        "            display:"
        " inline-block;\r\n"
        "            width: 6"
        "0px;\r\n"
        "            height: "
        "34px;\r\n"
        "        }\r\n\r\n"
        "        .switch inpu"
        "t {\r\n"
        "            opacity:"
        " 0;\r\n"
        "            width: 0"
        ";\r\n"
        "            height: "
        "0;\r\n"
        "        }\r\n\r\n"
        "        .slider {\r"
        "\n"
        "            position"
        ": absolute;\r\n"
        "            cursor: "
        "pointer;\r\n"
        "            top: -10"
        "px;\r\n"
        "            left: -1"
        "0px;\r\n"
        "            width: 6"
        "0px;\r\n"
        "            height: "
        "34px;\r\n"
        "            backgrou"
        "nd-color: #ccc;\r\n"
        "            transiti"
        "on: .4s;\r\n"
        "            border-r"
        "adius: 34px;\r\n"
        "        }\r\n\r\n"
        "        .slider:befo"
        "re {\r\n"
        "            position"
        ": absolute;\r\n"
        "            content:"
        " \"\";\r\n"
        "            height: "
        "26px;\r\n"
        "            width: 2"
        "6px;\r\n"
        "            left: 4p"
        "x;\r\n"
        "            bottom: "
        "4px;\r\n"
        "            backgrou"
        "nd-color: white;\r\n"
        "            transiti"
        "on: .4s;\r\n"
        "            border-r"
        "adius: 50%;\r\n"
        "        }\r\n\r\n"
        "        input:checke"
        "d + .slider {\r\n"
        "            backgrou"
        "nd-color: #2196F3;\r"
        "\n"
        "        }\r\n\r\n"
        "        input:checke"
        "d + .slider:before {"
        "\r\n"
        "            transfor"
        "m: translateX(26px);"
        "\r\n"
        "        }\r\n"
        "    </style>\r\n"
        "</div>")

        webserver.content_send (content)
    end

    def inject_auotReloadScript()
        var content = ("    // Funktion, die"
        " die Daten per AJAX "
        "abruft\r\n"
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
        ".TankPerc} %`;\r\n\r"
        "\n"
        "                    "
        "// Aktualisiere die "
        "Breite des Balkens b"
        "asierend auf TankPer"
        "c\r\n"
        "                    "
        "eb(\'progress-bar\')"
        ".style.width = `${da"
        "ta.TankPerc} %`;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob uv_data"
        " definiert ist und a"
        "ktualisiere\r\n"
        "                if ("
        "data.uv_data !== und"
        "efined) {\r\n"
        "                    "
        "\r\n"
        "                    "
        "eb(\'status-uv\').in"
        "nerText = `${data.uv"
        "_data}`;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob fog_dat"
        "a definiert ist und "
        "aktualisiere\r\n"
        "                if ("
        "data.fog_data !== un"
        "defined) {\r\n"
        "                    "
        "\r\n"
        "                    "
        "eb(\'status-fog\').i"
        "nnerText = `${data.f"
        "og_data}`;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob heat_da"
        "ta definiert ist und"
        " aktualisiere \r\n"
        "                if ("
        "data.heat_data !== u"
        "ndefined) {\r\n"
        "                    "
        "\r\n"
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
        "\r\n"
        "                if ("
        "data.heat_fan_data !"
        "== undefined) {\r\n"
        "                    "
        "\r\n"
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
        "aktualisiere \r\n"
        "                if ("
        "data.fan_data !== un"
        "defined) {\r\n"
        "                    "
        "\r\n"
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
        "                // Ü"
        "berprüfe, ob heat_se"
        "tpoint definiert ist"
        " und aktualisiere \r"
        "\n"
        "                if ("
        "data.heat_setpoint !"
        "== undefined) {\r\n"
        "                    "
        "\r\n"
        "                    "
        "eb(\'setpoint-heat\'"
        ").innerText = `${dat"
        "a.heat_setpoint} °C`"
        ";\r\n"
        "                    "
        "eb(\'setpoint-dropdo"
        "wn-heat\').value = `"
        "${data.heat_setpoint"
        "}`;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob heat_au"
        "to_on definiert ist "
        "und aktualisiere \r"
        "\n"
        "                if ("
        "data.heat_auto_on !="
        "= undefined) {\r\n"
        "                    "
        "eb(\'heat-auto-on\')"
        ".checked = data.heat"
        "_auto_on;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob hum_set"
        "point definiert ist "
        "und aktualisiere \r"
        "\n"
        "                if ("
        "data.hum_setpoint !="
        "= undefined) {\r\n"
        "                    "
        "\r\n"
        "                    "
        "eb(\'setpoint-hum\')"
        ".innerText = `${data"
        ".hum_setpoint} %`;\r"
        "\n"
        "                    "
        "eb(\'setpoint-dropdo"
        "wn-hum\').value = `$"
        "{data.hum_setpoint}`"
        ";\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob hum_aut"
        "o_on definiert ist u"
        "nd aktualisiere \r\n"
        "                if ("
        "data.hum_auto_on !=="
        " undefined) {\r\n"
        "                    "
        "eb(\'hum-auto-on\')."
        "checked = data.hum_a"
        "uto_on;\r\n"
        "                }\r"
        "\n\r\n"
        "                // Ü"
        "berprüfe, ob Tempera"
        "turen definiert sind"
        " und aktualisiere \r"
        "\n"
        "                if ("
        "data.temp_calc !== u"
        "ndefined ) {\r\n\r\n"
        "                    "
        "eb(\'current-tempera"
        "ture\').innerText = "
        "`${data.temp_calc} °"
        "C`; \r\n"
        "                \r\n"
        "                }\r"
        "\n"
        "                    "
        "            \r\n"
        "                // Ü"
        "berprüfe, ob RH defi"
        "niert ist und aktual"
        "isiere \r\n"
        "                if ("
        "data.AHT2X.Humidity "
        "!== undefined) {\r\n"
        "\r\n"
        "                    "
        "eb(\'current-hum\')."
        "innerText = `${data."
        "AHT2X.Humidity} %`; "
        "\r\n"
        "                }\r"
        "\n"
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

       var content = ("<div id=\"progress-o"
       "uter-container\" sty"
       "le=\"width: 100%; ba"
       "ckground-color: #e0e"
       "0e0; padding: 20px; "
       "border-radius: 10px;"
       " position: relative;"
       " box-shadow: 0 4px 8"
       "px rgba(0, 0, 0, 0.1"
       "); margin-bottom: 20"
       "px;\">\r\n"
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
       "tyle=\"width: 98%; b"
       "ackground-color: whi"
       "te; border-radius: 5"
       "px; overflow: hidden"
       "; margin-top: 40px; "
       "margin-bottom: 10px;"
       "\">\r\n"
       "            <div id="
       "\"progress-bar\" sty"
       "le=\"width: 45%; hei"
       "ght: 30px; backgroun"
       "d-color: #0071ff; te"
       "xt-align: center; li"
       "ne-height: 30px; col"
       "or: black;\">\r\n"
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
        " min-width:340px;\">"
        "\r\n"
        "        <div style="
        "\"border-radius: 10p"
        "x; border: 2px solid"
        " #9c24ff; background"
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
        "x; min-width:340px;"
        "\">\r\n"
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
        " min-width:340px;\">"
        "\r\n"
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
        "x; min-width:340px;"
        "\">\r\n"
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
        "gin-bottom: 40px aut"
        "o 0;\">\r\n"
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
    var heat_setpoint
    var heat_auto_on
    var hum_setpoint
    var hum_auto_on
    var MySensors
    var temp_calc
    var hum_calc

    def init()
        self.buff_max = 120
        self.calibFull = 9
        self.calibEmpty = 16
        self.tank_data = 55
        self.uv_data = "OFF"
        self.fog_data = "OFF"
        self.heat_data = 0
        self.heat_fan_data = 0
        self.fan_data = 0
        self.heat_setpoint = 24
        self.heat_auto_on = 0
        self.hum_setpoint = 85
        self.hum_auto_on = 0
        self.temp_calc = 0
        self.hum_calc = 0
    end
   
    def read_my_sensors()
        self.MySensors = json.load(tasmota.read_sensors())

        # Calc Temperature
        if !(self.MySensors.contains('AHT2X')) return end
        var d = self.MySensors['AHT2X']['Temperature']
        if (d == nil) return 0 end                      #check for null value (too far away)

        self.temp_calc = d * 0.59 + 9.75

        # Calc Humidity
        d = self.MySensors['AHT2X']['Humidity']
        if (d == nil) return 0 end
        
        self.hum_calc = d
    end

    def tank_do()
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

    def humidity_control_do()

        if !(self.hum_auto_on) return end  #leafe if control is not enabled

        if (self.hum_calc < (self.hum_setpoint - HUM_HYSTERESIS))
            self.fog_data = "ON"
            self.heat_fan_data = 100
        end

        if (self.hum_calc > (self.hum_setpoint + HUM_HYSTERESIS))
            self.fog_data = "OFF"
            self.heat_fan_data = 0
        end

        if (self.hum_calc >= 100)
            self.fog_data = "OFF"
            self.heat_fan_data = 0
        end

    end

    def update_gpios()

        #update IOs according to internal states
        #this also updates the PID controller outputs!

        if (self.uv_data == "OFF")
            gpio.digital_write(GPIO_UV_LAMP, gpio.LOW)
        else
            gpio.digital_write(GPIO_UV_LAMP, gpio.HIGH)
        end

        if (self.fog_data == "OFF")
            gpio.digital_write(GPIO_HUMIDIFIER, gpio.LOW)
        else
            gpio.digital_write(GPIO_HUMIDIFIER, gpio.HIGH)
        end

        var duty = 0

        #calculate dutycycle for heater and set it
        duty = int(self.heat_data * 10.23)
        gpio.set_pwm(GPIO_HEATER,duty)

        #calculate dutycycle for heater fan and set it
        duty = int(self.heat_fan_data * 10.23)
        gpio.set_pwm(GPIO_HEATFAN,duty)

        #calculate dutycycle for fan and set it
        duty = int(self.fan_data * 10.23)
        gpio.set_pwm(GPIO_FAN,duty)

    end

    # ---------------------

    def every_second()
        # update tank data every second
        if !self.tank_do return nil end
        self.tank_do()
        #print (self.tank_data)
    end

    def every_250ms()

        self.read_my_sensors()
        self.humidity_control_do()
        self.update_gpios()

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

        #heat-setpoint anfügen
        msg = string.format(",\"heat_setpoint\":%i",
                  self.heat_setpoint)
        tasmota.response_append(msg)

        #heat-auto-on anfügen
        msg = string.format(",\"heat_auto_on\":%i",
                  self.heat_auto_on)
        tasmota.response_append(msg)

        #hum-setpoint anfügen
        msg = string.format(",\"hum_setpoint\":%i",
                  self.hum_setpoint)
        tasmota.response_append(msg)

        #hum-auto-on anfügen
        msg = string.format(",\"hum_auto_on\":%i",
                  self.hum_auto_on)
        tasmota.response_append(msg)

        #temp_calc anfügen
        msg = string.format(",\"temp_calc\":%.2f",
        self.temp_calc)
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
        MyHttpManager().show_controlBox()
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

        if argument == "set_heat_point"
            myval = int(webserver.arg(0))
            if myval > 35
                myval = 35
            end

            if myval < 20
                myval = 20
            end
            self.heat_setpoint = myval
        end

        if argument == "toggle_heat_auto"
            if self.heat_auto_on == 0
                self.heat_auto_on = 1
            else
                self.heat_auto_on = 0
            end
        end

        if argument == "set_hum_point"
            myval = int(webserver.arg(0))
            if myval > 98
                myval = 98
            end

            if myval < 85
                myval = 85
            end
            self.hum_setpoint = myval
        end

        if argument == "toggle_hum_auto"
            if self.hum_auto_on == 0
                self.hum_auto_on = 1
            else
                self.hum_auto_on = 0
            end
        end

        webserver.content_response(MysensorData)

    end

end

shr_tank = ShroomerTank() # instanz erzeugen
tasmota.add_driver(shr_tank) # tasmota treiber anlegen und sekündlich aufrufen
shr_tank.web_add_handler()

#tasmota.remove_driver(shr_tank)
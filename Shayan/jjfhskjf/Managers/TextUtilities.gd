extends Node







const COLOR_CONVERSION_LIST = {
    "BLUE(": "[color=2180f2]", 
    "YELLOW(": "[color=e5bf46]", 
    "RED(": "[color=d43a2b]", 
    "GREEN(": "[color=49b644]", 
    "PURPLE(": "[color=a651b6]", 
    "WHITE(": "[color=f7fff8]", 
    ")": "[/color]"
}

const FONT_LIST = {
    "BIG!": "[font_size={20}]", 
    "SMALL!": "[font_size={16}]", 
    "TINY!": "[font_size={14}]", 
    "!": "[/font_size]"
}

const ICON_LIST = {
    "S_ICON": "[img]res://Art/Score Icon Tiny.png[/img]", 
    "O_ICON": "[img]res://Art/Ore Icon Tiny.png[/img]", 
    "E_ICON": "[img]res://Art/Energy Icon Tiny.png[/img]"
}

func center(text: String) -> String: return str("[center]", text, "[/center]")

func font_sizes(text: String) -> String:
    var new_text: = text
    for FONT_TYPE in FONT_LIST.keys():
        new_text = new_text.replace(FONT_TYPE, FONT_LIST[FONT_TYPE])
    return new_text

func add_colors(text: String) -> String:
    var new_text: = text
    for COLOR_TYPE in COLOR_CONVERSION_LIST.keys():
        new_text = new_text.replace(COLOR_TYPE, COLOR_CONVERSION_LIST[COLOR_TYPE])
    return new_text

func add_icons(text: String) -> String:
    var new_text: = text
    for ICON_TYPE in ICON_LIST.keys():
        new_text = new_text.replace(ICON_TYPE, ICON_LIST[ICON_TYPE])
    return new_text

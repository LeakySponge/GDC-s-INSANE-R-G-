extends Control

@onready var nodes: Control = $Nodes

func _ready() -> void :
    SignalBus.map_entered.emit()

    for node: TextureButton in nodes.get_children():
        node.disabled = true
        node.visible = false

    for i in GameLogic.expedition_number + 1:
        nodes.get_child(i).visible = true

    nodes.get_child(GameLogic.expedition_number).enable()

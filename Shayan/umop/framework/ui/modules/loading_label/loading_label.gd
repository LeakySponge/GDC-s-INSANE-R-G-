extends MarginContainer

@export var duration := 0.5

var _labels: = []
var _index: = 0

@onready var label_container: = $LabelContainer
@onready var timer: = $Timer



func _ready() -> void :
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

	_labels = label_container.get_children()
	_set_label_index(0)

	timer.wait_time = duration
	timer.start()



func _set_label_index(new_index: int) -> void :
	_index = new_index % _labels.size()
	for i in _labels.size():
		_labels[i].visible = i == _index



func _on_timer_timeout() -> void :
	_set_label_index(_index + 1)

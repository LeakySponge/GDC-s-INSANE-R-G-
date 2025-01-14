extends Node2D

@export var trans_time := 0.25

var going: = true

@onready var tween: = $Tween



func _on_Timer_timeout():
	
	
	
	
	

	if going:
		tween.interpolate_property($A / Key, "modulate", Color(1, 1, 1, 0), Color.WHITE, trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property($W / Key, "modulate", Color(1, 1, 1, 0), Color.WHITE, trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property($S / Key, "modulate", Color(1, 1, 1, 0), Color.WHITE, trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property($D / Key, "modulate", Color(1, 1, 1, 0), Color.WHITE, trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property($Space / Key, "modulate", Color(1, 1, 1, 0), Color.WHITE, trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.interpolate_property($A / Key, "modulate", Color.WHITE, Color(1, 1, 1, 0), trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property($W / Key, "modulate", Color.WHITE, Color(1, 1, 1, 0), trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property($S / Key, "modulate", Color.WHITE, Color(1, 1, 1, 0), trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property($D / Key, "modulate", Color.WHITE, Color(1, 1, 1, 0), trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property($Space / Key, "modulate", Color.WHITE, Color(1, 1, 1, 0), trans_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()

	going = not going

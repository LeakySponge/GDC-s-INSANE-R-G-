extends Control


func _on_back_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_back_pressed() -> void :
    get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
    AudioBus.button_clicked.emit()

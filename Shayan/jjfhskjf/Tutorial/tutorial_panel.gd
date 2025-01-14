extends Control

@onready var counter: RichTextLabel = $Panel / MarginContainer / Counter

@onready var forward: Button = $Panel / MarginContainer / Forward
@onready var back: Button = $Panel / MarginContainer / Back

@onready var skip: Button = $Panel / MarginContainer / Skip

@onready var finish: Button = $Panel / MarginContainer / Finish

@onready var pages: Control = $Pages

var page: = 1
const page_count: = 8

func _ready() -> void :
    change_page(1)

func _on_back_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()
func _on_forward_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()
func _on_skip_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()
func _on_finish_mouse_entered() -> void :
    AudioBus.button_mouse_over.emit()

func _on_back_pressed() -> void :
    AudioBus.button_clicked.emit()
    change_page(page - 1)

func _on_forward_pressed() -> void :
    AudioBus.button_clicked.emit()
    change_page(page + 1)

func _on_skip_pressed() -> void :
    AudioBus.button_clicked.emit()
    finish_tutorial()

func _on_finish_pressed() -> void :
    AudioBus.button_clicked.emit()
    finish_tutorial()

func change_page(index: int):
    page = clamp(index, 1, page_count)

    hide_pages()
    show_page(page)

    counter.text = str("BLUE(", page, ")/", page_count, "")
    counter.text = TextUtilities.add_colors(counter.text)

    if page == 1:
        back.visible = false
        skip.visible = true
    elif page == page_count:
        finish.visible = true
        forward.visible = false
    else:
        skip.visible = false
        finish.visible = false
        back.visible = true
        forward.visible = true

func show_page(index: int): pages.get_child(index - 1).visible = true
func hide_pages(): for page: Control in pages.get_children(): page.visible = false

func finish_tutorial():
    skip.disabled = true
    finish.disabled = true
    forward.disabled = true
    back.disabled = true

    SignalBus.tutorial_finished.emit()

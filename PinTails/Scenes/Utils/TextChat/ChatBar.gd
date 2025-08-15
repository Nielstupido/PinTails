extends Control


@onready var chat_entry_scene = preload("res://Scenes/Utils/TextChat/ChatEntry.tscn")
@onready var chatbox = $ChatBox
@onready var convo_container = $ChatBox/ChatViewBox/ScrollContainer/Control/ConvoContainer
@onready var chat_entry_text = $ChatBox/ChatEntryBox/Label/TextEdit


func _ready():
	chatbox.custom_minimum_size = Vector2.ZERO
	chatbox.size = Vector2((get_viewport_rect().size.x / 3), (get_viewport_rect().size.y / 3.5))
	chatbox.anchors_preset = PRESET_BOTTOM_LEFT
	chatbox.position = Vector2(15.0, (get_viewport_rect().size.y - (chatbox.size.y + 15.0)))
	
	_add_msg("test")
	_add_msg("test chat 1")
	_add_msg("test chat 2")
	_add_msg("test chat 3")


func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		if chat_entry_text.has_focus():
			chat_entry_text.release_focus()
		else:
			chat_entry_text.grab_focus()


func _add_msg(chat_text : String):
	var chat_obj = chat_entry_scene.instantiate()
	chat_obj.text = chat_text
	convo_container.add_child(chat_obj)

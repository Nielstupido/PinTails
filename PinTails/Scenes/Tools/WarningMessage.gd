extends Control


var msg_timer = 5.0
@onready var timer = $Timer
@onready var text_node = $RichTextLabel


func _ready():
	text_node.hide()


func set_warning_msg(msg : String) -> void:
	text_node.text = "[center]" + msg
	text_node.show()
	timer.stop()
	timer.start(msg_timer)


func _on_timer_timeout():
	text_node.hide()

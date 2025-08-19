extends Node


signal on_chat_sent(text_chat)
var text_chat_history : PackedStringArray


@rpc("any_peer", "call_local", "reliable")
func send_chat(username : String, text_chat : String) -> void:
	on_chat_sent.emit(text_chat)
	var full_str = username + " : " + text_chat
	text_chat_history.append(full_str)

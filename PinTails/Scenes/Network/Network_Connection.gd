extends Node

const KEY = "pintails_network"
var _session : NakamaSession
var _client = NAKAMA.create_client(KEY, "127.0.0.1", 7350, "http")
var player_account


func authenticate_player_async(is_new_player : bool, email : String, password : String) -> String:
	var result = "Success" 
	
	_session = await _client.authenticate_email_async(email, password, null, is_new_player)
	
	if _session.is_exception():
		result = _session.get_exception().message
		print("An error occurred: %s" % _session)
	else:
		player_account = await _client.get_account_async(_session)
		print("Successfully authenticated: %s" % _session)
	
	return result

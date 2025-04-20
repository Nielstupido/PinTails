class_name NetworkManager 
extends Node

signal close_client_after_quit_signal(peer_id)
const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var server_peer: ENetMultiplayerPeer
var client_peer: ENetMultiplayerPeer



func _ready():
	if OS.has_feature("dedicated_server") || GameplayManager.server_mode_selected:
		_on_host_pressed()
		close_client_after_quit_signal.connect(_close_client_after_quit)	
		
		# We still need this callback in case the host client quits
		if GameplayManager.local_host_mode:
			multiplayer.server_disconnected.connect(_on_server_disconnected) # only emitted on clients
	
	else:
		_on_client_pressed()
		multiplayer.server_disconnected.connect(_on_server_disconnected) # only emitted on clients


func _on_host_pressed():
	print("host pressed")
	server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = server_peer
	start_game()


func _on_client_pressed():
	print("client pressed")
	client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer
	start_game()


func start_game():
	if multiplayer.is_server():
		change_map.call_deferred(load(GameplayManager.selected_map))


func change_map(scene: PackedScene):
	var map = $"../Map"
	for c in map.get_children():
		map.remove_child(c)
		c.queue_free() 
	
	map.add_child(scene.instantiate())


# Should be only used server side
func _close_client_after_quit(peer_id):
	if multiplayer.is_server() && server_peer:
		print("_close_client_after_quit: disconnecting peer: %s " % [str(peer_id)])
		if peer_id == 1: # for when a peer is in host mode
			server_peer.close()
		else:
			server_peer.disconnect_peer(peer_id)


# This is hit when a client disconnects, on the client that disconnected. Also, if the server crashes
# or disconnects, it is also hit
func _on_server_disconnected():
	# client side move to game over state
	GameplayManager.load_game_over_scene()
 

func _exit_tree():
	multiplayer.server_disconnected.disconnect(_on_server_disconnected)

extends Control

enum Screens {
	MAIN,
	LOGIN,
	SETTINGS,
	SHOP,
	ACCOUNT
}

@onready var warning_msg = $WarningMessage
@onready var node_animator = $NodeAnimator
var _current_screen : Screens
var _current_screen_has_bg : bool

var screen_nodes = {
	Screens.MAIN : "PanelContainer/PanelContainer/Menu",
	Screens.LOGIN : "Settings",
	Screens.SETTINGS : "Settings/MainPanel",
	Screens.SHOP : "PanelContainer/PanelContainer/Shop/MainPanel",
	Screens.ACCOUNT : "Settings",
}


func _ready():
	_current_screen = Screens.MAIN
	_current_screen_has_bg = false


func _on_PlayBtn_pressed():
	MatchManager.start_matchmaking(PlayerAccount.username)
	#GameplayManager.server_mode_selected = false
	GameplayManager.server_mode_selected = true


func _on_ExitBtn_pressed():
	get_tree().quit()


func _on_visibility_changed():
	if self.visible and PlayerAccount.username:
		pass


func _on_deathmatch_pressed():
	GameplayManager.server_mode_selected = true
	GameplayManager.load_game_play_scene()


func _on_capture_flag_pressed():
	GameplayManager.server_mode_selected = false
	GameplayManager.load_game_play_scene()


func _on_zone_domination_pressed():
	pass #Replace with function body.


func _change_screen(target_node : Screens, has_target_node_bg : bool):
	if target_node == _current_screen:
		return
	
	_toggle_node(_current_screen, _current_screen_has_bg, false, true)
	_toggle_node(target_node, has_target_node_bg, true, false)
	_current_screen = target_node
	_current_screen_has_bg = has_target_node_bg


func _toggle_node(target_node : Screens, has_target_node_bg : bool, do_open : bool, on_transition : bool):
	if do_open:
		node_animator.open_node(get_node(screen_nodes[target_node]), 
			get_node(screen_nodes[target_node]).get_parent() if has_target_node_bg else null)
	else:
		node_animator.close_node(get_node(screen_nodes[target_node]), 
			on_transition, get_node(screen_nodes[target_node]).get_parent() if has_target_node_bg else null)

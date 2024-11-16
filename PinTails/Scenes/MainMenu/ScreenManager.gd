extends Node

enum Screens {
	LOGIN,
	MENU,
	SETTINGS,
	SHOP,
	ACCOUNT
}

var screen_nodes = {
	Screens.LOGIN : "../LoginScreen",
	Screens.MENU : "../Menu",
	Screens.SETTINGS : "../LoginScreen",
	Screens.SHOP : "../LoginScreen",
	Screens.ACCOUNT : "../LoginScreen",
}


func change_screen(target_screen : Screens, current_screen : Node) -> void:
	get_node(screen_nodes[target_screen]).show()
	current_screen.hide()

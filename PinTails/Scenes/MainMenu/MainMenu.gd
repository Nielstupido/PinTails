extends Node

enum Screens {
	LOGIN,
	MENU,
	SETTINGS,
	SHOP,
	ACCOUNT
}

@onready var warning_msg = $WarningMessage
@onready var screen_manager = $ScreenManager


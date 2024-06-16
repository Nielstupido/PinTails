extends Control


onready var cam = get_node("../Camroot")


func _ready():
	pass


func open_buy_menu():
	self.show()
	get_parent().buy_menu = true
	cam.set_process_input(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_CloseBuyMenuBtn_pressed():
	self.hide()
	get_parent().buy_menu = false
	cam.set_process_input(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func buy_weapon(weapon_tag):
	match(weapon_tag):
		1:
			owner.add_weapon(owner.Weapons.PISTOL, GAME.get_gun_id())
		2:
			owner.add_weapon(owner.Weapons.RIFLE, GAME.get_gun_id())


func _on_PistolBuyBtn_pressed():
	buy_weapon(1)


func _on_RifleBuyBtn_pressed():
	buy_weapon(2)

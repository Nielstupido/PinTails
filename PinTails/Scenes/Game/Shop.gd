extends CanvasLayer


@onready var weapon_inventory = $"../../WeaponInventory"
@export var pistol_data : WeaponData
@export var rifle_data : WeaponData


func open_buy_menu():
	self.show()
	owner.is_looking_around_paused = true
	owner.camera.set_process_input(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_CloseBuyMenuBtn_pressed():
	self.hide()
	owner.is_looking_around_paused = false
	owner.camera.set_process_input(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_PistolBuyBtn_pressed():
	weapon_inventory.add_weapon(pistol_data)


func _on_RifleBuyBtn_pressed():
	weapon_inventory.add_weapon(rifle_data)

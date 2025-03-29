class_name ShopItem
extends Button


var item_name : String
var item_price : float
var item_category : Weapons.Weapon_Types
var item_image : Image
var shop_node : Node


func _pressed():
	shop_node.toggle_preview_item(true, self) #(do_open, item)


func prep_item(name : String, price : float, image : Image):
	self.item_name = name
	self.item_price = price
	self.item_image = image

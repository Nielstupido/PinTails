extends Node


@onready var node_animator = $"../../../NodeAnimator"
@onready var item_preview = $ItemPreview
@onready var item_catalog = $Catalog
@onready var featured_items = $MainPanel
var pistol_items : Array
var shotgun_items : Array
var smg_items : Array
var rifle_items : Array
var sniper_items : Array
var heavy_gun_items : Array
var shop_item_list : Dictionary = {}
var current_selected_item : ShopItem

var item_nodes = {
	Weapons.Weapon_Types.PISTOL : pistol_items,
	Weapons.Weapon_Types.SHOTGUN : shotgun_items,
	Weapons.Weapon_Types.SMG : smg_items,
	Weapons.Weapon_Types.RIFLE : rifle_items,
	Weapons.Weapon_Types.SNIPER : sniper_items,
	Weapons.Weapon_Types.HEAVY_GUN : heavy_gun_items,
}


func segregate_items(item_list : Dictionary) -> void:
	for item in item_list:
		item.shop_node = self
		item_nodes[item.item_category].append(item)


func open_item_catalog() -> void:
	node_animator.close_node(featured_items, true, null)
	node_animator.open_node(item_catalog, null)


func close_shop_panel() -> void:
	node_animator.close_node(item_catalog, true, null)
	node_animator.open_node(featured_items, null)


func on_item_purchased() -> void:
	toggle_preview_item(false)


func toggle_preview_item(do_open : bool, item : ShopItem = null) -> void:
	if do_open:
		current_selected_item = item 
		node_animator.open_node(item_preview, null)
	else:
		node_animator.close_node(item_preview, false, null)

extends Control


onready var title_node = $Control/Title
onready var attrb_node = $Control/Atrribs
onready var tail_btn : Button = $Control/Button
onready var blank_card = $BlankCard
var tail_config_menu
var tail_data : TailData


func _ready():
	if "TailMenuHolder" in self.get_parent().name:
		self.tail_btn.disabled = true
		self.get_parent().get_node("Button").connect("pressed", self, "_on_remove_tail")
		tail_config_menu = owner.get_node("UI/TailConfigMenu")
		tail_data = null


func prepare_tail_card(passed_tail_data):
	if passed_tail_data != null:
		self.tail_data = passed_tail_data
		self.title_node.text = self.tail_data.tail_name
		self.attrb_node.text = self.tail_data.tail_attrb_str
		self.blank_card.hide()


#<---------- IN-GAME ---------->
func clear_tail_card():
	self.tail_data = null
	self.title_node.text = ""
	self.attrb_node.text = ""
	self.blank_card.show()
 

func _on_remove_tail():
	if self.tail_data:
		tail_config_menu.remove_tail(self.tail_data)
#<---------- IN-GAME ---------->

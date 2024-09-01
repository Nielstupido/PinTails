class_name Tail
extends RigidBody3D


var tail_data : TailData
var interaction_text : String


func _ready():
	interaction_text = "Press " + str(OS.get_keycode_string((InputMap.action_get_events("attach_tail"))[0].keycode)) + " to pick up"
	GAMEMANAGER.connect("tail_picked_up", Callable(self, "_tail_picked_up"))


func _tail_picked_up(picked_up_data):
	if picked_up_data.id == self.tail_data.id:
		self.queue_free()


##when adding obj to world
func prepare_tail(new_tail_data : TailData) -> bool:
	self.tail_data = new_tail_data
	return true

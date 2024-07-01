class_name Tail
extends RigidBody


var id : int
var tail_data : TailData


func _ready():
	GAME.connect("tail_picked_up", self, "_tail_picked_up")


func _tail_picked_up(picked_up_id):
	if picked_up_id == self.id:
		self.queue_free()


#for when adding obj to world
func prepare_tail(new_tail_data : TailData) -> bool:
	self.tail_data.set_data(new_tail_data)
	return true

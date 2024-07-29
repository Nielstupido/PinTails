class_name Tail
extends RigidBody


var tail_data : TailData


func _ready():
	GAMEMANAGER.connect("tail_picked_up", self, "_tail_picked_up")


func _tail_picked_up(picked_up_data):
	if picked_up_data.id == self.tail_data.id:
		self.queue_free()


#when adding obj to world
func prepare_tail(new_tail_data : TailData) -> bool:
	self.tail_data = TailData.new()
	self.tail_data.set_data(new_tail_data)
	return true

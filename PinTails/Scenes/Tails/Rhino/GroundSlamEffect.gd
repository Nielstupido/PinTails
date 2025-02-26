extends Node3D


func play_effect():
	$GroundSlamController.play("ground_slam")
	$GroundSlamEffect.local_coords = false
	$GroundSlamDustEffect.local_coords = false
	$SparkEffect.local_coords = false

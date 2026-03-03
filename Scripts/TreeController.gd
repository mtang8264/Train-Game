extends Node3D
## This script currently just gives the trees a random rotation after they are spawned.

func _init():
	rotation.y = randf() * 360.0

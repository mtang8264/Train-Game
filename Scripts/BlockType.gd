class_name BlockType
extends Resource

@export var block_name: String
@export var block_filename: String

func get_block_filepath() -> String:
	return "res://Objects/Blocks/PackedScenes/" + block_filename + ".tscn"

class_name BlockType
extends Resource

## The string name of the block.
@export var block_name: String
## The name of the scene which contains the block instance, given as a string.
@export var block_filename: String

## Returns the full filepath of the block.
## Assumes the scene is a .tscn file stored in the Objects/Blocks/PackedScenes/ directory.
func get_block_filepath() -> String:
	return "res://Objects/Blocks/PackedScenes/" + block_filename + ".tscn"

class_name MapController
extends Node3D

## This script controls all relevant information about the map.

## The spacing between the origins of the blocks that make up the map.
## Default is (0.5, 0.5).
@export var block_offset: Vector2 = Vector2(0.5, 0.5)
## A dictionary containing all the types of blocks the map can use.
@export var block_types: Dictionary
## A scene representing the trees which can be placed around the map when generated.
@export var tree_scene: PackedScene
## The filepath, given as a string, which points to the map we are trying to load.
## This should be a .csv file.
@export var map_to_load: String

## An array containing arrays representing the map.
var map_data = []

func _ready() -> void:
	_load_map_data()
	_generate_map()
	pass

func _process(delta: float) -> void:
	pass

## Loads the map data from the file map_to_load.
## Returns true for posterity.
func _load_map_data() -> bool:
	# Open the map file
	var map = FileAccess.open(map_to_load, FileAccess.READ)
	
	# This variable tracks wether the we have finished loading the map or not
	var loaded = false
	
	# While we havent finished loading we iterate through the .csv file.
	while !loaded:
		# If the next line is just a single blank cell, then we are done loading.
		var next_line = map.get_csv_line()
		if next_line == PackedStringArray([""]):
			loaded = true
			continue
		# Otherwise we append the line into the map_data variable.
		else:
			map_data.append(next_line)
	# Close file access.
	map.close()
	return true

## Generates the map by instantiating the necesary assets.
## Returns true for posterity.
func _generate_map() -> bool:
	var height = len(map_data)
	var width = len(map_data[0])
	
	for y in range(height):
		for x in range(width):
			if map_data[y][x] == "":
				continue
			_spawn_block(map_data[y][x], x, y)
			if len(map_data[y][x]) == 1:
				continue
			elif map_data[y][x][1] == "t":
				_spawn_tree(x,y)
	return true

## Spawns a single block given its key and position.
func _spawn_block(block_key: String, pos_x: int, pos_y: int) -> void:
	var block_type = block_types[block_key[0]]
	var block_scene = load(block_type.get_block_filepath())
	var block = block_scene.instantiate()
	add_child(block)
	block.position = Vector3(pos_x * block_offset.x,0,  pos_y * block_offset.y)
	pass

## Spawns a single tree given its position.
func _spawn_tree(pos_x: float, pos_y: float) -> void:
	var tree = tree_scene.instantiate()
	tree.position = Vector3(pos_x * block_offset.x, 0, pos_y * block_offset.y)
	add_child(tree)
	pass

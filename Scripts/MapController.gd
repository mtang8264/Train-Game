class_name MapController
extends Node3D

@export var block_offset: Vector2
@export var block_types: Dictionary
@export var map_to_load: String

var map_data = []

func _ready() -> void:
	_load_map_data()
	_generate_map()
	pass

func _process(delta: float) -> void:
	pass

func _load_map_data() -> bool:
	var map = FileAccess.open(map_to_load, FileAccess.READ)
	
	var loaded = false
	
	while !loaded:
		var next_line = map.get_csv_line()
		if next_line == PackedStringArray([""]):
			loaded = true
			continue
		else:
			map_data.append(next_line)
	
	map.close()
	return true

func _generate_map() -> bool:
	var height = len(map_data)
	var width = len(map_data[0])
	
	for y in range(height):
		for x in range(width):
			if map_data[y][x] == "":
				continue
			_spawn_block(map_data[y][x], x, y)
	
	return true
	
func _spawn_block(block_key: String, pos_x: int, pos_y: int) -> void:
	var block_type = block_types[block_key]
	var block_scene = load(block_type.block_filepath)
	var block = block_scene.instantiate()
	add_child(block)
	block.position = Vector3(pos_x * block_offset.x,0,  pos_y * block_offset.y)
	pass

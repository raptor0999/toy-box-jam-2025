extends Node2D

@export var min_chickens : int = 1
@export var max_chickens : int = 1
@export var min_chicks : int = 5
@export var max_chicks : int = 10
@export var medium_time : float = 30.0
@export var hard_time : float = 20.0

var chicken_file = preload("res://scenes/characters/companions/chicken.tscn")
var chick_file = preload("res://scenes/characters/companions/chick.tscn")

var chickens_node
var chicks_node
var chicken_spawns_node
var chick_spawns_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chicken_spawns_node = get_node("ChickenSpawns")
	chick_spawns_node = get_node("ChickSpawns")
	chickens_node = get_node("Chickens")
	chicks_node = get_node("Chicks")
	
	# spawn chickens, then spawn chicks
	for i in range(randi_range(min_chickens, max_chickens)):
		var chicken_instance = chicken_file.instantiate()
		chickens_node.add_child(chicken_instance)
		var chicken_spawn_node = chicken_spawns_node.get_children().pick_random()
		chicken_instance.position = chicken_spawn_node.position
		chicken_spawns_node.remove_child(chicken_spawn_node)
		chicken_spawn_node.queue_free()

	# spawn chicks
	for i in range(randi_range(min_chicks, max_chicks)):
		var chick_instance = chick_file.instantiate()
		chicks_node.add_child(chick_instance)
		var chick_spawn_node = chick_spawns_node.get_children().pick_random()
		chick_instance.position = chick_spawn_node.position
		chick_spawns_node.remove_child(chick_spawn_node)
		chick_spawn_node.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends CharacterBody2D

@onready var _anim : AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED : float = 15.0
@export var ship_direction_time_min : float = 1.0
@export var ship_direction_time_max : float = 5.0

var ship_direction_time = 0.0
var dir = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	velocity = dir * SPEED
	
	if move_and_slide() and SPEED > 0.0:
		change_dir()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ship_direction_time -= delta
	
	if ship_direction_time < 0.0 and SPEED > 0.0:
		change_dir()
		
func change_dir():
	ship_direction_time = randf_range(ship_direction_time_min, ship_direction_time_max)
	dir = Vector2(randi_range(-1,1), randi_range(-1,1))

	var anim_direction = "default"
	
	if dir == Vector2(-1, -1):
		anim_direction = "nw"
	if dir == Vector2(-1, 0):
		anim_direction = "w"
	if dir == Vector2(-1, 1):
		anim_direction = "sw"
	if dir == Vector2(0, -1):
		anim_direction = "n"
	if dir == Vector2(0, 1):
		anim_direction = "s"
	if dir == Vector2(1, 1):
		anim_direction = "se"
	if dir == Vector2(1, 0):
		anim_direction = "e"
	if dir == Vector2(-1, 1):
		anim_direction = "ne"
		
	_anim.play(anim_direction)

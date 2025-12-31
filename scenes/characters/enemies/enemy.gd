extends CharacterBody2D

@onready var _anim : AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED = 50.0
@export var min_follow_dist = 10.0
@export var max_follow_dist = 100.0

var player : CharacterBody2D
var target_node = null

func _ready():
	_anim.play("default")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction
	
	if target_node == null:
		direction = Vector2.ZERO
		var distance = null
		for c in get_tree().get_nodes_in_group("chick"):
			print_debug("chick hit")
			if (not distance or distance > position.distance_to(c.global_position)) and position.distance_to(c.global_position) < max_follow_dist:
				distance = position.distance_to(c.global_position)
				print_debug("got a hit")
				target_node = c
				
		
	
	if target_node != null and position.distance_to(target_node.global_position) > min_follow_dist:
		direction = position.direction_to(target_node.global_position)
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

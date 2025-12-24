extends CharacterBody2D

@onready var _anim : AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED = 50.0

func _ready():
	_anim.play("default")

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var player : CharacterBody2D = get_tree().root.find_child("Player", true, false)
	var direction := position.direction_to(player.position)
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

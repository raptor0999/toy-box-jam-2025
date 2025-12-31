extends CharacterBody2D

@onready var _anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var cluck_sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var SPEED = 75.0
@export var min_follow_dist = 12.0
@export var max_follow_dist = 100.0

@export var cluck_timer_max = 3.0
@export var cluck_prob = 0.5

var player : CharacterBody2D
var cluck_timer = cluck_timer_max

func _ready():
	_anim.play("default")
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if cluck_timer > 0.0:
		cluck_timer -= delta
	else:
		cluck_timer = cluck_timer_max
		if randf() > cluck_prob and not cluck_sfx.playing:
			cluck_sfx.play()

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := position.direction_to(player.position)
	
	if position.distance_to(player.global_position) < max_follow_dist and position.distance_to(player.global_position) > min_follow_dist:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

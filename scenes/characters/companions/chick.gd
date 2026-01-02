extends CharacterBody2D

@onready var _anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var cluck_sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var color_label : Label = $Label

@export var SPEED = 50.0
@export var SPEED_VARIATION = 0.7
@export var min_follow_dist = 10.0
@export var max_follow_dist = 100.0
@export var scare_dist = 30.0

@export var cluck_timer_max = 3.0
@export var cluck_prob = 0.5

@export var move_timer_max = 1.8

@export var scare_timer_max = 1.0

@export var capture_color :Global.CaptureColor = Global.CaptureColor.RED

var chicken : CharacterBody2D
var rescued = false
var scared = false
var cluck_timer = cluck_timer_max
var move_timer = move_timer_max
var scare_timer = scare_timer_max

var direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()

func _ready():
	_anim.play("default")
	
	match capture_color:
		Global.CaptureColor.RED:
			color_label.text = "R"
		Global.CaptureColor.GREEN:
			color_label.text = "G"
		Global.CaptureColor.BLUE:
			color_label.text = "B"
	
func _process(delta: float) -> void:
	if cluck_timer > 0.0:
		cluck_timer -= delta
	else:
		cluck_timer = cluck_timer_max
		if randf() > cluck_prob and not cluck_sfx.playing:
			cluck_sfx.play()
			
	if move_timer > 0.0:
		move_timer -= delta
		
	if scared:
		scare_timer -= delta
		
	# see if scared
	if scare_timer < 0.0:
		scared = false
		
	for b in get_tree().get_nodes_in_group("bat"):
		if position.distance_to(b.position) <= scare_dist:
			scared = true
			scare_timer = scare_timer_max

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	chicken = get_tree().get_first_node_in_group("chicken")
	
	if not rescued and not scared:
		if is_instance_valid(chicken) and position.distance_to(chicken.global_position) < max_follow_dist and position.distance_to(chicken.global_position) > min_follow_dist:
			direction = position.direction_to(chicken.global_position)
			velocity = direction * SPEED
		else:
			if move_timer > 0.0:
				velocity = direction * (SPEED * SPEED_VARIATION)
			else:
				move_timer = move_timer_max
				direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.y = move_toward(velocity.y, 0, SPEED)
			
	if rescued:
		velocity.x = move_toward(velocity.x, 0, 0.5)
		velocity.y = move_toward(velocity.y, 0, 0.5)
		
	if scared:
		velocity.x = move_toward(velocity.x, 0, SPEED/2)
		velocity.y = move_toward(velocity.y, 0, SPEED/2)
	
	move_and_slide()

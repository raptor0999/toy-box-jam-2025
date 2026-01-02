extends CharacterBody2D

@export var SPEED = 200.0
@export var attack_speed = 0.2
@export var has_sword = false
@export var has_spell = false

@onready var _anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var _swordKillBox : Area2D = $SwordKillBox
@onready var _shadow : TextureRect = $TextureRect

var projectile = preload("res://scenes/characters/objects/projectile.tscn")

var is_attacking = false
var attack_timer = 0.0
var main_node

func _ready() -> void:
	_anim.play("default")
	main_node = get_tree().root.find_child("Main", true, false)

func _physics_process(delta: float) -> void:
	if is_attacking:
		attack_timer -= delta
		if attack_timer < 0.0:
			is_attacking = false
			_shadow.position.x = -32.0
			_swordKillBox.process_mode = Node.PROCESS_MODE_DISABLED
			_anim.play("sword")
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not main_node.level_finished and not main_node.lose:
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			
		if velocity.x < 0.0:
			_anim.flip_h = true
			_swordKillBox.scale.x = -1.0
			
		if velocity.x > 0.0:
			_anim.flip_h = false
			_swordKillBox.scale.x = 1.0

		move_and_slide()

		if Input.is_action_just_pressed("shoot") and has_spell:
			var p_instance = projectile.instantiate()
			get_tree().root.get_node("Main/Level").add_child(p_instance)
			p_instance.position = position
			AudioPlayer.play_sfx("shoot")
			p_instance.set_linear_velocity(position.direction_to(get_global_mouse_position()) * 300.0)
			
		if Input.is_action_just_pressed("attack") and has_sword and not is_attacking:
			is_attacking = true
			_swordKillBox.process_mode = Node.PROCESS_MODE_ALWAYS
			attack_timer = attack_speed
			AudioPlayer.play_sfx("attack")
			if _swordKillBox.scale.x == 1.0:
				_shadow.position.x = -38.0
			if _swordKillBox.scale.x == -1.0:
				_shadow.position.x = -28.0
			_anim.play("attack")
	else:
		if Input.is_action_just_pressed("ui_accept"):
			main_node.start_next_level()
			position = Vector2.ZERO

func _on_sword_kill_box_body_entered(body: Node2D) -> void:
	if body.name.contains("Bat"):
		body.queue_free()
		AudioPlayer.play_sfx("die")

func _on_collect_box_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("sword"):
		has_sword = true
		_anim.play("sword")
		area.get_parent().queue_free()

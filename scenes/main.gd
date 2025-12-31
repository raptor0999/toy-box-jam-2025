extends Node2D

@onready var level_end_music : AudioStreamPlayer = $LevelEnd
@onready var win_music : AudioStreamPlayer = $Win
@onready var lose_music : AudioStreamPlayer = $Lose
@onready var level_timer : Timer = $LevelTimer

enum Difficulty { EASY = 0, MEDIUM = 1, HARD = 2 } 

@export var difficulty : Difficulty = Difficulty.MEDIUM
@export var max_lives : int = 3
@export var level_number : int = 1

var map_node
var hud_node
var player_node
var level_finished = false
var win = false
var lose = false
var lives = max_lives

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_node = get_node("Map")
	hud_node = get_node("UI/HUD")
	player_node = get_node("Player")
	start_next_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not level_timer.is_stopped():
		if difficulty == Difficulty.MEDIUM:
			hud_node.timer_label.text = "MED " + "%0.2f" % level_timer.time_left
		if difficulty == Difficulty.HARD:
			hud_node.timer_label.text = "HRD " + "%0.2f" % level_timer.time_left
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("switch_difficulty"):
		match difficulty:
			Difficulty.EASY:
				difficulty = Difficulty.MEDIUM
			Difficulty.MEDIUM:
				difficulty = Difficulty.HARD
			Difficulty.HARD:
				difficulty = Difficulty.EASY
			
		print_debug("Difficulty: " + str(difficulty))
		load_level(level_number)

func load_level(number):
	map_node = get_node("Map")
	
	# remove all existing children
	for c in map_node.get_children():
		map_node.remove_child(c)
		c.queue_free()
		
	# add and load new map
	map_node.add_child(load("res://scenes/levels/level_" + str(number) + ".tscn").instantiate())
	
	load_hud()
	AudioPlayer.play_music()
	
	match difficulty:
		Difficulty.EASY:
			hud_node.timer_label.text = "ESY 0.00"
			level_timer.stop()
		Difficulty.MEDIUM:
			var level_node = map_node.get_node("Level")
			level_timer.start(level_node.medium_time)
		Difficulty.HARD:
			var level_node = map_node.get_node("Level")
			level_timer.start(level_node.hard_time)

func load_hud():
	# set up hud after new level has loaded
	hud_node.level_complete_label.visible = false
	hud_node.win_label.visible = false
	hud_node.lose_label.visible = false
	hud_node.max_chicks = get_tree().get_node_count_in_group("chick")
	hud_node.chicks_rescued = 0

func start_next_level():
	level_finished = false
	win = false
	lose = false
	level_end_music.stop()
	win_music.stop()
	lose_music.stop()
	load_level(level_number)
	hud_node.current_level = level_number
	hud_node.current_lives_label.text = str(lives)

func finish_level():
	AudioPlayer.stop_music()
	level_finished = true
	level_number += 1
	level_timer.stop()
	if level_number > 7:
		win_game()
	else:
		level_end_music.play()

func win_game():
	win = true
	lose = false
	hud_node.win()
	AudioPlayer.stop_music()
	win_music.play()
	level_number = 1
	player_node.has_sword = false
	player_node.has_spell = false
	
func lose_game():
	hud_node.timer_label.text = "0.00"
	level_timer.stop()
	lose = true
	win = false
	lives -= 1
	hud_node.current_lives_label.text = str(lives)
	hud_node.lose(lives)
	AudioPlayer.stop_music()
	lose_music.play()
	
	if lives < 1:
		level_number = 1
		lives = max_lives
		player_node.has_sword = false
		player_node.has_spell = false

func _on_level_timer_timeout() -> void:
	lose_game()

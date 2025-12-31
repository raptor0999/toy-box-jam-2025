extends Control

@onready var chicks_rescued_label : Label = $VBoxContainer/HBoxContainer/Label2
@onready var timer_label : Label = $VBoxContainer/HBoxContainer/Label3
@onready var current_level_label : Label = $VBoxContainer/HBoxContainer2/Label2
@onready var current_lives_label : Label = $VBoxContainer/HBoxContainer3/Label2
@onready var level_complete_label : Label = $Label
@onready var win_label : Label = $Label2
@onready var lose_label : Label = $Label3

var max_chicks : int = 1
var chicks_rescued : int = 0:
	set(new_value):
		chicks_rescued = new_value
		chicks_rescued_label.text = str(new_value) + " / " + str(max_chicks)
		
		if chicks_rescued == max_chicks:
			level_complete()

var current_level : int = 1:
	set(new_value):
		current_level = new_value
		current_level_label.text = str(new_value)

var main_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_node = get_tree().root.find_child("Main", true, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func level_complete():
	lose_label.visible = false
	level_complete_label.visible = true
	main_node.finish_level()

func win():
	level_complete_label.visible = false
	lose_label.visible = false
	win_label.visible = true
	
func lose(lives):
	if lives > 0:
		lose_label.text = "YOU DIED"
	else:
		lose_label.text = "GAME OVER"
		
	level_complete_label.visible = false
	win_label.visible = false
	lose_label.visible = true

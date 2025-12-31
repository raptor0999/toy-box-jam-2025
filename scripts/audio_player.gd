extends Node

@onready var _music : AudioStreamPlayer = $Music
@onready var _sfx : AudioStreamPlayer = $SFX

var die_sfx = preload("res://assets/audio/sfx/sfxpack_48.ogg")
var sword_sfx = preload("res://assets/audio/sfx/sfxpack_33.ogg")
var shoot_sfx = preload("res://assets/audio/sfx/sfxpack_62.ogg")

func _ready() -> void:
	pass
	
func play_sfx(name):
	if name == "shoot":
		_sfx.stream = shoot_sfx
	if name == "attack":
		_sfx.stream = sword_sfx
	if name == "die":
		_sfx.stream = die_sfx
		
	_sfx.play()

func play_music():
	_music.play()

func stop_music():
	_music.stop()

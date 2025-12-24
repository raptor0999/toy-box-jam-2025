extends Node

@onready var _music : AudioStreamPlayer = $Music
@onready var _sfx : AudioStreamPlayer = $SFX

var die_sfx = preload("res://assets/audio/sfx/sfxpack_48.wav")
var sword_sfx = preload("res://assets/audio/sfx/sfxpack_33.wav")
var shoot_sfx = preload("res://assets/audio/sfx/sfxpack_62.wav")

func _ready() -> void:
	_music.play()
	
func play_sfx(name):
	if name == "shoot":
		_sfx.stream = shoot_sfx
	if name == "attack":
		_sfx.stream = sword_sfx
	if name == "die":
		_sfx.stream = die_sfx
		
	_sfx.play()

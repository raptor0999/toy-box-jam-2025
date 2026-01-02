extends StaticBody2D

@onready var rescue_sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var color_label : Label = $Label

@export var capture_color :Global.CaptureColor = Global.CaptureColor.RED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match capture_color:
		Global.CaptureColor.RED:
			color_label.text = "R"
		Global.CaptureColor.GREEN:
			color_label.text = "G"
		Global.CaptureColor.BLUE:
			color_label.text = "B"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rescue_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("chick") and body.capture_color == capture_color:
		if not body.rescued:
			body.set_collision_mask_value(6, false)
			body.rescued = true
			var hud = get_tree().root.find_child("HUD", true, false)
			hud.chicks_rescued += 1
			rescue_sfx.play()

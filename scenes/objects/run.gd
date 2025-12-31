extends StaticBody2D

@onready var rescue_sfx : AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rescue_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("chick"):
		if not body.rescued:
			body.rescued = true
			var hud = get_tree().root.find_child("HUD", true, false)
			hud.chicks_rescued += 1
			rescue_sfx.play()

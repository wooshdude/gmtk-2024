extends Control
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var new_tween := create_tween()
	new_tween.tween_property(self, "modulate", Color(0,0,0,1), 1)
	await new_tween.finished
	get_tree().change_scene_to_file("res://scenes/desk.tscn")

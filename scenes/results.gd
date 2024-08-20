extends Control
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gods: VBoxContainer = $Gods
@onready var reveal: ColorRect = $Reveal
@onready var progress_bar_o: ProgressBar = $Gods/HBoxContainer/ProgressBar
@onready var progress_bar_i: ProgressBar = $Gods/HBoxContainer2/ProgressBar
@onready var progress_bar_s: ProgressBar = $Gods/HBoxContainer3/ProgressBar
@onready var dialogue: Dialogue = $Dialogue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.frame = 0
	animated_sprite_2d.play("default")
	gods.hide()
	reveal.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	reveal.show()
	gods.show()
	var tween := create_tween()
	tween.tween_property(reveal, "size", Vector2(reveal.size.x, 0), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(progress_bar_o, "value", GodManager.get_god(GodManager.Gods.OSIRIS).relationship, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(progress_bar_i, "value", GodManager.get_god(GodManager.Gods.ISIS).relationship, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(progress_bar_s, "value", GodManager.get_god(GodManager.Gods.SET).relationship, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	await get_tree().create_timer(2).timeout
	var god_list = GodManager.gods.duplicate()
	god_list.sort_custom(func(a,b): a.relationship > b.relationship)
	print(god_list)
	match god_list[0].name:
		"Osiris":
			dialogue.start("Egypt is united once more, and shall remain for millennia to come. Mortals come to your court saddened to have passed.")
		"Isis":
			dialogue.start("Upper and Lower remain equal but apart. Two Pharaohs guide Egypt in two directions. Soon you find yourself split along the same lines.")
		"Set":
			dialogue.start("Egypt remains shattered and broken. The tombs of the Pharaohs sundered by war and greed. Your workload increases by the da")
	

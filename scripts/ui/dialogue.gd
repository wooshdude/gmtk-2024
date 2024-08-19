extends Control

@export_multiline var text:String
@onready var rich_text_label: RichTextLabel = $Panel/MarginContainer/RichTextLabel

signal finished

var playing:bool = false

func _ready():
	hide()
	finished.connect(_on_finished)


func start(text:String = ""):
	if playing: return
	rich_text_label.text = ""
	playing = true
	if text == "" and self.text == "": return
	show()
	if text == "": text = self.text
	
	for t in text.split():
		rich_text_label.text += t
		match t:
			".", "?", "!":
				await hold(0.2)
			"/":
				t = "\n"
			"-":
				await hold(0.1)
		await hold(0.02)
	playing = false
	await hold(5)
	finished.emit()


func hold(time:float = 0.05):
	await get_tree().create_timer(time).timeout
	return

func _on_finished():
	hide()
	

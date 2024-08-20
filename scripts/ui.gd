extends Control

@onready var book_gui: Control = $BookGUI
@onready var book: Control = $BookGUI/Book
@onready var tab_container: TabContainer = $BookGUI/Book/TabContainer
@onready var regulations_list: VBoxContainer = $BookGUI/Book/TabContainer/Info/Regulations/ScrollContainer/VBoxContainer

@onready var notifications: VBoxContainer = $Notifications
@onready var book_texture: AnimatedSprite2D = $BookGUI/BookTexture

var mouse_inside_book:bool

@onready var sound_component: SoundComponent = $"../../SoundComponent"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.regulation.connect(_on_regulation_added)
	book_gui.position.y = get_viewport_rect().size.y
	book_gui.show()
	book.hide()
	book_texture.frame = 0
	GlobalSignals.notification.connect(_on_notification)


func _on_show_book_button_down() -> void:
	var new_tween = create_tween()
	new_tween.tween_property(book_gui, "position", Vector2(book_gui.position.x,0), 0.2).set_trans(Tween.TRANS_SINE)
	await new_tween.finished
	book_texture.play("open")
	sound_component.play("book_open")
	await book_texture.animation_finished
	book.show()


func _on_close_button_down() -> void:
	book.hide()
	book_texture.play("close")
	sound_component.play("book_close")
	await book_texture.animation_finished
	var new_tween = create_tween()
	new_tween.tween_property(book_gui, "position", Vector2(book_gui.position.x,get_viewport_rect().size.y), 0.2).set_trans(Tween.TRANS_SINE)
	await new_tween.finished


func _on_gods_god_selected(string: Variant) -> void:
	_on_close_button_down()


func _on_notification(text:String):
	var new_notif = Notification.new()
	new_notif.lifetime = 3
	new_notif.text = text
	notifications.add_child(new_notif)
	notifications.move_child(new_notif,0)


func _on_gods_tab_pressed() -> void:
	#print('balls')
	if tab_container.current_tab == 0: return
	book.hide()
	book_texture.play("close")
	sound_component.play("book_close")
	await book_texture.animation_finished
	book_texture.play("open")
	sound_component.play("book_open")
	await book_texture.animation_finished
	book.show()
	tab_container.current_tab = 0


func _on_info_tab_pressed() -> void:
	if tab_container.current_tab == 1: return
	book.hide()
	book_texture.play("close")
	sound_component.play("book_close")
	await book_texture.animation_finished
	book_texture.play("open")
	sound_component.play("book_open")
	await book_texture.animation_finished
	book.show()
	tab_container.current_tab = 1

func _on_regulation_added(text:String):
	var new_label := Label.new()
	new_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	new_label.text = text
	regulations_list.add_child(new_label)

extends Control

onready var scene_tree: = get_tree()
onready var score_label: Label = $Score
onready var paused_overlay: ColorRect = $PauseOverlay
onready var title_label: Label = $PauseOverlay/Title
onready var main_screen_button: Button = $PauseOverlay/PauseMenu/MainScreenButton

var paused: = false setget set_paused
const MESSAGE_DIED: = "You died"

func _ready() -> void:
	PlayerData.connect("updated", self, "update_interface")
	PlayerData.connect("died", self, "_on_Player_died")
	update_interface()

func _on_Player_died() -> void:
	self.paused = true
	title_label.text = MESSAGE_DIED
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()

func set_paused(value:bool)->void:
	paused = value
	scene_tree.paused =value
	paused_overlay.visible = value
	
func update_interface() -> void:
	score_label.text = "Score: %s" % PlayerData.score

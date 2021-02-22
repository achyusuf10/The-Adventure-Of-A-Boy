tool
extends Area2D


onready var anim_player: AnimationPlayer = $AnimationPlayer

export (String, FILE) var next_scene_path: =""

func _on_Portal_body_entered(body):
	teleport()

func _get_configuration_warning() -> String:
	return "Next Scene Diisi" if next_scene_path=="" else ""


func teleport() -> void:
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
	get_tree().change_scene(next_scene_path)




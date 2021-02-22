extends Actor


onready var stomp_area: Area2D = $StompArea2D
onready var esprite = $AnimatedSprite

export var score: = 100


func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	_velocity.x *= -1 if is_on_wall() else 1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	if (_velocity.x < 0):
		esprite.flip_h = true
	else:
		esprite.flip_h = false



func _on_StompArea2D_area_entered(area: Area2D) -> void:
	if area.global_position.y > stomp_area.global_position.y:
		return
	die()

func die() -> void:
	PlayerData.score += score
	queue_free()
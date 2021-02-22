extends Actor
onready var sprite = $AnimatedSprite
onready var anim_player:AnimationPlayer=$AnimationPlayer
var is_dead=false

export var stomp_impulse: = 1200

func _physics_process(delta):
	if is_dead==false:
		var direction:= get_direction()
		# Agar Pas Jump Ada sedikit Interrup/mandeg
		# Action_just_released bernilai true ketika key map tidak lagi ditekan
		var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
		# Menghitung kecepatan velocity untuk jalannya player
		_velocity= calculate_move_velocity(_velocity,direction,speed, is_jump_interrupted)
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		# jika ditekan input jalan ke kiri
		if is_on_floor():
			if Input.is_action_pressed("move_left"):
				sprite.flip_h=true
				sprite.play("RUN")
			elif Input.is_action_pressed("move_right"):
				sprite.flip_h=false
				sprite.play("RUN")
			else:
				sprite.play("IDLE")
		if _velocity.y<0:
			sprite.play("JUMP UP")
		if _velocity.y>0:
			sprite.play("JUMP DOWN")
		
	else:
		sprite.play("DEATH")
func get_direction() -> Vector2:
	return Vector2(
		# Input move_right dan move left, ada "-" buat balik arah
		# Action Strength, ketika ditekan mengembalikan nilai 1
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)
func calculate_move_velocity(
	linier_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool
	) -> Vector2:
	#Menghitung kecepatan out.x (kecepatan jalan saat di x)
	var out: = linier_velocity
	out.x = speed.x * direction.x
	#Menghitung kecepatan y nya saat jatuh
	out.y += gravity * get_physics_process_delta_time()
	#Menghitung kecepatan nya saat lompat,
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	# Ketika bernilai true, maka jump akan sedikit ada interupt
	if is_jump_interrupted:
		out.y = 0.0
	return out

func _on_TrapDetector_body_entered(body):
	is_dead=true


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "DEATH":
		anim_player.play("fade_out")
		yield(anim_player, "animation_finished")
		PlayerData.deaths += 1
		queue_free()


func _on_StompDetector_area_entered(area):
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	return Vector2(linear_velocity.x, stomp_jump)

extends Area3D

var time := 0.0
var grabbed := false

# เรียกทันทีที่โนดถูกเพิ่มเข้า SceneTree (มาก่อน _ready ของพ่อแม่บางส่วน)
func _enter_tree() -> void:
	Game.register_coin()

func _ready() -> void:
	# ต่อสัญญาณถ้ายังไม่ได้ต่อใน Editor
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if grabbed: return
	if body.has_method("collect_coin"):
		grabbed = true
		body.collect_coin()
		Game.add_coin()

		Audio.play("res://sounds/coin.ogg")
		$"Peppermint_candy".queue_free()
		$Particles.emitting = false

		# ปิดการชนแบบ deferred (แก้ error Function blocked during in/out signal)
		set_deferred("monitoring", false)
		set_deferred("collision_layer", 0)
		set_deferred("collision_mask", 0)

		await get_tree().process_frame
		queue_free()

func _process(delta: float) -> void:
	rotate_y(2 * delta)
	position.y += (cos(time * 5) * 1) * delta
	time += delta

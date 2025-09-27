# Flag.gd
extends Node3D

@onready var area: Area3D = $Area3D

func _ready() -> void:
	area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node) -> void:
	# ให้ Player อยู่ใน group ชื่อ "player"
	if body.is_in_group("Player"):
		Game.emit_win()

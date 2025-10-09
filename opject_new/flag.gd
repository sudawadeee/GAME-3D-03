extends Node3D

@onready var area: Area3D = $Area3D
@onready var sound_win1: AudioStreamPlayer3D = $SoundWin
@onready var sound_win2: AudioStreamPlayer3D = $SoundWin2

func _ready() -> void:
	sound_win1.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	sound_win2.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		sound_win1.play()
		sound_win2.play()
		Game.emit_win()

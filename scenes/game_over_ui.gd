extends Control

@onready var _game_over_ui: Control = %GameOverUI
@onready var _btn_retry: Button = %RestartButton
@onready var _btn_quit: Button  = %QuitButton
@onready var _summary_label: Label = %SummaryLabel

func _ready() -> void:
	visible = false
	# ให้ UI/ปุ่มทำงานตอน pause
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_btn_retry.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_btn_quit.process_mode  = Node.PROCESS_MODE_WHEN_PAUSED

	# ต่อสัญญาณปุ่ม (กันต่อซ้ำ)
	if not _btn_retry.pressed.is_connected(_on_restart_pressed):
		_btn_retry.pressed.connect(_on_restart_pressed)
	if not _btn_quit.pressed.is_connected(_on_quit_pressed):
		_btn_quit.pressed.connect(_on_quit_pressed)

func show_game_over(title := "Game Over") -> void:
	# อัปเดตข้อความเพิ่มเติมถ้าต้องการ
	# _summary_label.text = title
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_btn_retry.grab_focus()
	await get_tree().process_frame
	get_tree().paused = true

func _on_restart_pressed() -> void:
	print("retry pressed")
	get_tree().paused = false
	get_tree().reload_current_scene()
	# หากต้องกลับไปจับเมาส์ในเกม 3D:
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_pressed() -> void:
	print("quit pressed")
	get_tree().paused = false
	get_tree().quit()

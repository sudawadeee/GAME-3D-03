extends Node3D

@export var level_time: float = 5.0

@onready var _timer: Timer = $Timer                 # ถ้า Timer เป็นลูกตรง
@onready var _time_label: Label = get_node_or_null("%TimeLabel") # หรือ $"HUD/TimeLabel"
@onready var _game_over_ui: Control = get_node_or_null("%GameOverUI")
@onready var _btn_retry: Button = get_node_or_null("%Retry")
@onready var _btn_quit: Button = get_node_or_null("%Quit")

func _ready() -> void:
	# เริ่ม Timer
	if _timer == null:
		push_error("ไม่พบโหนด Timer ใต้ main.tscn")
		return
	_timer.one_shot = true
	_timer.wait_time = level_time
	if not _timer.timeout.is_connected(_on_time_up):
		_timer.timeout.connect(_on_time_up)
	_timer.start()

	# ต่อปุ่ม Game Over (ถ้ามี)
	if _btn_retry and not _btn_retry.pressed.is_connected(_on_retry_pressed):
		_btn_retry.pressed.connect(_on_retry_pressed)
	if _btn_quit and not _btn_quit.pressed.is_connected(_on_quit_pressed):
		_btn_quit.pressed.connect(_on_quit_pressed)

func _process(delta: float) -> void:
	# อัปเดตเวลาบน HUD
	if _timer and not _timer.is_stopped() and _time_label:
		_time_label.text = str(int(ceil(_timer.time_left)))

func _on_time_up() -> void:
	_show_game_over()

func _show_game_over() -> void:
	# แสดง UI แล้ว pause เกม
	if _game_over_ui:
		_game_over_ui.visible = true
		_game_over_ui.grab_focus()  # โฟกัสปุ่มแรกถ้ามี
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	get_tree().paused = true
	# ปิดอินพุต Player เพิ่มเติมได้ถ้าต้องการ

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

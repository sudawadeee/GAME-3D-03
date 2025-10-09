extends Node3D

@export var level_time: float = 420   # รวมเวลาเริ่มต้น (วินาที)
@export var warning_time: float = 30 # แสดงข้อความเมื่อเหลือ 15 

@onready var _timer: Timer = $Timer
@onready var _time_label: Label = get_node_or_null("%TimeLabel")
@onready var _message_label: Label = get_node_or_null("%MessageLabel") # เพิ่ม Label สำหรับข้อความ
@onready var _game_over_ui: Control = get_node_or_null("%GameOverUI")
@onready var _btn_retry: Button = get_node_or_null("%Retry")
@onready var _btn_quit: Button = get_node_or_null("%Quit")
@onready var bgm: AudioStreamPlayer = $BGM



var _message_shown := false  # ป้องกันแสดงซ้ำ

func _ready() -> void:
	if not bgm.playing:
		bgm.play()
		
	if _timer == null:
		push_error("ไม่พบโหนด Timer ใต้ main.tscn")
		return
	_timer.one_shot = true
	_timer.wait_time = level_time
	if not _timer.timeout.is_connected(_on_time_up):
		_timer.timeout.connect(_on_time_up)
	_timer.start()

	if _btn_retry and not _btn_retry.pressed.is_connected(_on_retry_pressed):
		_btn_retry.pressed.connect(_on_retry_pressed)
	if _btn_quit and not _btn_quit.pressed.is_connected(_on_quit_pressed):
		_btn_quit.pressed.connect(_on_quit_pressed)

	# ซ่อนข้อความเริ่มต้น
	if _message_label:
		_message_label.visible = false
		


func _process(delta: float) -> void:
	if _timer and not _timer.is_stopped() and _time_label:
		_time_label.text = str(int(ceil(_timer.time_left)))

		# ตรวจว่าถึงเวลาแสดงข้อความหรือยัง
		if not _message_shown and _timer.time_left <= warning_time:
			_show_message("Find the flag to win!")
			

func _show_message(text: String) -> void:
	_message_shown = true
	if _message_label:
		_message_label.text = text
		_message_label.visible = true
		# ถ้าอยากให้หายไปเองใน 5 วิ
		await get_tree().create_timer(5.0).timeout
		_message_label.visible = false

func _on_time_up() -> void:
	_show_game_over()

func _show_game_over() -> void:
	if bgm.playing:
		bgm.stop()
	if _game_over_ui:
		_game_over_ui.visible = true
		_game_over_ui.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true

func _on_retry_pressed() -> void:
	if not bgm.playing:
		bgm.play()
		
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

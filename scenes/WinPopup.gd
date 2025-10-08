extends Control

@onready var restart_btn: Button   = %RestartButton
@onready var quit_btn: Button      = %QuitButton
@onready var summary_label: Label  = %SummaryLabel

func _ready() -> void:
	visible = false
	# ให้ UI และปุ่มทำงานตอน pause
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	restart_btn.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	quit_btn.process_mode    = Node.PROCESS_MODE_WHEN_PAUSED

	# ต่อสัญญาณแบบกันซ้ำ
	if not restart_btn.pressed.is_connected(_on_restart_pressed):
		restart_btn.pressed.connect(_on_restart_pressed)
	if not quit_btn.pressed.is_connected(_on_quit_pressed):
		quit_btn.pressed.connect(_on_quit_pressed)

	# ชนะเกม
	if not Game.win.is_connected(_on_game_win):
		Game.win.connect(_on_game_win)

func _on_game_win() -> void:
	var percent := Game.get_percent()
	summary_label.text = "Coins: %d/%d (%.0f%%)" % [Game.collected_coins, Game.total_coins, percent]
	show_game_over("You Win")

# เรียกจาก main.gd เมื่อหมดเวลาได้เช่นกัน
func show_game_over(reason: String = "Game Over") -> void:
	# summary_label.text = reason  # ถ้าต้องการเปลี่ยนข้อความ
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	restart_btn.grab_focus()
	await get_tree().process_frame

	var tree := Engine.get_main_loop() as SceneTree
	if tree:
		tree.paused = true

func _on_restart_pressed() -> void:
	_stop_victory_music()
	var tree := Engine.get_main_loop() as SceneTree
	if tree:
		tree.paused = false
		visible = false
		await tree.process_frame   # ให้ปลด pause/ปิด UI ให้เรียบร้อยก่อน
		# โหลดฉากเดิมใหม่
		tree.reload_current_scene()
		# ถ้าต้องจับเมาส์กลับ: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_pressed() -> void:
	_stop_victory_music()
	var tree := Engine.get_main_loop() as SceneTree
	if tree:
		tree.paused = false
		tree.quit()

func _stop_victory_music() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	if tree and tree.current_scene:
		var flag := tree.current_scene.find_child("SoundWin2", true, false)
		if flag and flag.has_method("stop"):
			flag.stop()

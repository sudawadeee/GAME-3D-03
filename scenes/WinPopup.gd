extends Control

@onready var restart_btn: Button = %RestartButton
@onready var quit_btn: Button    = %QuitButton
@onready var summary_label: Label = %SummaryLabel

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	restart_btn.pressed.connect(_on_restart_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)
	Game.win.connect(_on_game_win)

func _on_game_win() -> void:
	var percent := Game.get_percent()
	summary_label.text = "Coins: %d/%d (%.0f%%)" % [Game.collected_coins, Game.total_coins, percent]

	visible = true
	await get_tree().create_timer(4.1).timeout  
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_restart_pressed() -> void:
	_stop_victory_music() 
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var current := get_tree().current_scene
	if current != null:
		var path := current.scene_file_path
		if path != "":
			get_tree().change_scene_to_file(path)

func _on_quit_pressed() -> void:
	_stop_victory_music() 
	get_tree().quit()
	
func _stop_victory_music() -> void:
	var flag = get_tree().current_scene.find_child("SoundWin2", true, false)
	if flag:
		flag.stop()

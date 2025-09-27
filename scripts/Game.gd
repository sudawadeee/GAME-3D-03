extends Node

signal win
signal coin_changed(collected: int, total: int)

var total_coins := 0
var collected_coins := 0

# เรียกก่อนที่เหรียญใด ๆ จะเข้าซีน (ตอนเริ่มด่าน)
func begin_level() -> void:
	total_coins = 0
	collected_coins = 0
	coin_changed.emit(collected_coins, total_coins)

# ให้เหรียญเรียกทันทีที่ "เข้าซีน"
func register_coin() -> void:
	total_coins += 1
	coin_changed.emit(collected_coins, total_coins)

func add_coin() -> void:
	collected_coins = clamp(collected_coins + 1, 0, total_coins)
	coin_changed.emit(collected_coins, total_coins)

func get_percent() -> float:
	if total_coins <= 0:
		return 0.0
	return float(collected_coins) / float(total_coins) * 100.0

func get_stars() -> int:
	var pct := get_percent()
	var stars := int(floor(pct / 20.0 + 1e-6))
	return clamp(stars, 0, 5)

func emit_win() -> void:
	win.emit()

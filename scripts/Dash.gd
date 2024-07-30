extends Node2D

@onready var timer = $Timer
var dash_delay = 0.4
var can_dash = true

func start_dash(dur):
	timer.wait_time = dur
	timer.start()
	
func is_dashing():
	return !timer.is_stopped()

func end_dash():
	can_dash = false
	await get_tree().create_timer(dash_delay).timeout
	can_dash = true


func _on_Timer_timeout():
	end_dash()

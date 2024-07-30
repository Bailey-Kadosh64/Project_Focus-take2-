extends Node2D

var playerScene = preload("res://_player/Player.tscn")

func _physics_process(delta):
	if Input.is_key_pressed(KEY_R):
		get_parent().remove_child(playerScene)
		
	if playerScene == null:
		var newPlayer = playerScene.instance()
		newPlayer.position = position
		get_parent().add_child(newPlayer)
		

extends Node

func _enter_tree() -> void:
	var game : Node = load("res://Scenes/Management/Game.tscn").instance()

	get_parent().call_deferred("add_child", game)
	self.queue_free()

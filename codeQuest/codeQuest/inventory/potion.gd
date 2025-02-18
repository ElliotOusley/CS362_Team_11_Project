extends Node2D
@export var item: InvItem
var player = null

func _on_interactible_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_collect()
		self.queue_free()
		
func player_collect():
	player.collect(item)

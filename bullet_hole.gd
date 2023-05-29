extends Decal

func _ready():
	$AnimationPlayer.play("fade_out")

func _on_animation_player_animation_finished(_anim_name: StringName):
	queue_free()

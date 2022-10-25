class_name ExplosionMeteorito
extends Node2D

onready var sonido_explosion:AudioStreamPlayer = $AudioStreamPlayer

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	sonido_explosion.play()
	queue_free()

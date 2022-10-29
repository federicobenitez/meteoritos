class_name EnemigoBase
extends NaveBase


func _ready() -> void:
	$Canion.set_esta_disparando(true)

func _on_body_entered(body:Node) -> void:
	._on_body_entered(body)
	if body is Player:
		body.destruir()
		destruir()


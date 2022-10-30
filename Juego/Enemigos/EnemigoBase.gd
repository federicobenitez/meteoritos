class_name EnemigoBase
extends NaveBase

#atrubutos
var player_objetivo:Player = null
var dir_player:Vector2
var frame_actual:int = 0

#metodos
func _ready() -> void:
	player_objetivo = DatosJuego.get_player_actual()
	#Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	#$Canion.set_esta_disparando(true)
	
func _physics_process(_delta: float) -> void:
	frame_actual += 1
	if frame_actual % 3 == 0:
		rotar_hacia_player()
	
#metodos custom
func _on_nave_destruida(nave:NaveBase, _position , _explosiones) -> void:
	if nave is Player:
		player_objetivo = null
		

func _on_body_entered(body:Node) -> void:
	._on_body_entered(body)
	if body is Player:
		body.destruir()
		destruir()

func rotar_hacia_player()-> void:
	if is_instance_valid(player_objetivo):
		dir_player = player_objetivo.global_position - global_position
		rotation = dir_player.angle()
	

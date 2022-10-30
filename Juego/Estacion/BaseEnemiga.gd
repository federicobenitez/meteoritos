class_name BaseEnemiga
extends Node2D

export var hitpoints:float = 10.0
export var orbital:PackedScene = null

onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX

var esta_destruida:bool = false
 
func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())
	
func _process(delta: float) -> void:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	if not is_instance_valid(player_objetivo):
		return
		
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())
	print(angulo_player)
	
func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() -1
	var indice_anim_aleatoria:int = randi() % num_anim +1
	var lista_anim:Array = $AnimationPlayer.get_animation_list()
	
	return lista_anim[indice_anim_aleatoria]
	
func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
		queue_free()
	impacto_sfx.play()
	
func destruir() -> void:
	var posicion_partes = [
		$Sprites/Sprite4.global_position,
		$Sprites/Sprite3.global_position,
		$Sprites/Sprite2.global_position,
		$Sprites/Sprite.global_position
	]
	Eventos.emit_signal("base_destruida", self, posicion_partes)
	queue_free()
		
func spawnear_orbital() -> void:
	var pos_spawn:Vector2 = deteccion_cuadrante()
	var new_orbital:EnemigoOrbital = orbital.instance()
	new_orbital.crear(global_position + pos_spawn, self)
	
	Eventos.emit_signal("spawn_orbital", new_orbital)
	
func deteccion_cuadrante() -> Vector2:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	if not is_instance_valid(player_objetivo):
		return Vector2.ZERO
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0:
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		if sign(angulo_player) > 0:
			return $PosicionesSpawn/Sur.position
		else:
			return $PosicionesSpawn/Norte.position
			
	return $PosicionesSpawn/Norte.position

func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	spawnear_orbital()
	#var new_orbital:EnemigoOrbital = orbital.instance()
	#new_orbital.crear(global_position + $PosicionesSpawn/Norte.global_position, self)
	#Eventos.emit_signal("spawn_orbital",new_orbital)

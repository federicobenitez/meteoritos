extends MarginContainer

#atributos
export var escala_zoom:float = 4.0

var escala_grilla:Vector2
var player:Player = null
var esta_visible:bool = true setget set_esta_visible

var esta_activo:bool = true setget set_esta_activo

onready var zona_renderizado:TextureRect = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa
onready var icono_player:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoPlayer
onready var icono_base:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoBaseEnemiga
onready var icono_estacion:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoEstacionRecarga
onready var icono_interceptor:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoInterceptor
onready var icono_rele:Sprite = $CuadroMiniMapa/ContenedorIconos/ZonaRenderizadoMiniMapa/IconoRele
onready var items_mini_mapa:Dictionary = {}
onready var timer_visibilidad:Timer = $TimerVisibilidad
onready var tween_visibilidad:Tween = $TweenVisibilidad

export var tiempo_visible:float = 5.0

#metodos
func _ready() -> void:
	set_process(false)
	icono_player.position = zona_renderizado.rect_size * 0.5
	escala_grilla = zona_renderizado.rect_size / (get_viewport_rect().size * escala_zoom)
	conectar_seniales()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("minimapa"):
		set_esta_visible(not esta_visible)
	

func _process(delta: float) -> void:
	if not player:
		return
		
	icono_player.rotation_degrees = player.rotation_degrees + 90
	modificar_posicion_iconos()
	
func _on_nivel_iniciado() -> void:
	player = DatosJuego.get_player_actual()
	obtener_objetos_minimapa()
	set_process(true)
	
func _on_nave_destruida(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Player:
		player = null
	if nave.is_in_group("minimapa"):
		Eventos.emit_signal("minimapa_objeto_destruido", nave)
		
func conectar_seniales() -> void:
	Eventos.connect("nivel_iniciado", self, "_on_nivel_iniciado")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("minimapa_objeto_creado", self, "obtener_objetos_minimapa")
	Eventos.connect("minimapa_objeto_destruido", self, "quitar_icono")
		
func obtener_objetos_minimapa() -> void:
	var objetos_en_ventana:Array = get_tree().get_nodes_in_group("minimapa")
	for objeto in objetos_en_ventana:
		if not items_mini_mapa.has(objeto):
			var sprite_icono:Sprite
			if objeto is BaseEnemiga:
				sprite_icono = icono_base.duplicate()
			elif objeto is EstacionRecarga:
				sprite_icono = icono_estacion.duplicate()
			elif objeto is EnemigoInterceptor:
				sprite_icono = icono_interceptor.duplicate()
			elif objeto is ReleMasa:
				sprite_icono = icono_rele.duplicate()
				
			items_mini_mapa[objeto] = sprite_icono
			items_mini_mapa[objeto].visible = true
			zona_renderizado.add_child(items_mini_mapa[objeto])
			
func modificar_posicion_iconos() -> void:
	for item in items_mini_mapa:
		if is_instance_valid(item):
			var item_icono:Sprite = items_mini_mapa[item]
			var offset_pos:Vector2 = item.position - player.position
			var pos_icon:Vector2 = offset_pos * escala_grilla + (zona_renderizado.rect_size * 0.5)
			pos_icon.x = clamp(pos_icon.x, 0, zona_renderizado.rect_size.x)
			pos_icon.y = clamp(pos_icon.y, 0, zona_renderizado.rect_size.y)
			item_icono.position = pos_icon
		
			if zona_renderizado.get_rect().has_point(pos_icon - zona_renderizado.rect_position):
				item_icono.scale = Vector2(0.5, 0.5)
			else:
				item_icono.scale = Vector2(0.3, 0.3)
		
func quitar_icono(objeto:Node2D) -> void:
	if objeto in items_mini_mapa:
		items_mini_mapa[objeto].queue_free()
		items_mini_mapa.erase(objeto)

func set_esta_visible(hacer_visible:bool) -> void:
	if hacer_visible:
		timer_visibilidad.start()
	
	esta_visible = hacer_visible
	tween_visibilidad.interpolate_property(
		self,
		"modulate",
		Color(1,1,1, not hacer_visible),
		Color(1,1,1, hacer_visible),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_visibilidad.start()
	
func set_esta_activo(valor:bool) -> void:
	esta_activo = valor
	
func _on_TimerVisibilidad_timeout() -> void:
	if esta_visible and esta_activo:
		set_esta_visible(false)

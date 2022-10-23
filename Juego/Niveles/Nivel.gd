class_name Nivel
extends Node

#Atributos
onready var contenedor_proyectiles:Node

export var explosion:PackedScene = null

#Metodos
func _ready() -> void:
	#Eventos.connect("disparo", self, "_on_disparo")
	conectar_seniales()
	crear_contenedores()
	
#metodos custom
func conectar_seniales() -> void:
# warning-ignore:return_value_discarded
	Eventos.connect("disparo", self, "_on_disparo")
# warning-ignore:return_value_discarded
	Eventos.connect("nave_destruida",self, "_on_nave_destruida"	)

func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	
func _on_disparo(proyectil: Proyectil) -> void:
	#add_child(proyectil)
	contenedor_proyectiles.add_child(proyectil)

func _on_nave_destruida(posicion:Vector2, num_explosiones:int) -> void:
# warning-ignore:unused_variable
	for i in range(num_explosiones):
		var new_explosion:Node2D = explosion.instance()
		new_explosion.global_position = posicion
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6),"timeout")
		
		

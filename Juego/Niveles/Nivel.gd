class_name Nivel
extends Node

#Atributos
onready var contenedor_proyectiles:Node

#Metodos
func _ready() -> void:
	#Eventos.connect("disparo", self, "_on_disparo")
	conectar_seniales()
	crear_contenedores()
	
#metodos custom
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")

func crear_contenedores() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	
func _on_disparo(proyectil: Proyectil) -> void:
	#add_child(proyectil)
	contenedor_proyectiles.add_child(proyectil)

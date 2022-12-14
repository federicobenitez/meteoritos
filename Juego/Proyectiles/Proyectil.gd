class_name Proyectil
extends Area2D


#Atributos
var velocidad:Vector2 = Vector2.ZERO
var danio:float = 1.0

#Metodos
# warning-ignore:unused_argument
func crear(pos:Vector2, dir:float, vel:float, danio_p:int):
	position = pos
	rotation = dir
	velocidad = Vector2(vel, 0).rotated(dir)
	

func _physics_process(delta: float) -> void:
	position +=velocidad * delta

func daniar(otro_cuerpo:CollisionObject2D) -> void:
	if otro_cuerpo.has_method("recibir_danio"):
		otro_cuerpo.recibir_danio(danio)
	
	queue_free()

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("recibir_danio"):
		area.recibir_danio(danio)
		
	queue_free()


func _on_body_entered(body: Node) -> void:
	daniar(body)

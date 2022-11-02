class_name ContenedorInformacionEnergia
extends ContenedorInformacion

#atributos
onready var medidor:ProgressBar = $ProgressBar

#metodos
func actulizar_energia(energia_max:float, energia_actual:float) -> void:
	var energia_porcentual = (energia_actual * 100) / energia_max
	medidor.value = energia_porcentual

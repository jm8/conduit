extends Node3D

@onready var rifle = $Rifle
@onready var sight = $Sight

@export var light_material: Material:
	get:
		return light_material
	set(new_material):
		rifle.set_surface_override_material(1, new_material)
		sight.set_surface_override_material(1, new_material)

		light_material = new_material

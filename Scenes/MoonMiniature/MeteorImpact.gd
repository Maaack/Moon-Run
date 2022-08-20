tool
extends Spatial

func emit() -> void:
	$TopLayerLightParticles.emitting = true
	$MidLayerLightParticles.emitting = true
	$BottomLayerLightParticles.emitting = true

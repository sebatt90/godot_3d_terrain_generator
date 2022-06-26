extends Spatial

func _init():
	VisualServer.set_debug_generate_wireframes(true)

func _input(event):
	if event is InputEventKey and Input.is_key_pressed(KEY_P):
		var viewport = get_viewport()
		
		
		# DEBUG_DRAW_DISABLED = 0 DEBUG_DRAW_WIREFRAME = 3
		viewport.debug_draw = viewport.DEBUG_DRAW_WIREFRAME if viewport.debug_draw == viewport.DEBUG_DRAW_DISABLED else viewport.DEBUG_DRAW_DISABLED

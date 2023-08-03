extends DirectionalLight2D

@export var gradient: GradientTexture1D

func update_canvas(canvas_value):
	color = gradient.gradient.sample(canvas_value)

extends CanvasModulate

@export var gradient: GradientTexture1D

func update_canvas(canvas_value):
	self.color = gradient.gradient.sample(canvas_value)

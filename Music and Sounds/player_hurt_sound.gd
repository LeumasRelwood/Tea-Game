extends AudioStreamPlayer

func _ready():
	self.finished.connect(queue_free)

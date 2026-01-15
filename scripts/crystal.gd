extends PathFollow3D

const SPEED = 5

var progress_track := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_track = progress_track + delta * SPEED
	progress = progress_track

extends Camera2D

var shakeAmount = 0

func _ready():
	randomize()
	offset = Vector2.ZERO

func _process(delta):
	if shakeAmount == 0: return
	else:
		shakeAmount -= 1
		var shakeAngle = randf() * PI * 2
		offset.x = round(cos(shakeAngle) * shakeAmount)
		offset.y = round(sin(shakeAngle) * shakeAmount)

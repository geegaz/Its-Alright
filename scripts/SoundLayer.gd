extends AudioStreamPlayer

var fading_tween: Tween
var layer_amount: float = 0.0

func fade(target_amount: float, duration:= 1.0):
	if fading_tween and fading_tween.is_valid():
		fading_tween.stop()
	fading_tween = create_tween()
	fading_tween.tween_method(set_amount, layer_amount, target_amount, duration)

func set_amount(amount: float):
	layer_amount = amount
	volume_db = linear_to_db(amount)

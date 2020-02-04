extends Node2D

func init(spriteFrame):
	$Sprite.frame = spriteFrame
	$AnimationPlayer.play("anim")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

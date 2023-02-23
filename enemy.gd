class_name Enemy
extends Node2D

@export var data: EnemyData = null

var hp: int = 0

signal clicked(_enemy)
signal hovered(_enemy, value)
signal dead(_enemy)
signal hitPlayer
signal turnFinished
signal endPlayerTurn

enum STATE {
	idle,
	animation,
	dead
}

@export var state: STATE = STATE.idle

func doTurn():
	if state != STATE.dead:
		$AnimationPlayer.play("attack")
		state = STATE.animation
		Player.hurt(data.damage)

func _ready():
	hp = data.hp
	
	$Label.text = data.name
	$HPBar.max_value = data.hp
	$HPBar.value = hp
	$HPBar/HPLabel.text = "%s/%s" % [hp, data.hp]

func _on_select_box_mouse_entered():
	emit_signal('hovered', self, true)

func _on_select_box_mouse_exited():
	emit_signal('hovered', self, false)

func _on_select_box_pressed():
	emit_signal('clicked', self)

func hurt(amount: int):
	if hp > 0:
		hp -= amount
		$HPBar.value = hp
		$HPBar/HPLabel.text = "%s/%s" % [hp, data.hp]
		
		state = STATE.animation
		
		if hp <= 0:
			die()
		else:
			$AnimationPlayer.play("hurt")

func die():
	state = STATE.animation
	$AnimationPlayer.play("die")

func emitDead():
	emit_signal("dead", self)

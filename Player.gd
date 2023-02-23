extends Node

var floor: int = 1

var maxHp: int = 30
var hp: int = 30
var damage: int = 5

func hurt(amount: int):
	hp -= amount
	if hp <= 0:
		get_tree().quit()

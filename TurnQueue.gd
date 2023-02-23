class_name TurnQueue
extends Node

var q: Array = [null]

signal initialized
signal setState(_state)

func nextTurn():
	var curTurn = q[0]
	q.pop_front()
	q.append(curTurn)
	
	if q[0] != null:
		if q[0].hp <= 0:
			nextTurn()
		else:
			emit_signal('setState', 2)
			q[0].doTurn()
	else:
		emit_signal('setState', 0)

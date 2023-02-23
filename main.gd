extends Node2D

@onready var tq: TurnQueue = $TurnQueue
@onready var player: Player = $Player

const ENEMY_POSITIONS = {
	0: Vector2(257, 360),
	1: Vector2(95, 360),
	2: Vector2(422, 360),
}

func _ready():
	# connect signals
	connectEnemies()
	tq.connect('enemyTurn', setState)
	$CanvasLayer/GUI/HPLabel.text = 'HP: %s/%s' % [Player.hp, Player.maxHp]

enum STATE {
	idle,
	selecting,
	enemyTurn,
	noFight
}

var state: STATE = STATE.noFight
func setState(_state):
	state = _state

func connectEnemies():
	for enemy in $Enemies.get_children():
		enemy.connect('clicked', enemySelected)
		enemy.connect('hovered', enemyHovered)
		enemy.connect('dead', enemyKilled)
		enemy.connect('hitPlayer', isHurt)
		enemy.connect('turnFinished', tq.nextTurn)
		
		tq.q.append(enemy)

func _on_attack_pressed():
	if state == STATE.idle:
		state = STATE.selecting

func enemySelected(_enemy: Enemy):
	if state == STATE.selecting and _enemy.state == Enemy.STATE.idle:
		_enemy.hurt(Player.damage)
		endTurn()

func enemyHovered(_enemy: Enemy, _isHovered: bool):
	if state == STATE.selecting and _enemy.state == Enemy.STATE.idle:
		if _isHovered:
			_enemy.get_node('AnimationPlayer').play('hover')
		else:
			_enemy.get_node('AnimationPlayer').play('RESET')

func enemyKilled(_enemy: Enemy):
	for enemy in $Enemies.get_children():
		if enemy.state != Enemy.STATE.dead:
			return
	
	state = STATE.noFight
	$CanvasLayer/GUI/AdvanceButton.visible = true

	for enemy in $Enemies.get_children():
		$Enemies.remove_child(enemy)

func isHurt():
	$CanvasLayer/GUI/AnimationPlayer.play("hurt")
	$CanvasLayer/GUI/HPLabel.text = 'HP: %s/%s' % [Player.hp, Player.maxHp]

var enemyNode = preload("res://enemy.tscn")
func _on_advance_button_pressed():
	state = STATE.idle
	$CanvasLayer/GUI/AdvanceButton.visible = false
	
	var encountersForLevel = DB.encounters[Player.floor]
	var enc = encountersForLevel[randi() % encountersForLevel.size()]
	
	for i in range(enc.enemies.size()):
		var enemy = enc.enemies[i]
		var enemyInstance = enemyNode.instantiate()
		enemyInstance.data = enemy
		enemyInstance.position = ENEMY_POSITIONS[i]
		enemyInstance.visible = true
		$Enemies.add_child(enemyInstance)
	
	connectEnemies()

func endTurn():
	tq.nextTurn()

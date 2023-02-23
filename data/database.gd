extends Node

var enemies: Dictionary = {
	'goblin': preload("res://data/enemies/lvl1/goblin.tres"),
	'spider': preload("res://data/enemies/lvl1/spider.tres")
}

var encounters: Dictionary = {
	1: [
		preload("res://data/encounters/lvl1/1goblin.tres"),
		preload("res://data/encounters/lvl1/2spider.tres"),
		preload("res://data/encounters/lvl1/3rat.tres")
	]
}

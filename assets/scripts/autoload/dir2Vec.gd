extends Node

enum Dir {LEFT, RIGHT, UP, DOWN}

var dic = {
	Dir.LEFT: Vector2(-1, 0),
	Dir.RIGHT: Vector2(1, 0),
	Dir.UP: Vector2(0, -1),
	Dir.DOWN: Vector2(0, 1),
	}

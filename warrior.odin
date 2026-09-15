package main

import rl "vendor:raylib"
import "vendor:raylib/rlgl"

Warrior :: struct {
	pos:    rl.Vector2,
	health: i32,
	color:  rl.Color,
}

WARRIOR_HEALTH :: 100
WARRIOR_ATTACK :: 10
WARRIOR_RADIUS :: 10

drawWarrior :: proc(warrior: ^Warrior) {
	rlgl.PushMatrix()
	defer rlgl.PopMatrix()

	rlgl.Translatef(warrior.pos.x, warrior.pos.y, 0)
	rl.DrawCircle(0, 0, WARRIOR_RADIUS, warrior.color)
	rl.DrawCircleLines(0, 0, WARRIOR_RADIUS, rl.BLACK)
}

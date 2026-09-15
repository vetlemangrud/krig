package main

import rl "vendor:raylib"
import "vendor:raylib/rlgl"

// Static properties shared by all warriors
WARRIOR_ATTACK :: 10
WARRIOR_RADIUS :: 10

// Dynamic properties that change per warrior
Warrior :: struct {
	pos:    rl.Vector2,
	health: i32,
	color:  rl.Color,
}

draw_warrior :: proc(warrior: ^Warrior) {
	rlgl.PushMatrix()
	defer rlgl.PopMatrix()

	rlgl.Translatef(warrior.pos.x, warrior.pos.y, 0)
	rl.DrawCircle(0, 0, WARRIOR_RADIUS, warrior.color)
	rl.DrawCircleLines(0, 0, WARRIOR_RADIUS, rl.BLACK)
}

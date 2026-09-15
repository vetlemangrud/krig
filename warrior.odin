package main

import rl "vendor:raylib"
import "vendor:raylib/rlgl"

// Static properties shared by all warriors
WARRIOR_ATTACK :: 10
WARRIOR_RADIUS :: 10

// Dynamic properties that change per warrior
Warrior :: struct {
	pos:    rl.Vector2,
	vel:    rl.Vector2,
	acc:    rl.Vector2,
	health: i32,
	color:  rl.Color,
}

// Draw warrior to the screen
draw_warrior :: proc(warrior: ^Warrior) {
	rlgl.PushMatrix()
	defer rlgl.PopMatrix()

	rlgl.Translatef(warrior.pos.x, warrior.pos.y, 0)
	rl.DrawCircle(0, 0, WARRIOR_RADIUS, warrior.color)
	rl.DrawCircleLines(0, 0, WARRIOR_RADIUS, rl.BLACK)
}

apply_warrior_acc_towards_enemy :: proc(warrior: ^Warrior) {
	//Move towards the closest enemy
	best_warrior:^Warrior
	best_dist:f32=999999.0
	for &w in warriors {
		if w == warrior^ do continue
		if w.color == warrior.color do continue
		dist := rl.Vector2DistanceSqr(warrior.pos, w.pos) 
		if dist >= best_dist do continue
		best_warrior = &w
		best_dist = dist
	}
	dir := rl.Vector2Normalize(best_warrior.pos - warrior.pos)
	warrior.acc += dir * 10
}

// Push the warrior forwards one frame
update_warrior :: proc(warrior: ^Warrior) {
	apply_warrior_acc_towards_enemy(warrior)
	warrior.vel += warrior.acc * rl.GetFrameTime()
	warrior.pos += warrior.vel * rl.GetFrameTime()
	warrior.acc = {0,0}
}

package main

import rl "vendor:raylib"
import "vendor:raylib/rlgl"

// Static properties shared by all warriors
WARRIOR_ATTACK :: 10
WARRIOR_RADIUS :: 5
WARRIOR_SPEED :: 50

// Dynamic properties that change per warrior
Warrior :: struct {
	pos:      rl.Vector2,
	rotation: f32,
	vel:      rl.Vector2,
	health:   i32,
	color:    rl.Color,
}

// Draw warrior to the screen
draw_warrior :: proc(warrior: ^Warrior) {
	rlgl.PushMatrix()
	defer rlgl.PopMatrix()

	rlgl.Translatef(warrior.pos.x, warrior.pos.y, 0)
	rlgl.Rotatef(warrior.rotation * rl.RAD2DEG, 0, 0, 1)
	rl.DrawCircle(0, 0, WARRIOR_RADIUS, warrior.color)
	rl.DrawLine(0,0,WARRIOR_RADIUS,0,rl.BLACK)
}

apply_warrior_vel_towards_enemy :: proc(warrior: ^Warrior, warriors: []Warrior) {
	//Move towards the closest enemy
	best_warrior: ^Warrior
	best_dist: f32 = 999999.0
	for &w in warriors {
		if w.color == warrior.color do continue
		dist := rl.Vector2DistanceSqr(warrior.pos, w.pos)
		if dist >= best_dist do continue
		if dist <= WARRIOR_RADIUS * 2.5 do continue
		best_warrior = &w
		best_dist = dist
	}
	if best_warrior == nil do return
	dir := rl.Vector2Normalize(best_warrior.pos - warrior.pos)
	warrior.vel += dir * 100
}

apply_warrior_collision :: proc(warrior: ^Warrior, warriors: []Warrior) {
	for &w in warriors {
		if &w == warrior do continue
		sq_dist := rl.Vector2DistanceSqr(warrior.pos, w.pos)
		if sq_dist > 2 * 2 * WARRIOR_RADIUS * WARRIOR_RADIUS || sq_dist == 0 do continue
		dist := rl.Vector2Distance(warrior.pos, w.pos)
		dir := (warrior.pos - w.pos) / dist
		overlap := (2 * WARRIOR_RADIUS - dist)
		warrior.vel += dir * overlap * overlap * 1000
	}
}

apply_warrior_cohesion :: proc(warrior: ^Warrior, warriors: []Warrior) {
	sum: rl.Vector2
	count: i32
	for &w in warriors {
		if &w == warrior do continue
		if w.color != warrior.color do continue
		sum += w.pos - warrior.pos
		count += 1
	}
	if count == 0 do return
	sum /= f32(count)
	sum = rl.Vector2Normalize(sum)
	warrior.vel += sum * 20
}


apply_warrior_velocities :: proc(warrior: ^Warrior, warriors: []Warrior) {
	apply_warrior_vel_towards_enemy(warrior, warriors)
	apply_warrior_cohesion(warrior, warriors)
	if warrior.vel != {0, 0} do warrior.rotation = rl.Vector2Angle({1, 0}, warrior.vel)
	apply_warrior_collision(warrior, warriors)
	warrior.vel = rl.Vector2ClampValue(warrior.vel, 0, WARRIOR_SPEED)
}

update_warrior_position :: proc(warrior: ^Warrior) {
	warrior.pos += warrior.vel * rl.GetFrameTime()
	warrior.vel = {0, 0}
}

move_warriors :: proc(warriors: []Warrior) {
	for &warrior in warriors {
		apply_warrior_velocities(&warrior, warriors[:])
	}
	for &warrior in warriors {
		update_warrior_position(&warrior)
	}
}

draw_warriors :: proc(warriors: []Warrior) {
	for &warrior in warriors {
		draw_warrior(&warrior)
	}
}

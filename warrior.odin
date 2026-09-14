package main

import "vendor:raylib/rlgl"
import rl "vendor:raylib"

Warrior :: struct {
  pos: rl.Vector2,
  health: i32,
  color: rl.Color
}

warriorHealth :: 100
warriorAttack :: 10
warriorRadius :: 10

drawWarrior :: proc(warrior: ^Warrior) {
  rlgl.PushMatrix()
  defer rlgl.PopMatrix()

  rlgl.Translatef(warrior.pos.x, warrior.pos.y,0)
  rl.DrawCircle(0,0,warriorRadius,warrior.color)
  rl.DrawCircleLines(0,0,warriorRadius,rl.BLACK)
}

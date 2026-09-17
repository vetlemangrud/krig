package main
import rl "vendor:raylib"

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 600

camera := rl.Camera2D {
	offset   = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2},
	rotation = 0,
	target   = {0, 0},
	zoom     = 1,
}

WARRIORS_PER_TEAM :: 20

remove_dead_warriors :: proc(warriors: ^[dynamic]Warrior) {
	for i := len(warriors) - 1; i >= 0; i -= 1 {
		if warriors[i].health <= 0 do unordered_remove(warriors, i)
	}
}

main :: proc() {
	warriors := make([dynamic]Warrior)
	defer delete(warriors)
	for _ in 0 ..< WARRIORS_PER_TEAM {
		append(
			&warriors,
			Warrior {
				pos = {f32(rl.GetRandomValue(-200, -50)), f32(rl.GetRandomValue(-100, 100))},
				health = 100,
				color = TEAM_1_COLOR,
			},
		)
		append(
			&warriors,
			Warrior {
				pos = {f32(rl.GetRandomValue(50, 200)), f32(rl.GetRandomValue(-100, 100))},
				health = 100,
				color = TEAM_2_COLOR,
			},
		)
	}
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "krig")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		move_warriors(warriors[:])
		warriors_attack(warriors[:])
		remove_dead_warriors(&warriors)
		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(BACKGROUND_COLOR)
		{
			rl.BeginMode2D(camera)
			defer rl.EndMode2D()
			draw_warriors(warriors[:])
		}
	}
}

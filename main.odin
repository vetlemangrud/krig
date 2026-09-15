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

warriors := []Warrior {
	Warrior{color = rl.RED, health = 100, pos = {-100, -50}},
	Warrior{color = rl.RED, health = 100, pos = {-100, 50}},
	Warrior{color = rl.BLUE, health = 100, pos = {100, -50}},
	Warrior{color = rl.BLUE, health = 100, pos = {100, 50}},
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "krig")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		for &warrior in warriors {
			apply_warrior_forces(&warrior)
		}
		for &warrior in warriors {
			update_warrior_position(&warrior)
		}
		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(rl.GRAY)
		{
			rl.BeginMode2D(camera)
			defer rl.EndMode2D()
			for &warrior in warriors {
				draw_warrior(&warrior)
			}
		}
	}
}

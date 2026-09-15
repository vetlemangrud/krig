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

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "krig")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)
	warrior := Warrior {
		color  = rl.RED,
		health = 100,
		pos    = {0, 0},
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(rl.GRAY)
		{
			rl.BeginMode2D(camera)
			defer rl.EndMode2D()
			drawWarrior(&warrior)
		}
	}
}

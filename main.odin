package main
import rl "vendor:raylib"

screenWidth :: 800
screenHeight :: 600

camera := rl.Camera2D {
	offset   = {screenWidth / 2, screenHeight / 2},
	rotation = 0,
	target   = {0, 0},
	zoom     = 1,
}

main :: proc() {
	rl.InitWindow(screenWidth, screenHeight, "krig")
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

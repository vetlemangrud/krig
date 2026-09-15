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

WARRIORS_PER_TEAM := 20

main :: proc() {
	warriors:= make([dynamic]Warrior)
	for _ in 0..<WARRIORS_PER_TEAM {
		append(&warriors, Warrior{pos={f32(rl.GetRandomValue(-200,-50)),f32(rl.GetRandomValue(-100,100))},health=100, color=rl.RED})
		append(&warriors, Warrior{pos={f32(rl.GetRandomValue(50,200)),f32(rl.GetRandomValue(-100,100))},health=100, color=rl.BLUE})
	}
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "krig")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		for &warrior in warriors {
			apply_warrior_forces(&warrior, warriors[:])
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

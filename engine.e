note
	description: "Classe moteur du jeu"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "26 avril 2016"
	revision: "1.0"

class
	ENGINE

inherit

	GAME_LIBRARY_SHARED -- To use `game_library'

create
	make

feature {NONE}

	make
		local
			l_window_builder: GAME_WINDOW_SURFACED_BUILDER
			le_thread: UN_THREAD
		do
			create FOND_IMAGE
			create oiseau
			create pipe
			create sol
			create random
			create texts.make
			create font.make ("font.ttf", 16)
			if font.is_openable then
				font.open
				has_error := not font.is_open
			else
				has_error := True
			end
				--create son

			create l_window_builder
			l_window_builder.set_title ("Flippy bird")
			if not FOND_IMAGE.has_error then
				l_window_builder.set_dimension (800, 600) --Create a 800(widht) X 600(height) window
			end
			window := l_window_builder.generate_window
			create le_thread.make ("test")
			has_error := FOND_IMAGE.has_error or oiseau.has_error or window.has_error
		end

feature -- Access

	run
			-- Create ressources and launch the game
		do
			print(points)
			tuyaux_suivant := 0
			points := 0
			texts.extend ([400, 400, {STRING_32} "Click somewhere and start typing"])
			oiseau.y := 250
			oiseau.x := 250
			pipe.x := 450
			pipe.change_y
			game_library.quit_signal_actions.extend (agent on_quit)
			window.key_pressed_actions.extend (agent on_key_pressed)
			window.key_released_actions.extend (agent on_key_released)
			game_library.iteration_actions.extend (agent on_iteration)
			game_library.launch
		end

	has_error: BOOLEAN
			-- `True' if an error occured during the creation of `Current'

	FOND_IMAGE: FOND_IMAGE --Background

	oiseau: OISEAU

	pipe: TUYAUX

	sol: SOL

		--son:SON

	window: GAME_WINDOW_SURFACED

	oiseau_y: INTEGER_32

	pipe_mid_bas: INTEGER

	pipe_y: INTEGER_32

	pipe_x: INTEGER_32

	texts: LINKED_LIST [TUPLE [x, y: INTEGER; text: STRING_32]]

	random: NOMBRE_RANDOM

	font: TEXT_FONT

	i: INTEGER

	ok: INTEGER

	points: INTEGER

	pipe_mid_haut: INTEGER

	total: INTEGER

	tuyaux_suivant: INTEGER

feature {NONE} -- Implementation

	on_iteration (a_timestamp: NATURAL_32)

			-- Event that is launch at each iteration.

		local
			l_text_surface: TEXT_SURFACE_BLENDED
			l_color: GAME_COLOR
		do
			oiseau_y := 100
			oiseau_y := oiseau.y
				--pipe_x := 450
			pipe_x := pipe.x
			pipe_mid_bas := pipe.y + 420
			pipe_mid_haut := pipe.y + 327
				--points := 0
			oiseau.update (a_timestamp) -- Update oiseau animation and coordinate
			pipe.update (a_timestamp)


				--print(pipe.y)
				-- Be sure that the bird does not get out of the screen
			if oiseau.x < 0 then
				oiseau.x := 0
			end


			if oiseau.x + 20 = pipe_x+tuyaux_suivant + pipe.width then
				tuyaux_suivant := tuyaux_suivant + 300
				points:=points+1
				print(points)
			end

			if oiseau.y <= pipe_mid_haut and oiseau.x + 20 >= pipe_x + tuyaux_suivant and oiseau.x <= pipe_x + tuyaux_suivant + pipe.width then
				oiseau.rip_on (a_timestamp)


				end

			if oiseau.y >= pipe_mid_bas and oiseau.x + 20 >= pipe_x + tuyaux_suivant and oiseau.x <= pipe_x + tuyaux_suivant + pipe.width then
				oiseau.rip_on (a_timestamp)

				end

			if oiseau.rip = True then
				pipe.stop_scroll (a_timestamp)
				oiseau.stop_oiseau (a_timestamp)
				end



				-- Draw the scene
			i := 0
			window.surface.draw_surface (FOND_IMAGE, 0, 0)
				--	window.surface.draw_surface (pipe, 200,pipe.y)
			window.surface.draw_surface (oiseau.surface, 200, oiseau_y)
				--	window.surface.draw_surface (pipe, pipe_x,pipe.y)
			window.surface.draw_surface (sol, 0, 550)
			window.surface.draw_surface (sol, 420, 550)
			from
				i := 0
			until
				i >= 100
			loop
				window.surface.draw_surface (pipe, pipe_x, pipe.y)
				pipe_x := pipe_x + 300
				i := i + 1
					--	if oiseau.y = pipe.y then
					--	oiseau.stop_oiseau (a_timestamp)

					--end
			end
			window.update -- Update modification in the screen
		end

	on_key_pressed (a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action when a keyboard key has been pushed
		do
			if not a_key_state.is_repeat then -- Be sure that the event is not only an automatic repetition of the key
				if a_key_state.is_space then
					if oiseau.rip = False then
						pipe.scroll (a_timestamp)
					end
					oiseau.jeu_actif_on (a_timestamp)
					oiseau.go_up (a_timestamp)
				end
			end
		end

	on_key_released (a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action when a keyboard key has been released
		do
			if not a_key_state.is_repeat then -- I don't know if a key release can repeat, but you never know...
				if a_key_state.is_space then
					oiseau.go_down (a_timestamp)
				elseif a_key_state.is_left then
				end
			end
		end

	on_quit (a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop -- Stop the controller loop (allow game_library.launch to return)
		end

end

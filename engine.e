note
	description: "Classe moteur du jeu"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "5 Avril 2016"
	revision: "1.0"
class
	ENGINE

inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization of `Current'
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER


		do
			create FOND_IMAGE
			create oiseau
			create pipe
			create sol



			create l_window_builder
			l_window_builder.set_title ("Flippy bird")
			if not FOND_IMAGE.has_error then
				l_window_builder.set_dimension (800, 600)
			end
			window := l_window_builder.generate_window
			has_error := FOND_IMAGE.has_error or oiseau.has_error or window.has_error
		end

feature -- Access

	run
			-- Create ressources and launch the game
		do
			oiseau.y := 200
			oiseau.x := 250
			pipe.x:=450
			pipe.y:=-100
			game_library.quit_signal_actions.extend (agent on_quit)
			window.key_pressed_actions.extend (agent on_key_pressed)
			window.key_released_actions.extend (agent on_key_released)
			game_library.iteration_actions.extend (agent on_iteration)
			game_library.launch
		end

	has_error:BOOLEAN
			-- `True' if an error occured during the creation of `Current'

	FOND_IMAGE:FOND_IMAGE
			-- The background

	oiseau:oiseau


	pipe:TUYAUX
			-- The main character of the game
	sol:SOL

	window:GAME_WINDOW_SURFACED

	oiseau_y : INTEGER_32
			-- The window to draw the scene

	pipe_y: INTEGER_32

	pipe_x:INTEGER_32


feature {NONE} -- Implementation

--	set_tuyaux
--	do
--		oiseau.y:=oiseau.y-1

--	end

	on_iteration(a_timestamp:NATURAL_32)

	-- Event that is launch at each iteration.
		do
			oiseau_y:=100
			oiseau_y:=oiseau.y
			pipe_x:=450
			pipe_x:=pipe.x

			oiseau.update (a_timestamp)	-- Update oiseau animation and coordinate
			pipe.update (a_timestamp)
			-- Be sure that oiseau does not get out of the screen
			if oiseau.x < 0 then
				oiseau.x := 0





--			elseif oiseau.x + oiseau.sub_image_width > FOND_IMAGE.width then
--				oiseau.x := FOND_IMAGE.width - oiseau.sub_image_width

			end


			-- Draw the scene

			window.surface.draw_surface (FOND_IMAGE, 0, 0)
			window.surface.draw_surface (pipe, 200, 0)
			window.surface.draw_surface(oiseau.surface, 200, oiseau_y)
			window.surface.draw_surface (pipe, pipe_x, -100)
			window.surface.draw_surface (sol,0,550)
			window.surface.draw_surface (sol,420,550)





			-- Update modification in the screen
			window.update
		end


	on_key_pressed(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action when a keyboard key has been pushed
		do
			if not a_key_state.is_repeat then		-- Be sure that the event is not only an automatic repetition of the key
				if a_key_state.is_space then
					pipe.scroll(a_timestamp)
					oiseau.go_up(a_timestamp)

				end
			end

		end

	on_key_released(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action when a keyboard key has been released
		do
			if not a_key_state.is_repeat then		-- I don't know if a key release can repeat, but you never know...
				if a_key_state.is_space then
				oiseau.go_down(a_timestamp)
				elseif a_key_state.is_left then

				end
			end
		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

end

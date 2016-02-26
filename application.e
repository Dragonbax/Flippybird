note
	description : "flippybird application root class"
	date        : "$Date$"
	revision    : "$Revision$"


class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED

	IMG_LIBRARY_SHARED
	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			Game_library.enable_video
			Image_file_library.enable_image (True, True, True)
			run_game
			Image_file_library.quit_library
			Game_library.quit_library
		end

	run_game

			-- Create ressources and launch the game
		local
			l_window_builder: GAME_WINDOW_SURFACED_BUILDER
			l_desert: BACKGROUND
			l_window: GAME_WINDOW_SURFACED
			l_background, l_bird:GAME_SURFACE
			l_cadre: CADRE_IMAGE
		do
			create l_cadre.make
		--	l_window:=create_window
		--	l_background:=create_surface("city.jpg")	-- The background is in a png file
		--	l_bird:=create_surface("bird.png")	-- The bird is in a png file

		--	l_window.surface.draw_surface (l_background, 0, 0)		-- Drawing a background
		--	l_window.surface.draw_surface (l_bird, 500, 400)		-- Drawing a bird (over the background)

		--	create l_desert
		--	if not l_desert.has_error then
		--			create l_window_builder
		--			l_window_builder.set_dimension (800, 600)
		--			l_window_builder.set_title ("Example Animation")
		--			l_window := l_window_builder.generate_window
		--			Game_library.iteration_actions.extend (agent on_iteration (?, l_desert, l_window))

		--			Game_library.launch


		--	else
		--		print ("Cannot create the desert surface.")
		--	end
		end

--feature {NONE} -- Implementation

--	on_iteration (a_timestamp: NATURAL_32; a_desert: GAME_SURFACE; l_window: GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
--		do
--			l_window.surface.draw_rectangle (create {GAME_COLOR}.make_rgb (0, 128, 255), 0, 0, 800, 600)
		--	l_window.surface.draw_surface (a_desert, 0, 0)
		--	l_window.update
--		end



end -- class APPLICATION


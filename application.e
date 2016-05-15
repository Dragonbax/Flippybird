note
	description: "Un simili-clone du jeu Flappy bird,ici nommé Flippy Bird"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "26 avril 2016"
	revision: "1.0"
class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	IMG_LIBRARY_SHARED
	TEXT_LIBRARY_SHARED
	AUDIO_LIBRARY_SHARED	-- To use `image_file_library'

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_engine:detachable ENGINE
		do
			game_library.enable_video -- Enable the video functionalities
			image_file_library.enable_image (true, false, false)  -- Enable PNG image (but not TIF or JPG).
			text_library.enable_text
			audio_library.enable_sound
			create l_engine.make
			if not l_engine.has_error then
				l_engine.run
			end
			l_engine := Void				-- To be sure that the garbage collector can collect everything before quitting the libraries
			game_library.clear_all_events	-- To be sure that an object is not stocked inside an event agent
			image_file_library.quit_library  -- Correctly unlink image files library
			game_library.quit_library
			text_library.quit_library
			audio_library.quit_library  -- Clear the library before quitting
		end


end

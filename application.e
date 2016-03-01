note
	description : "flippybird application root class"
	date        : "$Date$"
	revision    : "$Revision$"


class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	IMG_LIBRARY_SHARED


create
	make

feature {NONE}

	make

		do
			Game_library.enable_video
			Image_file_library.enable_image (True, True, True)
			run_game
			Image_file_library.quit_library
			Game_library.quit_library
		end

	run_game


		local
			cadre_jeu: CADRE_IMAGE
		do
			create cadre_jeu.make
		end



end


note
	description: "Un simili-clone du jeu Flappy bird,ici nommé Flippy Bird"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "26 mai 2016"
	revision: "1.0"

class
	APPLICATION

inherit

	GAME_LIBRARY_SHARED

	IMG_LIBRARY_SHARED


	AUDIO_LIBRARY_SHARED
create
	make

feature {NONE}

	make

		local
			l_engine: detachable ENGINE
		do
			game_library.enable_video -- Active les fonctions videos
			image_file_library.enable_image (true, false, false)
			audio_library.enable_sound --Active les fonctions audios
			create l_engine.make
			if not l_engine.has_error then
				l_engine.demarrer
			end
			l_engine := Void
			game_library.clear_all_events
			image_file_library.quit_library
			game_library.quit_library
			audio_library.quit_library -- Vide la librairie avant de quitter
		end

end

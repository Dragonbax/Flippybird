note
	description: "Un simili-clone du jeu Flappy bird,ici nommé Flippy Bird"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "17 mai 2016"
	revision: "1.0"

class
	APPLICATION

inherit

	GAME_LIBRARY_SHARED -- To use `game_library'

	IMG_LIBRARY_SHARED

	TEXT_LIBRARY_SHARED

	AUDIO_LIBRARY_SHARED -- To use `image_file_library'

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_engine: detachable ENGINE
		do
			game_library.enable_video -- Active les fonctions videos
			image_file_library.enable_image (true, false, false) --Active les images PNG(seulement PNG)
			text_library.enable_text
			audio_library.enable_sound --Active les fonctions audios
			create l_engine.make
			if not l_engine.has_error then
				l_engine.run
			end
			l_engine := Void -- Pour s'assurer que le "garbage collector" ramasse tout avant de quitter les librairies
			game_library.clear_all_events -- Pour s'assurer qu'un objet n'est pas "pris" dans un agent d'evenement
			image_file_library.quit_library -- Détache correctement les fichiers d'images
			game_library.quit_library
			text_library.quit_library
			audio_library.quit_library -- Vide la librairie avant de quitter
		end

end

note
	description: "Classe représentant le sol du jeu"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "26 mai 2016"
	revision: "1.0"

class
	SOL

inherit

	GAME_SURFACE
		redefine
			default_create
		end

create
	default_create

feature {NONE}

	default_create
	require else
			game_library.is_events_enable

		local
			l_image: IMG_IMAGE_FILE
		do
			--crée l'image du sol
			create l_image.make ("ground.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					make_from_image (l_image)
				else
					has_error := True
					make (1, 1)
				end
			else
				has_error := True
				make (1, 1)
			end
		end

end

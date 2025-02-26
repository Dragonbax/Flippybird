note
	description: "Classe repr�sentant l'image de fond du jeu"
	author: "F�lix-Olivier Lafleur-Duhamel(inspir� du code de Louis Marchand)"
	date: "26 mai 2016"
	revision: "1.0"

class
	FOND_IMAGE

inherit

	GAME_SURFACE
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		local
			l_image: IMG_IMAGE_FILE
		do
			create l_image.make ("city.jpg")
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

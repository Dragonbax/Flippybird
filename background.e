note
	description: "Summary description for {BACKGROUND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BACKGROUND
inherit
	GAME_SURFACE
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Process instances of classes with no creation clause.
			-- (Default: do nothing.)
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

end -- class DESERT




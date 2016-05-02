note
	description: "Classe représentant les tuyaux du jeu"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "26 avril 2016"
	revision: "1.0"

class
	TUYAUX

inherit

	GAME_SURFACE
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	distance_entre: INTEGER

	default_create
		local
			l_image: IMG_IMAGE_FILE
		do
			create rando
			create l_image.make ("pipe_one_img.png")
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
			initialize_animation_coordinate
		end

	initialize_animation_coordinate
			-- Create the `animation_coordinates'
		do
			create {ARRAYED_LIST [TUPLE [x, y: INTEGER]]} xety.make (1)
		end

feature -- Access

	update (a_timestamp: NATURAL_32)
			-- Update the surface depending on the present `a_timestamp'.
			-- Each 100 ms, the image change; each 10ms `Current' is moving
		local
				--l_coordinate:TUPLE[x,y:INTEGER]
			l_delta_time: NATURAL_32
			oiseau: oiseau
		do
			if scroll_On = True then
				x := x - 1
				scroll_off := False

			elseif scroll_off then
				if x >= 490 then
					stop_scroll (a_timestamp)
				end
				x := x + 2
			end
			old_timestamp := old_timestamp + (l_delta_time // movement_delta) * movement_delta
		end

	not_scroll (a_timestamp: NATURAL_32)
		do
			old_timestamp := a_timestamp
			scroll_On := False
			scroll_off := True
		end

	scroll (a_timestamp: NATURAL_32)

		do
			old_timestamp := a_timestamp
			scroll_On := True
		end

	stop_scroll (a_timestamp: NATURAL_32)
		do
			old_timestamp := a_timestamp
			scroll_On := False
			scroll_off := False
			y := y
		end

	scroll_off: BOOLEAN
			-- Is `Current' moving left

	scroll_On: BOOLEAN
			-- Is `Current' moving right

	x: INTEGER assign set_x
			-- Vertical position of `Current'

	y: INTEGER
			-- Horizontal position of `Current'

	set_x (a_x: INTEGER)
			-- Assign the value of `x' with `a_x'
		do
			x := a_x
		ensure
			Is_Assign: x = a_x
		end

	change_y
			-- Assign the value of `y' with `a_y'
		do
			rando.gen_random
			y := rando.y_random
		end


feature {NONE} -- implementation

	rando: NOMBRE_RANDOM

	old_timestamp: NATURAL_32
			-- When appen the last movement (considering `movement_delta')

feature {NONE} -- constants

	movement_delta: NATURAL_32 = 10
			-- The delta time between each movement of `Current'

	animation_delta: NATURAL_32 = 100

	xety: LIST [TUPLE [x, y: INTEGER]]
			-- The delta time between each animation of `Current'

end

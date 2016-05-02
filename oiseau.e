note
	description: "Classe repr�sentant l'oiseau du jeu"
	author: "F�lix-Olivier Lafleur-Duhamel(inspir� du code de Louis Marchand)"
	date: "26 avril 2016"
	revision: "1.0"

class
	OISEAU

inherit

	GAME_LIBRARY_SHARED
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create

			-- Initialization of `Current'
		local
			l_image: IMG_IMAGE_FILE
		do
			create surface.make (50, 50)
			create random
			has_error := False
			create l_image.make ("rsz_bird.png")
			if l_image.is_openable then
				l_image.open
				create surface.make_from_image (l_image)
			else
				has_error := False
			end
			initialize_xy
		end

	initialize_xy
			-- Create the `xety'
		do
			create {ARRAYED_LIST [TUPLE [x, y: INTEGER]]} xety.make (4)
		end

feature -- Access

	has_error: BOOLEAN
			-- Is an error happen when initializing the `surface'

	update (a_timestamp: NATURAL_32)
			-- Update the surface depending on the present `a_timestamp'.
			-- Each 100 ms, the image change; each 10ms `Current' is moving
		local
				--l_coordinate:TUPLE[x,y:INTEGER]
			l_delta_time: NATURAL_32
		do
			if going_up then
				if y <= -10 then --make sure that the bird cannot go higher than the window height
					stop_oiseau (a_timestamp)
				elseif rip = True then
					stop_oiseau (a_timestamp)
				else
					y := y - 2
				end
				jeu_actif := True
			elseif going_down then
				if y >= 490 then --make sure that the bird cannot go lower than the ground
					stop_oiseau (a_timestamp)
					rip := True

				else
					y := y + 2
				end
			end
			old_timestamp := old_timestamp + (l_delta_time // movement_delta) * movement_delta
		end

	go_down (a_timestamp: NATURAL_32)
		do
			old_timestamp := a_timestamp
			going_up := False
			going_down := True
		end

	go_up (a_timestamp: NATURAL_32)
		do
			old_timestamp := a_timestamp
			going_up := True
		end

	stop_oiseau (a_timestamp: NATURAL_32)
		do
			old_timestamp := a_timestamp
			going_up := False
			going_down := False
			y := y
		end

	rip: BOOLEAN

	jeu_actif: BOOLEAN

	jeu_actif_on (a_timestamp: NATURAL_32)
		do
			old_timestamp := a_timestamp
			jeu_actif := True
		end

	rip_on (a_timestamp: NATURAL_32)
		do
			old_timestamp := a_timestamp
			rip := True
		end

	going_down: BOOLEAN
			-- Is `Current' moving left

	going_up: BOOLEAN
			-- Is `Current' moving right

	x: INTEGER assign set_x
			-- Vertical position of `Current'

	y: INTEGER assign set_y

	random: NOMBRE_RANDOM

	set_x (a_x: INTEGER)
			-- Assign the value of `x' with `a_x'
		do
			x := a_x
		ensure
			Is_Assign: x = a_x
		end

	set_y (a_y: INTEGER)
			-- Assign the value of `y' with `a_y'
		do
			y := a_y
		ensure
			Is_Assign: y = a_y
		end

	surface: GAME_SURFACE

feature {NONE} -- implementation

	xety: LIST [TUPLE [x, y: INTEGER]]

	old_timestamp: NATURAL_32
			-- When appen the last movement (considering `movement_delta')

feature {NONE} -- constants

	movement_delta: NATURAL_32 = 10
			-- The delta time between each movement of `Current'

	animation_delta: NATURAL_32 = 100
			-- The delta time between each animation of `Current'

end

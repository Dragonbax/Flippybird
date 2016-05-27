note
	description: "Classe représentant les tuyaux du jeu"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "26 mai 2016"
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

feature {NONE}

	default_create
		local
			l_image: IMG_IMAGE_FILE
		do
			create rando
			create l_image.make ("pipe_one_img.png") --Crée l'image des tuyaux
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

feature -- Access

	actualiser (a_timestamp: NATURAL_32)
			-- Met à jour l'image de tuyaux dependemment du 'a_timestamp'
		require else
			game_library.is_events_enable
		local
			l_delta_time: NATURAL_32
		do
			if defilement_on = True then
				x := x - Vitesse_tuyaux
				defilement_off := False
					--conditions qui fais un défilement des tuyaux vers la gauche tant que defilement_on est vrai
			elseif defilement_off then
				if x >= 490 then
					arret_defilement (a_timestamp)
				end
					--Arrête le defilement des tuyaux si defilement_off est vrai

			end
			old_timestamp := old_timestamp + (l_delta_time // movement_delta) * movement_delta
		end

	non_defilement (a_timestamp: NATURAL_32)
		do
			old_timestamp := a_timestamp
			defilement_on := False
			defilement_off := True
		end

	defilement (a_timestamp: NATURAL_32)
			--active le défilement des tuyaux

		do
			old_timestamp := a_timestamp
			defilement_on := True
		end

	arret_defilement (a_timestamp: NATURAL_32)
			--arrête les défilement des tuyaux
		do
			old_timestamp := a_timestamp
			defilement_on := False
			defilement_off := False
			y := y
		end

	defilement_off: BOOLEAN
			--Variable qui indique que les tuyaux ne défilent pas

	defilement_on: BOOLEAN
			--Variable qui indique que les tuyaux défilent

	x: INTEGER assign assigne_x_tuyau
			--position X du tuyaux assigne par assigne_x_tuyau

	y: INTEGER
			--position Y du tuyaux assigne par set_y

	assigne_x_tuyau (a_x: INTEGER)
			--Assigne la valeur de x a a_x
		do
			x := a_x
		ensure
			Is_Assign: x = a_x
		end

	change_y
			--génère un nombre aleatoire pour la position Y des tuyaux

		do
			rando.gen_random
			y := rando.nombre_aleatoire
		ensure
			Is_Assign: y = rando.nombre_aleatoire
		end

feature {NONE}

	rando: NOMBRE_RANDOM
			--identifie la classe NOMBRE_RANDOM

	old_timestamp: NATURAL_32
			-- Quand arrive le dernier mouvement

feature {NONE} -- constantes

	movement_delta: NATURAL_32 = 10
			-- Le temps delta entre chaque mouvement de 'Current'

	animation_delta: NATURAL_32 = 100

	Vitesse_tuyaux: INTEGER = 1
			--La vitesse de déplacement des tuyaux

end

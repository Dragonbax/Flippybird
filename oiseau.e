note
	description: "Classe représentant l'oiseau du jeu"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "26 mai 2016"
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

feature {NONE}

	default_create
		require else
			game_library.is_events_enable
		local
			l_image: IMG_IMAGE_FILE
		do
				--Crée la surface(image) de l'oiseau
			create surface.make (50, 50)
			create aleatoire
			erreur := False
			create l_image.make ("rsz_bird.png")
			if l_image.is_openable then
				l_image.open
				create surface.make_from_image (l_image)
			else
				erreur := False
			end

		end


feature -- Access

	erreur: BOOLEAN
			-- Si une erreur survient lors de l'initialisation de la surface

	actualiser (a_timestamp: NATURAL_32)
			-- Met à jour la surface de l'oiseau dépendemment du a_timestamp.
			--Met à jour la position Y de l'oiseau
		local
			l_delta_time: NATURAL_32
		do
			if oiseau_monte then
				if y <= -10 then --S'assure que l'oiseau ne peut pas aller plus haut que le haut de la fenêtre
					stop_oiseau (a_timestamp)
				elseif mort = True then
					stop_oiseau (a_timestamp)
				else
					y := y - Vitesse_oiseau
				end
					--	jeu_actif := True
			elseif oiseau_descend then
				if y >= 490 then --S'assure que l'oiseau ne peut aller plus bas que le sol
					stop_oiseau (a_timestamp)
					mort := True
				else
					y := y + Vitesse_oiseau
				end
			end
			old_timestamp := old_timestamp + (l_delta_time // movement_delta) * movement_delta
		end

	descend_oiseau (a_timestamp: NATURAL_32)
			-- Fais descendre l'oiseau
		do
			old_timestamp := a_timestamp
			oiseau_monte := False
			oiseau_descend := True
		end

	monte_oiseau (a_timestamp: NATURAL_32)
			--Fais monter l'oiseau
		do
			old_timestamp := a_timestamp
			oiseau_monte := True
		end

	stop_oiseau (a_timestamp: NATURAL_32)
			--Arrête le mouvement de l'oiseau
		do
			old_timestamp := a_timestamp
			oiseau_monte := False
			oiseau_descend := False
			y := y
		end

	mort: BOOLEAN
			--Variable représentant la mort de l'oiseau("Game Over")



	mort_on (a_timestamp: NATURAL_32)
			--Met la variable mort a "True"

		do
			old_timestamp := a_timestamp
			mort := True
		end

	oiseau_descend: BOOLEAN
			-- L'oiseau descend

	oiseau_monte: BOOLEAN
			-- L'oiseau monte

	x: INTEGER assign assigne_x
			-- Assigne assigne_x à x représentant la position X de l'oiseau

	y: INTEGER assign assigne_y

		--Assigne assigne_y à y représentant la position Y de l'oiseau

	aleatoire: NOMBRE_RANDOM

		--Représente la classe générant un nombre aléatoire

	assigne_x (a_x: INTEGER)
			-- Assigne la valeur de x à a_x
		do
			x := a_x
		ensure
			Is_Assign: x = a_x
		end

	assigne_y (a_y: INTEGER)
			-- Assigne la valeur de y à a_y
		do
			y := a_y
		ensure
			Is_Assign: y = a_y
		end

	surface: GAME_SURFACE

feature {NONE}



	old_timestamp: NATURAL_32
			-- Quand le dernier mouvement arrive

feature {NONE} -- Constantes

	movement_delta: NATURAL_32 = 10
			-- Le temps delta entre chaque mouvement de `Current'

	animation_delta: NATURAL_32 = 100
			-- Le temps delta entre chaque animation de `Current'

	Vitesse_oiseau: INTEGER = 2

end

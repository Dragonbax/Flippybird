note
	description: "Classe moteur du jeu"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "17 mai 2016"
	revision: "1.0"

class
	ENGINE

inherit

	GAME_LIBRARY_SHARED -- To use `game_library'

create
	make

feature {NONE}

	make
		local
			l_window_builder: GAME_WINDOW_SURFACED_BUILDER
			le_thread: UN_THREAD
		do
			create image_de_fond
			create le_oiseau
			create pipe
			create sol
			create random
			create musique
			create l_window_builder
			l_window_builder.set_title ("Flippy bird")
			if not image_de_fond.has_error then
				l_window_builder.set_dimension (800, 600) --Créer une fenêtre de 800(largeur) X 600(hauteur)
			end
			window := l_window_builder.generate_window
			has_error := image_de_fond.has_error or le_oiseau.has_error or window.has_error
		end

feature -- Access

	run
			-- Create ressources and launch the game
		do
			print(points)
			tuyaux_suivant := 0
			points := 0
			le_oiseau.y := 250
			le_oiseau.x := 250
			pipe.x := 450
			pipe.change_y
			game_library.quit_signal_actions.extend (agent on_quit)
			window.key_pressed_actions.extend (agent on_key_pressed)
			window.key_released_actions.extend (agent on_key_released)
			game_library.iteration_actions.extend (agent on_iteration)
			game_library.launch
		end

	has_error: BOOLEAN
			-- `True' if an error occured during the creation of `Current'

	image_de_fond: FOND_IMAGE --Background

	le_oiseau: OISEAU

	pipe: TUYAUX

	sol: SOL

	musique: SON

	window: GAME_WINDOW_SURFACED

	oiseau_y: INTEGER_32

	pipe_mid_bas: INTEGER

	pipe_y: INTEGER_32

	pipe_x: INTEGER_32

	random: NOMBRE_RANDOM

	i: INTEGER

	points: INTEGER

	sc: SERVEUR_CLIENT

	pipe_mid_haut: INTEGER

	total: INTEGER

	le_pointage: INTEGER

	tuyaux_suivant: INTEGER

feature {NONE} -- Implementation

	on_iteration (a_timestamp: NATURAL_32) -- Evenement qui est lance a chaque iteration

		do
			oiseau_y := 100
			oiseau_y := le_oiseau.y
			pipe_x := pipe.x
			pipe_mid_bas := pipe.y + 427
			pipe_mid_haut := pipe.y + 327
			le_oiseau.update (a_timestamp) -- Update oiseau animation and coordinate
			pipe.update (a_timestamp)
			musique.audio_library.update

				-- S'assure que l'oiseau ne sort pas de l'ecran
			if le_oiseau.x < 0 then
				le_oiseau.x := 0
			end
			if le_oiseau.x + 15 = pipe_x + tuyaux_suivant + pipe.width then -- Lorsque l'oiseeau passe un tuyau
				tuyaux_suivant := tuyaux_suivant + 300 -- Ajoute 300px pour donner les coordonnees du prochain tuyau
				points := points + 1 --Additionne 1 points
				print (points)
			end
			if le_oiseau.y <= pipe_mid_haut and le_oiseau.x + 15 >= pipe_x + tuyaux_suivant and le_oiseau.x + 15 <= pipe_x + tuyaux_suivant + pipe.width then
				le_oiseau.rip_on (a_timestamp) --Permet d'identifier si l'oiseau touche a un tuyau(haut).Si c'est le cas, appelle oiseau.rip_on

			end
			if le_oiseau.y >= pipe_mid_bas and le_oiseau.x + 15 >= pipe_x + tuyaux_suivant and le_oiseau.x + 15 <= pipe_x + tuyaux_suivant + pipe.width then
				le_oiseau.rip_on (a_timestamp) --Permet d'identifier si l'oiseau touche a un tuyau(bas).Si c'est le cas, appelle oiseau.rip_on

			end
			if le_oiseau.rip = True then --Lorsque oiseau.rip egal a vrai, arrete l'oiseau et les tuyaux de bouger
				pipe.stop_scroll (a_timestamp)
				le_oiseau.stop_oiseau (a_timestamp)
			end

				-- Dessine les elements
			i := 0
			window.surface.draw_surface (image_de_fond, 0, 0)
				--	window.surface.draw_surface (pipe, 200,pipe.y)
			window.surface.draw_surface (le_oiseau.surface, 200, oiseau_y)
				--	window.surface.draw_surface (pipe, pipe_x,pipe.y)
			window.surface.draw_surface (sol, 0, 550)
			window.surface.draw_surface (sol, 420, 550)

				--Dessine les 100 tuyaux du jeu
			from
				i := 0
			until
				i >= 100
			loop
				window.surface.draw_surface (pipe, pipe_x, pipe.y)
				pipe_x := pipe_x + 300
				i := i + 1
			end
			window.update -- Met a jour les modifications dans l'ecran
		end

	on_key_pressed (a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action quand une touche de clavier a ete peser
		do
			if not a_key_state.is_repeat then -- Be sure that the event is not only an automatic repetition of the key
				if a_key_state.is_space then
					if le_oiseau.rip = False then
						pipe.scroll (a_timestamp)
					end
					le_oiseau.jeu_actif_on (a_timestamp)
					le_oiseau.go_up (a_timestamp)
				end
			end
		end

	on_key_released (a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action quand une touche de clavier n'est plus enfonce
		do
			if not a_key_state.is_repeat then
				if a_key_state.is_space then
					le_oiseau.go_down (a_timestamp)
				elseif a_key_state.is_left then
				end
			end
		end

	on_quit (a_timestamp: NATURAL_32) -- Methode appellee quand une demande de sortie est demandee.

		do
			le_pointage := points
			create sc.make (le_pointage)
			sc.set_pointage (le_pointage)
			game_library.stop --arrete la boucle du controlleur
		end

end

note
	description: "Classe moteur du jeu"
	author: "Félix-Olivier Lafleur-Duhamel(inspiré du code de Louis Marchand)"
	date: "26 mai 2016"
	revision: "1.0"

class
	ENGINE

inherit

	GAME_LIBRARY_SHARED
	--Pour utiliser 'game_library'

create
	make

feature {NONE}

	make
			--Constructeur de la fenêtre du jeu.Crée également les différents objets du jeu(image de fond,oiseau,tuyaux,etc..)
		local
			l_window_builder: GAME_WINDOW_SURFACED_BUILDER
			le_thread: UN_THREAD
		do
			create image_de_fond
			create flippy_oiseau
			create flippy_tuyaux
			create sol
			create random
			create musique
			create l_window_builder
			l_window_builder.set_title ("Flippy bird")
			if not image_de_fond.has_error then
				l_window_builder.set_dimension (800, 600) --Créer une fenêtre de 800(largeur) X 600(hauteur)
			end
			window := l_window_builder.generate_window
			has_error := image_de_fond.has_error or flippy_oiseau.erreur or window.has_error
		end

feature -- Access

	demarrer
		require else
			game_library.is_events_running
			-- Crée les agents de jeu et initialise des coordonnées
		do
			print (points)
			tuyaux_suivant := 0
			points := 0
			flippy_oiseau.y := 250
			flippy_oiseau.x := 250
			flippy_tuyaux.x := 450
			flippy_tuyaux.change_y
			game_library.quit_signal_actions.extend (agent quitter)
			window.key_pressed_actions.extend (agent touche_enfonce)
			window.key_released_actions.extend (agent touche_non_enfonce)
			game_library.iteration_actions.extend (agent sur_iteration)
			game_library.launch
		end

	has_error: BOOLEAN
			-- Vrai si une erreur survient durant la création de Current

	image_de_fond: FOND_IMAGE
			--Représente l'image de fond du jeu

	flippy_oiseau: OISEAU
			--Représente la classe oiseau

	flippy_tuyaux: TUYAUX
			--Représente les tuyaux qui seront générés dans le jeu

	sol: SOL
			--Represente le sol qui sera généré dans le jeu

	musique: SON
			--Représente la musique qui sera générée dans le jeu

	window: GAME_WINDOW_SURFACED
			--Représente la fenêtre du jeu

	oiseau_y: INTEGER_32
			--Représente la position Y de l'oiseau

	flippy_tuyaux_y: INTEGER_32
			--Représente la position Y des tuyaux

	flippy_tuyaux_x: INTEGER_32
			--Représente la position X des tuyaux

	random: NOMBRE_RANDOM
			--Représente la classe qui permet de généré un nombre aléatoire

	points: INTEGER
			--Représente le pointage du jeu

	sc: SERVEUR_CLIENT
			--Représente la classe dans laquelle sont envoyé les pointages au serveur de pointage

	tuyaux_suivant: INTEGER
			--Représente la position X du tuyau suivant(après que l'oiseau l'ai traversé)

feature {NONE} -- Implementation

	sur_iteration (a_timestamp: NATURAL_32)
			-- Événement qui est lancé à chaque iteration
		local
			l_i: INTEGER
				--Variable pour la boucle
			l_flippy_tuyaux_milieu_bas: INTEGER
				--Identifie la position(x et y) du tuyaux du bas(lorsque l'oiseau le traverse)
			l_flippy_tuyaux_milieu_haut: INTEGER
			--Identifie la position(x et y) du tuyaux du haut(lorsque l'oiseau le traverse)

		do
			oiseau_y := 100
			oiseau_y := flippy_oiseau.y
			flippy_tuyaux_x := flippy_tuyaux.x
			l_flippy_tuyaux_milieu_bas := flippy_tuyaux.y + 427
			l_flippy_tuyaux_milieu_haut := flippy_tuyaux.y + 327
			flippy_oiseau.actualiser (a_timestamp)
				--Met à jour les coordonnées de l'oiseau
			flippy_tuyaux.actualiser (a_timestamp)
				--Met à jour la position X des tuyaux
			musique.audio_library.update
				--Met à jour les buffers de la librarie audio

			if flippy_oiseau.x < 0 then
				flippy_oiseau.x := 0
					-- S'assure que l'oiseau ne sort pas de l'ecran
			end
			if flippy_oiseau.x + 15 = flippy_tuyaux_x + tuyaux_suivant + flippy_tuyaux.width then -- Lorsque l'oiseeau passe un tuyau
				tuyaux_suivant := tuyaux_suivant + 300 -- Ajoute 300px pour donner les coordonnées du prochain tuyau
				points := points + 1 --Additionne 1 points
				print (points)
			end
			if flippy_oiseau.y <= l_flippy_tuyaux_milieu_haut and flippy_oiseau.x + 15 >= flippy_tuyaux_x + tuyaux_suivant and flippy_oiseau.x + 15 <= flippy_tuyaux_x + tuyaux_suivant + flippy_tuyaux.width then
				flippy_oiseau.mort_on (a_timestamp) --Permet d'identifier si l'oiseau touche à un tuyau(haut).Si c'est le cas, appelle oiseau.mort_on

			end
			if flippy_oiseau.y >= l_flippy_tuyaux_milieu_bas and flippy_oiseau.x + 15 >= flippy_tuyaux_x + tuyaux_suivant and flippy_oiseau.x + 15 <= flippy_tuyaux_x + tuyaux_suivant + flippy_tuyaux.width then
				flippy_oiseau.mort_on (a_timestamp) --Permet d'identifier si l'oiseau touche à un tuyau(bas).Si c'est le cas, appelle oiseau.mort_on

			end
			if flippy_oiseau.mort = True then --Lorsque oiseau.mort égal à vrai, arrête l'oiseau et les tuyaux de bouger
				flippy_tuyaux.arret_defilement (a_timestamp)
				flippy_oiseau.stop_oiseau (a_timestamp)
			end

				-- Dessine les éléments
			l_i := 0
			window.surface.draw_surface (image_de_fond, 0, 0)
			window.surface.draw_surface (flippy_oiseau.surface, 200, oiseau_y)
			window.surface.draw_surface (sol, 0, 550)
			window.surface.draw_surface (sol, 420, 550)

				--Dessine les 100 tuyaux du jeu
			from
				l_i := 0
			until
				l_i >= 100
			loop
				window.surface.draw_surface (flippy_tuyaux, flippy_tuyaux_x, flippy_tuyaux.y)
				flippy_tuyaux_x := flippy_tuyaux_x + 300
				l_i := l_i + 1
			end
			window.update
				-- Met à jour les modifications dans l'écran
		end

	touche_enfonce (a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action quand une touche de clavier a été enfoncée
		do
			if not a_key_state.is_repeat then
				if a_key_state.is_space then
					if flippy_oiseau.mort = False then
						flippy_tuyaux.defilement (a_timestamp)
					end
						--	flippy_oiseau.jeu_actif_on (a_timestamp)
					flippy_oiseau.monte_oiseau (a_timestamp)
				end
			end
		end

	touche_non_enfonce (a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Action quand une touche de clavier n'est plus enfoncée
		do
			if not a_key_state.is_repeat then
				if a_key_state.is_space then
					flippy_oiseau.descend_oiseau (a_timestamp)
				elseif a_key_state.is_left then
				end
			end
		end

	quitter (a_timestamp: NATURAL_32)
			-- Méthode appellée quand une demande de sortie est demandée.
		local
			a_pointage: INTEGER
			--Représente une variable dans laquelle sera transféré les points pour ensuite être envoyé au serveur de pointage

		do
			a_pointage := points
					create sc.make (a_pointage)
					sc.set_pointage (a_pointage)
					game_library.stop
				--arrête la boucle du contrôlleur
		end

end

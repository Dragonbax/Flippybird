note
	description: "Serveur de pointage pour le jeu Flippybird"
	author: "Félix-Olivier Lafleur-Duhamel"
	date: "17 mai 2016"
	revision: "1.0"

class
	APPLICATION

inherit

	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			arret (false)
			create fichier_txt_serveur.make_with_name ("dossier/serveur.txt")
			affiche_pointage
			create le_thread.make (fichier_txt_serveur)
			le_thread.launch
			from
			until
				stop = True
			loop
				io.read_character
				if io.last_character = '0' then
					arret (true)
				end
			end
			le_thread.stop_thread
			le_thread.join
		end

feature

	le_thread: UN_THREAD

	fichier_txt_serveur: PLAIN_TEXT_FILE  --le fichier texte contenant les pointages

	stop: BOOLEAN --Pour la fermeture du serveur

feature

	arret (le_stop: BOOLEAN) -- Assigne la valeur a stop

		do
			stop := le_stop
		end

feature

	affiche_pointage --Lit et affiche  les pointages enregistres dans le fichier_txt_serveur

		do
			print ("Pointage%N")
			fichier_txt_serveur.open_read
			from
			until
				fichier_txt_serveur.end_of_file
			loop
				fichier_txt_serveur.read_line
				io.put_string (fichier_txt_serveur.last_string + "%N")
			end
			fichier_txt_serveur.close
		end

	quit -- Quitter le serveur

		do
			stop := true
		end

end

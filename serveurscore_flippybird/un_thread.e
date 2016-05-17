note
	description: "Classe qui crée un serveur sur un thread"
	author: "Félix-Olivier Lafleur-Duhamel"
	date: "17 mai 2016"
	revision: "1.0"

class
	UN_THREAD

inherit

	THREAD
		rename
			make as make_thread
		end

create
	make

feature 

	make (le_fichier: PLAIN_TEXT_FILE)
		do
			make_thread
			set_stop (false)
			fichier := le_fichier
		end

feature

	un_port: INTEGER assign set_port --Identifie le port à utiliser

	socket_serveur: NETWORK_STREAM_SOCKET --Le socket du serveur

	socket_client: NETWORK_STREAM_SOCKET --Le socket du client

	adresse_client: NETWORK_SOCKET_ADDRESS -- Identifie l'adresse du client du serveur

	adresse_serveur: NETWORK_SOCKET_ADDRESS --Identifie l'adresse du serveur

	stop: BOOLEAN --Pour la fermeture du serveur

	fichier: PLAIN_TEXT_FILE --Fichier texte dans lequel sont contenu les pointages

feature

	set_port (le_port: INTEGER) --Donne le no de port
		do
			un_port := le_port
		end

	set_stop (a_stop: BOOLEAN) --Assigne a stop

		do
			stop := a_stop
		end

	execute -- Execution (thread) de `Current'

		do
			creer_socket_serveur
			from
			until
				stop = True
			loop
				socket_serveur.listen (1)
				if not stop then
					socket_serveur.accept
					socket_client := socket_serveur.accepted
					if socket_client = Void then
						io.put_string ("Le client est introuvable")
					else
						adresse_client := socket_client.peer_address
						socket_client.read_line
						ajout_pointage (socket_client.last_string)
						print ("Dernier pointage:" + socket_client.last_string + "%N")
						socket_client.close
					end
				end
			end
		end

	ajout_pointage (le_pointage: STRING) -- Ajoute un nouveau pointage au fichier

		do
			fichier.open_read_append
			fichier.put_string ("%N" + le_pointage)
			fichier.close
		end

	creer_socket_serveur --Cree le socket pour le serveur

		do
			set_port (50000)
			create socket_serveur.make_server_by_port (un_port)
			if not socket_serveur.is_bound then
				print ("Le port " + un_port.out + "est indisponible.%N")
			else
				adresse_serveur := socket_serveur.address
			end
		end

feature

	stop_thread --Arrete serveur

		do
			socket_serveur.close
			stop := true
		end

end

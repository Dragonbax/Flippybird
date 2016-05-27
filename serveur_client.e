note
	description: "Client qui envoie les points au serveur de pointage"
	author: "Félix-Olivier Lafleur-Duhamel"
	date: "26 mai 2016"
	revision: "1.0"

class
	SERVEUR_CLIENT

create
	make

feature {NONE} -- Initialization

	make (a_pointage: INTEGER)
		do
			set_pointage (a_pointage)
			create factory_adresse
			set_nom_adresse ("localhost")
			set_port (50000)
			connexion
		end

feature

	factory_adresse: INET_ADDRESS_FACTORY
			-- La "factory" d'adresses

	adresse: INET_ADDRESS
			--adresse IP

	nom_adresse: STRING
			--identifie l'adresse

	socket: NETWORK_STREAM_SOCKET
			--le socket

	connexion_succes: BOOLEAN
			--identifie si la connexion au serveur a ete faite

	l_port: INTEGER
			--le numero de port

	resultat: STRING
			-- identifie le pointage a envoyer

	pointage: INTEGER
			-- le pointage envoye au serveur

	set_port (a_port: INTEGER)
			-- Assigne au port

		do
			l_port := a_port
		ensure
			l_port = a_port
		end

	set_nom_adresse (a_nom_adresse: STRING)
			-- Assigne a l'adresse

		do
			nom_adresse := a_nom_adresse
		ensure
			nom_adresse = a_nom_adresse
		end

	set_pointage (a_pointage: INTEGER)
			-- Assigne au pointage

		do
			pointage := a_pointage
		ensure
			pointage = a_pointage
		end

	set_resultat (a_resultat: STRING)
			-- Assigne au resultat

		do
			resultat := a_resultat
		ensure
			resultat = a_resultat
		end

	set_connexion_succes (a_connexion_succes: BOOLEAN)
			-- Assigne a connexion_succes

		do
			connexion_succes := a_connexion_succes
		ensure
			connexion_succes = a_connexion_succes
		end

	connexion
			-- essai de se connecter au serveur

		do
			adresse := factory_adresse.create_from_name (nom_adresse)
			if adresse = Void then
				print ("L'Adresse" + nom_adresse + " ne peut etre identifiée.%N")
			else
				create socket.make_client_by_address_and_port (adresse, l_port)
				if socket.invalid_address then
					print ("Impossible de se connecter a l'adresse " + nom_adresse + ":" + l_port.out + "%N")
				else
					socket.connect
					if not socket.is_connected then
						set_connexion_succes (false)
					else
						set_connexion_succes (true)
						envoie_resultat_serveur
					end
				end
			end
		end

	envoie_resultat_serveur
			-- Envoie le resultat des pointages au serveur

		do
			set_resultat (pointage.out)
			socket.put_string (resultat)
			socket.close
		end

end

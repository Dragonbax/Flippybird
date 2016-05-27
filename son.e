note
	description: "Classe contenant la musique du jeu"
	author: "Félix-Olivier Lafleur-Duhamel"
	date: "26 mai 2016"
	revision: "1.0"

class
	SON

inherit

	AUDIO_LIBRARY_SHARED
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		require else
			audio_library.is_sound_enable
		do
			regler_son()
		end

	regler_son()
		local
			l_musique_intro, l_musique_boucle: AUDIO_SOUND_FILE
			son_source, musique_source: AUDIO_SOURCE
		do
			create l_musique_intro.make ("song.flac") -- Ce son sera joué une fois au début
			create l_musique_boucle.make ("Sandstorm.flac") -- Ce son jouera en boucle

			if l_musique_intro.is_openable and l_musique_boucle.is_openable then
				l_musique_intro.open
				l_musique_boucle.open
				if l_musique_intro.is_open and l_musique_boucle.is_open then
					audio_library.sources_add
					musique_source := audio_library.last_source_added
					audio_library.sources_add
					son_source := audio_library.last_source_added
					musique_source.queue_sound (l_musique_intro) -- Joue la musique d'intro
					musique_source.queue_sound_infinite_loop (l_musique_boucle) -- Après la musique d'intro,joue cette musique en boucle

					musique_source.play -- Joue la musique
				else
					print ("Impossible d'ouvrir fichier audio.")
				end
			else
				print ("Fichier audio invalide.")
			end
		end

end

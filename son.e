note
	description: "Classe contenant la musique du jeu"
	author: "Félix-Olivier Lafleur-Duhamel"
	date: "17 mai 2016"
	revision: "1.0"

class
	SON

inherit

	AUDIO_LIBRARY_SHARED
		redefine
			default_create
		end -- Enable the `audio_library' functionnality

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Run application.
		do
			set_sound()
		end

	set_sound()
		local
			musique_intro, musique_boucle: AUDIO_SOUND_FILE
			sound_source, music_source: AUDIO_SOURCE -- You need one source for each sound you want to be playing at the same time.
		do
			create musique_intro.make ("song.flac") -- Ce son sera jouer une fois une debut
			create musique_boucle.make ("Sandstorm.flac") -- Ce son jouera en boucle

			if musique_intro.is_openable and musique_boucle.is_openable then
				musique_intro.open
				musique_boucle.open
				if musique_intro.is_open and musique_boucle.is_open then
					audio_library.sources_add
					music_source := audio_library.last_source_added
					audio_library.sources_add
					sound_source := audio_library.last_source_added
					music_source.queue_sound (musique_intro) -- Joue la musique d'intro
					music_source.queue_sound_infinite_loop (musique_boucle) -- Apres la musique d'intro,joue cette musique en boucle

					music_source.play -- Joue la musique
				else
					print ("Impossible d'ouvrir fichier audio.")
				end
			else
				print ("Fichier audio invalide.")
			end
		end

	on_key_down_sound (a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE; a_sound: AUDIO_SOUND; a_sound_source: AUDIO_SOURCE)
			-- When the space button is pressed (in `a_key_state'), play `a_sount' in `a_sound_source'
		do
			if a_key_state.is_space then -- If the space key as been pressed, play the space sound
				a_sound_source.stop -- Be sure that the queue buffer is empty on the sound_source object (when stop, the source queue is clear)
				a_sound.restart -- Be sure that the sound is at the beginning
				a_sound_source.queue_sound (a_sound) -- Queud the sound into the source queue
				a_sound_source.play -- Play the source
			end
		end

end

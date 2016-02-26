note
	description: "Summary description for {SON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SON
inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	AUDIO_LIBRARY_SHARED	-- To use `audio_library'
	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	make



	set_sound(a_window:GAME_WINDOW)
			-- Prepare sound and sound source, play the music and set the
			-- on space key press event of `a_window' to play a sound.
		local
			l_sound,l_music_intro,l_music_loop:AUDIO_SOUND_FILE
			sound_source,music_source:AUDIO_SOURCE	-- You need one source for each sound you want to be playing at the same time.
		do
			create l_sound.make ("sound.aif")			-- This sound will be played when the user press the space bar.
			create l_music_intro.make ("intro.ogg")		-- This sound will be played once at the begining of the music
			create l_music_loop.make ("loop.flac")		-- This sound will be loop until the application stop.
														-- The library can use every sound file format that the libsndfile library can use (see: http://www.mega-nerd.com/libsndfile)
			if l_sound.is_openable and l_music_intro.is_openable and l_music_loop.is_openable then
				l_sound.open
				l_music_intro.open
				l_music_loop.open
				if l_sound.is_open and l_music_intro.is_open and l_music_loop.is_open then
					audio_library.sources_add
					music_source:=audio_library.last_source_added	-- The first source will be use for playing the music
					audio_library.sources_add
					sound_source:=audio_library.last_source_added	-- The second source will be use for playing the space sound

					music_source.queue_sound (l_music_intro)				-- Playing the intro first
					music_source.queue_sound_infinite_loop (l_music_loop)	-- After the intro end, loop the music loop

					a_window.key_pressed_actions.extend (agent on_key_down_sound(?, ?, l_sound,sound_source))	-- When a key is pressed, the on_key_down will be launch
																														-- The on_key_down routine will receive the sound and the source
																														-- Note that you can add more than one event routine for an event
					game_library.iteration_actions.extend (agent on_iteration(?, a_window))	-- To be sure that the sound will auto update sources buffers. You can use the launch_in_thread
																							-- feature of the AUDIO_CONTROLLER instead, but your application must be multi-thread enable to do so.
					music_source.play	-- Play the music
				else
					print("Cannot open sound files.")
					die(1)
				end
			else
				print("Sound files not valid.")
				die(1)
			end

		end

	on_iteration(a_timestamp:NATURAL; a_window:GAME_WINDOW)
			-- Each game loop iteration, update the audio buffers and the `a_window' surface
		do
			audio_library.update
			a_window.update		-- Be sure that the window always has a body (try to remove it to see what I mean)
		end

	on_key_down_quit(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- When the escape button is pressed (in `a_key_state') exit the application
		do
			if a_key_state.is_escape then			-- If the escape key as been pressed,
				game_library.stop					-- quit the application
			end
		end

	on_key_down_sound(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE; a_sound:AUDIO_SOUND; a_sound_source:AUDIO_SOURCE)
			-- When the space button is pressed (in `a_key_state'), play `a_sount' in `a_sound_source'
		do
			if a_key_state.is_space then			-- If the space key as been pressed, play the space sound
				a_sound_source.stop					-- Be sure that the queue buffer is empty on the sound_source object (when stop, the source queue is clear)
				a_sound.restart						-- Be sure that the sound is at the beginning
				a_sound_source.queue_sound (a_sound)	-- Queud the sound into the source queue
				a_sound_source.play					-- Play the source
			end
		end

	on_quit(a_timestamp:NATURAL)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow controller.launch to return)
		end

		-- Run application.
end

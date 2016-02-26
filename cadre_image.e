note
	description: "Summary description for {CADRE_IMAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CADRE_IMAGE

inherit
	GAME_LIBRARY_SHARED

	IMG_LIBRARY_SHARED
	EXCEPTIONS

create
	make

feature
	make
local
	l_window:GAME_WINDOW_SURFACED
	pipe2,pipe, l_background, l_bird:GAME_SURFACE


	do
			l_window:=create_window
			l_background:=create_surface("city.jpg")	-- The background is in a png file
			l_bird:=create_surface("bird.png")
			pipe:=create_surface("pipe.png")
			pipe2:=create_surface("pipe2.png")	-- The bird is in a png file

			l_window.surface.draw_surface (l_background, 0, 0)		-- Drawing a background
			l_window.surface.draw_surface (l_bird, 200, 300)
			l_window.surface.draw_surface(pipe, 500, 425)
			l_window.surface.draw_surface (pipe2, 500, 0)		-- Drawing a bird (over the background)

			l_window.update

			game_library.quit_signal_actions.extend (agent on_quit) -- Tell the library what to do when a quit signal come.
			game_library.launch		-- Launch the game loop (the application block here).
		end

	create_window:GAME_WINDOW_SURFACED
			-- Create the main window.
		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
		do
			create l_window_builder
			l_window_builder.set_dimension (800, 600)
			l_window_builder.set_title ("Hello Bird")
			Result := l_window_builder.generate_window
			if Result.has_error then	-- Valid that there is no error
				die (1)	-- If an error occured, quit the application
			end
		end

	create_surface(a_filename:STRING):GAME_SURFACE
			-- Create the surface that will be use for background.
		local
			l_image:IMG_IMAGE_FILE
		do
			create l_image.make (a_filename)	-- When created, the image source is not open
			if l_image.is_openable then		-- Look if the file can be open. In the present case, if the file exist and is readable.
				l_image.open		--Try to open the image source
				if l_image.is_open then		-- If the image source is not open, then the file is probably not a valid bmp file
					create Result.share_from_image (l_image)		-- Create a surface containing the image
					if not Result.is_open then	-- If the surface has not open as it should be.
						io.error.put_string ("The surface cannot be created.%N")
						die(4)						-- Quit the application
					end
				else
					io.error.put_string ("The file " + a_filename.as_string_8 + " does not seem to be a valid image file.%N")
					die(3)
				end
			else
				io.error.put_string ("Cannot read the image file " + a_filename.as_string_8 + ".%N")
				die (2)
			end
		end

	on_quit(a_timestamp:NATURAL_32)
			-- Execute when the application get a quit signal.
		do
			game_library.stop		-- Stop the main loop (that was started with the `game_library'.`launch' feature)
		end

end

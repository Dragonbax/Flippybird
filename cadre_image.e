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
			l_background:=create_surface("city.jpg")
			l_bird:=create_surface("bird.png")
			pipe:=create_surface("pipe.png")
			pipe2:=create_surface("pipe2.png")

			l_window.surface.draw_surface (l_background, 0, 0)
			l_window.surface.draw_surface (l_bird, 200, 300)
			l_window.surface.draw_surface(pipe, 500, 425)
			l_window.surface.draw_surface (pipe2, 500, 0)

			l_window.update

			game_library.quit_signal_actions.extend (agent on_quit)
			game_library.launch
		end

	create_window:GAME_WINDOW_SURFACED

		local
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
		do
			create l_window_builder
			l_window_builder.set_dimension (800, 600)
			l_window_builder.set_title ("Hello Bird")
			Result := l_window_builder.generate_window
			if Result.has_error then
				die (1)
			end
		end

	create_surface(a_filename:STRING):GAME_SURFACE

		local
			l_image:IMG_IMAGE_FILE
			l_son:SON
		do
			
			create l_image.make (a_filename)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create Result.share_from_image (l_image)
					if not Result.is_open then
						io.error.put_string ("The surface cannot be created.%N")
						die(4)
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

		do

			game_library.stop
		end

end

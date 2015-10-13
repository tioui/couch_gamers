note
	description : "Application to manage game start from a controller or from a keyboard and mouse."
	author: "Louis Marchand"
	date: "Tue, 13 Oct 2015 23:14:57 +0000"
	revision: "0.1"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_error_code:INTEGER
			l_viewer:detachable VIEWER
			l_config_directory:detachable DIRECTORY
		do
			l_error_code := 0
			l_config_directory := get_config_directory
			if attached l_config_directory as la_config_directory then
				game_library.enable_video
				create l_viewer.make(la_config_directory)
				if not l_viewer.has_error then
					l_viewer.launch
				end
				l_viewer := Void
				game_library.clear_all_events
				game_library.quit_library
			end
			if l_error_code /= 0 then
				die(l_error_code)
			end
		end

	get_config_directory:detachable DIRECTORY
			-- Retreive the directory containing the configuration files.
		local
			l_result:READABLE_STRING_GENERAL
			l_directory:DIRECTORY
		do
			Result := Void
			if
				attached (create {EXECUTION_ENVIRONMENT}).user_directory_path as la_path and then
				not la_path.name.is_empty
			then
				l_result := la_path.name + "/.couch_gamers"
				create l_directory.make (l_result)
				if l_directory.exists then
					result := l_directory
				else
					io.error.put_string ("Configuration directory not found. Search at: " + l_result + ".%N")
				end
			else
				io.error.put_string ("Cannot found user's home directory.%N")
			end
		end

end

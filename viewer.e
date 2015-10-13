note
	description: "Show all {ENTRY} on the Window and manage the selection."
	author: "Louis Marchand"
	date: "Tue, 13 Oct 2015 23:14:57 +0000"
	revision: "0.1"

class
	VIEWER

inherit
	GAME_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialisation

	make(a_config_directory:DIRECTORY)
			-- Initialization of `Current' using `a_config_directory' as `config_directory'
		do
			has_error := False
			config_directory := a_config_directory
			update_entry_list
		end

feature -- Access

	launch
			-- Start the engine or `Current'
		do

		end

	update_entry_list
			-- Update the `entry_list' with the value in the entries file.
		local
			l_parser: JSON_PARSER
			l_entries_file:PLAIN_TEXT_FILE
			l_json_string:STRING_8
			l_entry:ENTRY
		do
			create {LINKED_LIST[ENTRY]}entry_list.make
			create l_entries_file.make_with_path (config_directory.path.extended ("entries"))
			if l_entries_file.exists and then l_entries_file.is_access_readable and then l_entries_file.is_readable then
				l_entries_file.open_read
				if l_entries_file.is_open_read then
					create l_json_string.make (l_entries_file.count)
					l_json_string.fill (l_entries_file)
					l_entries_file.close
					create l_parser.make_with_string (l_json_string)
					l_parser.parse_content
					if l_parser.is_valid then
						if attached l_parser.parsed_json_array as la_json_array then
							across
								la_json_array as lla_json_array
							loop
								if attached {JSON_OBJECT}lla_json_array.item as la_json_object then
									create l_entry.make_from_json (la_json_object)
									if not l_entry.has_error then
										entry_list.extend (l_entry)
									end
								else
									has_error := True
									io.error.put_string ("There is an invalid entry%N")
								end
							end
						else
							has_error := True
							io.error.put_string ("The entries file is not valid%N")
						end
					else
						has_error := True
						io.error.put_string ("The entries file is not valid: " + l_parser.errors_as_string + " %N")
					end
				end
			else
				has_error := True
				io.error.put_string ("Cannot open " + l_entries_file.path.name + "%N")
			end
		end

	entry_list:LIST[ENTRY]
			-- Every {ENTRY} to show in the `window'

	config_directory:DIRECTORY
			-- The directory containing every configuration files

	has_error:BOOLEAN
			-- There was an error in the last method of `Current'
end

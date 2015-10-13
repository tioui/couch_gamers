note
	description: "An entry of the list to show in the application."
	author: "Louis Marchand"
	date: "Tue, 13 Oct 2015 23:14:57 +0000"
	revision: "0.1"

class
	ENTRY

create
	make_from_json

feature {NONE} -- Initialization

	make_from_json(a_json_object:JSON_OBJECT)
			-- Initialization of `Current' using `a_json_object' to get attributes values
		do
			has_error := False
			name := ""
			image_file := ""
			create {COMMAND_ACTION}action.make ("none")
			if attached {JSON_STRING} a_json_object.item ("name") as la_name then
				name := la_name.unescaped_string_8
				if attached {JSON_STRING} a_json_object.item ("image") as la_image then
					image_file := la_image.unescaped_string_8
				else
					image_file := ""
				end
				if attached {JSON_OBJECT} a_json_object.item ("action") as la_action then
					if attached {JSON_STRING} la_action.item ("type") as la_action_type then
						if la_action_type.unescaped_string_8.is_equal ("execute") then
							if attached {JSON_STRING} la_action.item ("name") as la_action_name then
								create {EXECUTE_ACTION}action.make(la_action_name.unescaped_string_8)
							else
								has_error := True
								io.error.put_string ("The action of the entry object '" + name + "' does not have any name.%N")
							end
						elseif la_action_type.unescaped_string_8.is_equal ("command") then
							if attached {JSON_STRING} la_action.item ("name") as la_action_name then
								create {COMMAND_ACTION}action.make(la_action_name.unescaped_string_8)
								if not (attached {COMMAND_ACTION} action as la_command and then la_command.is_valid) then
									has_error := True
									io.error.put_string ("The command name '" + la_action_name.unescaped_string_8 + "' is not valid.%N")
								end
							else
								has_error := True
								io.error.put_string ("The action of the entry object '" + name + "' does not have any name.%N")
							end
						else
							has_error := True
							io.error.put_string ("The action type of the entry object '" + name + "' is not valid.%N")
						end
					else
						has_error := True
						io.error.put_string ("The action of the entry object '" + name + "' does not have any type.%N")
					end
				else
					has_error := True
					io.error.put_string ("Entry object '" + name + "' does not have any action.%N")
				end
			else
				has_error := True
				io.error.put_string ("Entry object does not contain a 'name' value%N")
			end
		end

feature -- Access

	has_error:BOOLEAN
			-- There was an error on the call of the last method of `Current'

	name:READABLE_STRING_GENERAL
			-- A text representation of `Current'

	image_file:READABLE_STRING_GENERAL
			-- The name of the file containing the image

	action:ENTRY_ACTION
			-- The action to by launch when `Current' is selected

end

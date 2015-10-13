note
	description: "Internal command that can be used in an {ENTRY}."
	author: "Louis Marchand"
	date: "Tue, 13 Oct 2015 23:14:57 +0000"
	revision: "0.1"

class
	COMMAND_ACTION

inherit
	ENTRY_ACTION

create
	make

feature -- Access

	is_none:BOOLEAN
			-- `Current' does nothing
		do
			Result := name ~ "none"
		end

	is_quit:BOOLEAN
			-- `Current' launch the end of the application
		do
			Result := name ~ "quit"
		end

	is_valid:BOOLEAN
			-- `Current' represent a valid command.
		do
			Result := is_none or is_quit
		end

end

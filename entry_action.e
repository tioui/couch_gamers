note
	description: "The action to be used when an {ENTRY} is selected."
	author: "Louis Marchand"
	date: "Tue, 13 Oct 2015 23:14:57 +0000"
	revision: "0.1"

deferred class
	ENTRY_ACTION

feature {NONE} -- Initialization

	make(a_name:READABLE_STRING_GENERAL)
			-- Initialization of `Current' using `a_name' as `name'
		do
			name := a_name
		end

feature -- Access

	name:READABLE_STRING_GENERAL
		-- A text representation of `Current'

end

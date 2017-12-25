note
	description: "Summary description for {SINGLETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SINGLETON

feature {NONE}

	frozen the_singleton:SINGLETON
	once
		Result := current
	end

invariant
	only_one_instance: current = the_singleton

end

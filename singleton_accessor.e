note
	description: "Summary description for {SINGLETON_ACCESSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SINGLETON_ACCESSOR

feature {NONE}
	singleton:SINGLETON deferred end

	is_real_singleton:BOOLEAN
	do
		Result := singleton = singleton
	end

invariant
	singleton_is_real_singleton:is_real_singleton
end

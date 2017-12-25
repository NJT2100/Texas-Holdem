note
	description: "Summary description for {CARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CARD

inherit
	COMPARABLE

create
	make

feature --Representation {NONE}

	card_rank:INTEGER

	card_suit:INTEGER

feature

	--Generate a playing card with rank ranging from 2 - 14 and a suit
	--ranging form 1 - 4. Ranks 11 - 14 represent the Jack, Queen , King
	--and Ace respectively while suits 1 - 4 represent the Spade, Club, Heart
	--and Diamond Respectively
	make(rank:INTEGER; suit:INTEGER)
	require
		rank >= 2 and rank <= 14
		suit >= 1 and suit <= 4
	do
		card_rank := rank
		card_suit := suit
	end

	get_rank:INTEGER
	do
		Result := card_rank
	end

	get_suit:INTEGER
	do
		Result := card_suit
	end

	set_rank(new_rank:INTEGER)
	do
		card_rank := new_rank
	end

	set_suit(new_suit:INTEGER)
	do
		card_suit := new_suit
	end

	--Create a string representation of a playing card
	--'A' = Ace, 'K' = King, 'Q' = Queen, 'J' = Jack
	-- 'S' = Spade, 'C' = Club, 'H' = Heart, 'D' = Diamond
	to_string:STRING_32
	local
		char_rank:STRING_32
		char_suit:CHARACTER_32
		string:STRING_32
	do
		create char_rank.make_empty
		create string.make (2)

		inspect Current.get_rank
		when 14 then
			char_rank := "A"
		when 13 then
			char_rank := "K"
		when 12 then
			char_rank := "Q"
		when 11 then
			char_rank := "J"
		else
			char_rank := Current.get_rank.out
		end

		inspect Current.get_suit
		when 1 then
			char_suit := 'S'
		when 2 then
			char_suit := 'C'
		when 3 then
			char_suit := 'H'
		else
			char_suit := 'D'
		end
		string.append (char_rank)
		string.append_character (char_suit)

		Result := string
	end

	--Create a total ordering of playing cards
	is_less alias "<" (other: like Current):BOOLEAN
	do
		if Current.get_rank < other.get_rank then
			Result := true
		else if Current.get_rank = other.get_rank then
			if Current.get_suit < other.get_suit then
				Result := true
			end
		end
		end
	end

end

note
	description: "Summary description for {DECK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DECK

create
	make

feature{NONE} --Representation

	deck:ARRAYED_LIST[CARD]

	deck_size:INTEGER = 52

feature{ANY}

	--Generate a standard 52 card playing deck
	make
	local
		rank:INTEGER
		suit:INTEGER
		card:CARD
	do
		create deck.make (deck_size) 			--create an array with capacity for 52 cards
		from suit := 1							--loop through all possible values of suits
		until suit > 4
		loop
			from rank := 2						--loop through all possible values of rank
			until rank > 14
			loop
				create card.make (rank, suit)	--create the card with current 'rank' and 'suit'
				deck.put_front(card)			--append card to front of deck
				rank := rank + 1
			end
			suit := suit + 1
		end
	ensure
		deck.count = deck_size					--ensure there are exactly 52 cards in the deck
		--all cards are unique, use occurences...
	end

	--Remove the CARD at the first position in the deck
	deal:CARD
	local
		dealt:CARD
	do
		dealt := deck.first						--store a copy of the card at the first position
		deck.start								--ensure cursor is at the first position of the ARRAYED_LIST
		deck.remove								--remove CARD from the deck
		Result := dealt
	ensure
		deck.has (Result) = false
	end

	--Return a list of the next 'depth' cards to be dealt from
	--the list in order
	peek(depth:INTEGER):LINKED_LIST[CARD]
	local
		cheat:LINKED_LIST[CARD]
		i:INTEGER
		card:CARD
	do
		create cheat.make
		from i := 1								--loop through the deck and store a copy of each CARd
		until i > depth							--into 'cheat' until 'cheat' has 'depth' number of cards
		loop
			card := deck.at (i)
			cheat.put_i_th (card, i)
		end
		Result:= cheat
	end

	--Take back the hand from a player and return it to the deck
	retrieve(hand:LINKED_LIST[CARD])
	do
		from hand.start							--move 'hand' cursor to first position
		until hand.after
		loop
			deck.finish
			if deck.has (hand.item) = false then
				deck.put_right(hand.item)
			end								--move 'deck' cursor to bottom of the deck												
												--insert card at bottom of deck
			hand.forth
			deck.forth						--move 'hand' cursor to next card
		end

	ensure

	end

	--shuffle the deck
	shuffle(seed:INTEGER)
	local
		rnd:RANDOM
		skew:INTEGER
		pos:INTEGER
	do
		create rnd.make
		create rnd.set_seed (seed)			--create a random sequence of numbers using random seed
		from skew := 0
		until skew = 300
		loop
			pos := rnd.item						--retrieve a number from the sequence of random variables
			pos:= pos\\deck_size				--moduluslly divide 'pos' by 52 to get a number between 1 - 52
			if pos < 1 then						--ensure 'pos' is a valid position
				pos := 1
			end
			deck.swap (pos)						--swap current cursor position with item at index 'pos'
			skew := skew + 1
			rnd.forth							-- move to next random number
		end
	end

end

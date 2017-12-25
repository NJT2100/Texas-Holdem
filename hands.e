note
	description: "Summary description for {HANDS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HANDS

create
	make

feature {NONE}

	make
	do

	end
	--sort a hand of cards using selection sort
	sort(hand:LINKED_LIST[CARD])
	local
		i:INTEGER
		j:INTEGER
		low_index:INTEGER
	do
		from i := 1
		until i > hand.count
		loop
			low_index := i							--set low index equal to the first card in the hand
			from j := i
			until j > hand.count
			loop
				if hand.at(j).is_less (hand.at(low_index)) then
					low_index := j					--if the card at index 'j' is less than card at 'low_index,
				end									-- set 'low_index' equal to 'j'
				j:= j + 1
			end
			hand.go_i_th (i)						--move cursor to beginning of sublist and swap card with
			hand.swap (low_index)					--card at 'low_index
			i := i + 1
		end
	end

	--Returns true if there are exactly 'count' number of cards
	-- in the hand that match in rank
	match(count:INTEGER;hand:LINKED_LIST[CARD]):BOOLEAN
	local
		matches:INTEGER
		i:INTEGER
		rank:INTEGER

	do
		sort(hand)									--ensure hand is in ascending order
		matches := 1
		rank := hand.at (1).get_rank
		from i := 2									--starting from the second card in the hand, count
		until i > hand.count						--the number of cards that have the same rank as the previous
		loop
			if rank = hand.at (i).get_rank then		--if card at index 'i' matches rank of previous card incriment matches by 1
				matches := matches + 1
			else									--o.w set matches to 1 and set rank equal to the current index
				matches := 1
				rank := hand.at (i).get_rank
			end
			i:= i + 1
			if matches = count then					--if matches equals exactly 'count' return true
				Result := true
			end
			if matches > count then					--if matches greater than 'count' return false
				Result := false
			end
		end
	end

feature{ANY}


	--Reurn true if hand is a "stright flush"
	straight_flush(hand:LINKED_LIST[CARD]):BOOLEAN
	local
		i:INTEGER
		consecutive:INTEGER
		rank:INTEGER
		suit:INTEGER
	do
		--determine if there are 5 cards with consecutive suits, all of the same rank
		sort(hand)
		consecutive := 1
		rank := hand.at (1).get_rank
		suit := hand.at (1).get_suit
		from i := 2
		until i > hand.count
		loop
			if hand.at(i).get_rank = rank + 1 and hand.at (i).get_suit = suit then			--if the next cards rank is 1 greater than the current card and the
				consecutive := consecutive + 1												--suits are equivalent then increment consecutive by 1
				rank := hand.at (i).get_rank
			elseif hand.at (i).get_rank = rank and hand.at (i).get_suit /= suit then		--if the next card is of the same rank but different suit
				--do nothing
			else
				consecutive := 1															--o.w start over. Set rank and suit equal to the current card
				rank := hand.at (i).get_rank
				suit:= hand.at (i).get_suit
			end
			if consecutive >= 5 then														--if consecutive is 5 or greater return true
				Result := true
			end
			i := i + 1
		end
	end

	--Return true if hand is a "four of a kind"
	four_of_a_kind(hand:LINKED_LIST[CARD]):BOOLEAN
	do
		Result := match(4, hand)
	end

	--Return true if hand is a "full house"
	full_house(hand:LINKED_LIST[CARD]):BOOLEAN
	do
		if one_pair(hand) and three_of_a_kind(hand) then
			Result := true
		end
	end

	--Return true if hand is a "flush"
	flush(hand:LINKED_LIST[CARD]):BOOLEAN
	local
		pairs:ARRAY[INTEGER]
		i:INTEGER
		suit:INTEGER
		amount:INTEGER
		matches:INTEGER
	do
		create pairs.make_filled (0, 1, 4)					--create an array filled with indexs corresponding to each cards suit

		from i := 1
		until i > hand.count
		loop
			suit := hand.at (i).get_suit					--every time a card appears in the hand, the index in the array corresponding
			amount := pairs.at (suit) + 1					--to the cards suit is incremented by 1
			pairs.put (amount, suit)

			i := i + 1
		end

		from i := 1
		until i > 4
		loop
			if pairs.at(i) >= 5 then						--if any index in the array is 5 or greater, return true
				Result := true
			end
			i := i + 1
		end

	end

	--Return true if hand is a "straight"
	straight(hand:LINKED_LIST[CARD]):BOOLEAN
	local
		i:INTEGER
		consecutive:INTEGER
		rank:INTEGER
	do
		sort(hand)
		consecutive := 1
		rank := hand.at (1).get_rank
		from i := 2
		until i > hand.count
		loop
			if hand.at(i).get_rank = rank + 1 then			--incriment consecutive by 1 if the nex card in the hand is
				consecutive := consecutive + 1				--equal to 'rank' + 1
				rank := hand.at (i).get_rank				--set rank equal to current card
			elseif hand.at (i).get_rank = rank then
				--do nothing
			else
			consecutive := 1								--o.w start over and set 'rank' equal to current and
				rank := hand.at (i).get_rank				--consecutive equal to 1
			end
			if consecutive >= 5 then						--if consecutive equals 5 then return true
				Result := true
			end
			i := i + 1
		end
	end

	--Return true if hand is "three of a kind"
	three_of_a_kind(hand:LINKED_LIST[CARD]):BOOLEAN
	do
		Result := match(3, hand)
	end

	--Return true if hand is "two pair"
	two_pair(hand:LINKED_LIST[CARD]):BOOLEAN
	local
		pairs:ARRAY[INTEGER]
		i:INTEGER
		rank:INTEGER
		amount:INTEGER
		matches:INTEGER
	do
		create pairs.make_filled (0, 2, 14)				--create an array with indexes representing the ranks of playing cards

		from i := 1
		until i > hand.count
		loop
			rank := hand.at (i).get_rank				--every time a card appears in the hand, go to the index of the rank
			amount := pairs.at (rank) + 1				--of the card and incriment its value by 1
			pairs.put (amount, rank)

			i := i + 1
		end

		from i := 2
		until i > pairs.count
		loop											--search through the array and increment variable matches by 1 if
			if pairs.at(i) >= 2 then					--any index in the array is 2 or greater
				matches := matches + 1
			end
			i := i + 1
		end

		if matches >= 2 then							--if there are 2 or more matches return true
			Result := true
		end
	end

	--Return true if hand is "one pair"
	one_pair(hand:LINKED_LIST[CARD]):BOOLEAN
	do
		Result:= match(2, hand)
	end

	--Return true if hand is a "high card"
	high_card(hand:LINKED_LIST[CARD]):BOOLEAN
	do
		Result := true
	end

	--assign an integer rank to each hand
	hand_rank(hand:LINKED_LIST[CARD]):INTEGER
	do
		if straight_flush(hand) then
			Result := 9
		elseif four_of_a_kind(hand) then
			Result := 8
		elseif full_house(hand) then
			Result := 7
		elseif flush(hand) then
			Result := 6
		elseif straight(hand) then
			Result := 5
		elseif three_of_a_kind(hand) then
			Result := 4
		elseif two_pair(hand) then
			Result := 3
		elseif one_pair(hand) then
			Result := 2
		elseif high_card(hand) then
			Result := 1
		else
			Result := 0
		end
	end
end

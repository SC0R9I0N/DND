#!/bin/bash

# comment lines denoted with repeated '*' are subsections. lines denoted with '-' are major sections

#******************Intro statements**************
read -p "Welcome to my DnD campaign. Sorry I couldn't make it to the session. In my stead, take this script to go through my campaign. Hit enter to continue."

echo ""

read -p "Great, I'm glad you are deciding to join the campaign. First let's start with a character class to play. Hit enter to see the classes."

echo ""

echo "The list contains most of the 5e classes. Please type out the number of the class you'd like to play (you can change it later on):
1 - Barbarian
2 - Bard
3 - Cleric
4 - Druid
5 - Fighter
6 - Monk
7 - Paladin
8 - Ranger
9 - Rogue
10 - Sorcerer
11 - Warlock
12 - Wizard
"

read class
#****************End of Intro************************

#-----------------Character Creation------------------------
level=1
abilities=("Strength" "Dexterity" "Constitution" "Intelligence" "Wisdom" "Charisma")
scores=(8 8 8 8 8 8)
modifiers=(0 0 0 0 0 0)
points=27

echo ""

case $class in
	1)
		type="Barbarian"
		hit=12
		;;
	2)
		type="Bard"
		hit=8
		;;
	3)
		type="Cleric"
		hit=8
		;;
	4)
		type="Druid"
		hit=8
		;;
	5)
		type="Fighter"
		hit=10
		;;
	6)
		type="Monk"
		hit=8
		;;
	7)
		type="Paladin"
		hit=10
		;;
	8)
		type="Ranger"
		hit=10
		;;
	9)
		type="Rogue"
		hit=8
		;;
	10)
		type="Sorcerer"
		hit=6
		;;
	11)
		type="Warlock"
		hit=8
		;;
	12)
		type="Wizard"
		hit=6
		;;
	*)
		echo "Invalid choice, please enter a number between 1 and 12"
		exit 1
		;;
esac

echo "Great, you've chosen to play as a $type with a hit die of $hit"

echo ""

sleep 3

echo "Now that you've chosen a class, it's time to use up your points for your ability scores."

echo ""

#*********************************Ability Scores & Modifiers*****************************

# function to display scores
display_scores() {
	for i in "${!abilities[@]}"; do
		echo "${abilities[$i]}: ${scores[$i]}"
	done
	echo "Remaining Points: $points"
	echo ""
}

# function to adjust ability scores
adjust_scores() {
        local ability=$1
        local change=$2
        for i in "${!abilities[@]}"; do
                if [ "${abilities[$i]}" == "$ability" ]; then
                        local current_score=${scores[$i]}
                        local new_score=$current_score
                        local total_points=$points

                        if [ $change -gt 0 ]; then
                                for ((step=0; step<change; step++)); do
                                        if [ $new_score -lt 13 ]; then
                                                total_points=$((total_points-1))
                                        else
                                                total_points=$((total_points-2))
                                        fi
                                        new_score=$((new_score + 1))
                                        if [ $total_points -lt 0 ]; then
                                                echo "Not enough points to increase $ability to $((new_score))."
                                                return
                                        fi
                                done
                        elif [ $change -lt 0 ]; then
                                for ((step=change; step<0; step++)); do
                                        if [ $new_score -le 13 ]; then
                                                total_points=$((total_points + 1))
                                        else
                                                total_points=$((total_points + 2))
                                        fi
                                        new_score=$((new_score - 1))
                                        if [ $new_score -lt 8 ]; then
                                                echo "Invalid adjustment for $ability. Scores must be between 8 and >
                                                return
                                        fi
                                done
                        fi

                        scores[$i]=$new_score
                        points=$total_points
                        echo "$ability adjusted by $change points. New score: ${scores[$i]}, Remaining points: $poin>
                fi
        done
}


# main loop to adjust ability scores
while true; do
	echo "Current Ability Scores:"
	display_scores
	echo "Enter the ability you want to adjust (or 'exit' to finish):"
	read ability
	if [ "$ability" == "exit" ] && [ $points -gt 0 ]; then
		echo "You still have points to spend. Please use all your points before exiting."
		continue
	elif [ "$ability" == "exit" ] && [ $points -eq 0 ]; then
		break
	fi
	echo "Enter the change in points (e.g., +1 or -1):"
	read change
	adjust_scores "$ability" "$change"
done

echo ""
echo "Final Ability Scores:"
display_scores

calculate_modifier() {
	local score=$1
 	local modifier=$(( (score - 10) / 2 ))
  	echo $modifier
}

update_modifiers() {
	for i in "$!scores[@]}"; do
 		modifiers[$i]=$(calculate_modifier ${scores[$i]})
   	done
}

#update and display ability modifier scores
update_modifiers

echo "Ability Modifiers:"
for i in "${!abilities[@]}"; do
	echo "${abilities[$i]}: ${modifiers[$i]}"
 done

#*******************End of Ability Scores and Modifiers*************************

#**********************************HP Calculation*******************************
calculate_hp() {
	local hit_die=$1
 	local con_mod=$2
  	local level=$3

    	# calculate hp for level 1
     	local hp=$((hit_die + con_mod))

      	#hp for higher levels
       	if [ $level -gt 1 ]; then
		local additional_hp=$(((level - 1) * (hit_die / 2 + 1 + con_mod)))
  		hp=$((hp + additional_ban))
    	fi

      	echo $hp
}
#****************************End of HP calculation***************************

hp=$(calculate_hp $hit ${modifiers[$2]} $level)

echo ""

echo "Your HP is $hp as a level $level $type"

sleep 3

read -p "Now that you've set up your basic traits of your character, it's time for you to choose your proficiencies. Hit enter to continue"

echo ""

#***********************************Proficiency*******************************

# calculate overall proficiency bonus
calculate_proficiency_bonus() {
        local level=$1
        if [ $level -le 4 ]; then
                echo 2
        elif [ $level -le 8 ]; then
                echo 3
        elif [ $level -le 12 ]; then
                echo 4
        elif [ $level -le 16 ]; then
                echo 5
        else
                echo 6
        fi
}

# prompt player for proficiency choices
select_proficiencies() {
        local proficiency_bonus=$(calculate_proficiency_bonus $level)
        local proficiencies=()
        local selected_indices=()

        echo "Select two abilities for proficiency (type the number and hit Enter)"
        for i in "${!abilities[@]}"; do
                echo "$i: ${abilities[$i]}"
        done

        for _ in {1..2}; do
                read index
                if [[ $index =~ ^[0-5]$ ]] && ! [[ " ${selected_indices[@]} " =~ " $index " ]]; then
                        selected_indices+=($index)
                        modifiers[$index]=$((modifiers[$index] + proficiency_bonus))
                        proficiencies+=(${abilities[$index]})
                        echo "Proficiency in ${abilities[$index]} added."
                else
                        echo "Invalid selection. Please select a valid ability number and avoid duplicates."
                fi
        done

        echo "Selected Proficiencies: ${proficiencies[@]}"
}

select_proficiencies

echo "Updated Ability Modifiers with Proficiency:"
for i in "${!abilities[@]}"; do
        echo "${abilities[$i]}: ${modifiers[$i]}"
done
#***********************************End of Proficiency**************************

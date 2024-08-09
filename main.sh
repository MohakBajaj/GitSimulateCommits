#!/bin/bash

# Converted to Bash Script using https://claude.ai

# Git Commit Simulator
# Figlet ASCII Art with Color (might be broken here)
show_rainbow_figlet() {
    local text="$1"
    local colors=("31" "33" "32" "36" "34" "35")
    
    figlet_text=$(cat << "EOF"
 Welcome To The OG
  ___  __ ______  ___  ___   ___  __ ____  ___ __ ______  __  __ ___  ___ __ __ __     ___  ______  ___   ____ 
 // \\ || | || | //   // \\  ||\\//| |||\\//|| || | || | (( \ || ||\\//|| || || ||    // \\ | || | // \\  || \\
(( ___ ||   ||  ((   ((   )) || \/ | ||| \/ || ||   ||    \\  || || \/ || || || ||    ||=||   ||  ((   )) ||_//
 \\_|| ||   ||   \\__ \\_//  ||    | |||    || ||   ||   \_)) || ||    || \\_// ||__| || ||   ||   \\_//  || \\

 By: @MohakBajaj

EOF
)

    IFS=$'\n' read -d '' -ra lines <<< "$figlet_text"
    local color_index=0

    for line in "${lines[@]}"; do
        echo -e "\e[${colors[$color_index]}m$line\e[0m"
        color_index=$(( (color_index + 1) % ${#colors[@]} ))
    done
}

show_rainbow_figlet

# Display current repository, branch, and remote information with colors
echo -e "\e[33mFetching repository information...\e[0m"

repo_path=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$repo_path" ]; then
    echo -e "\e[31mNot in a git repository. Please navigate to a git repository and try again.\e[0m"
    exit 1
fi

branch_name=$(git rev-parse --abbrev-ref HEAD)
remote_url=$(git remote get-url origin 2>/dev/null)
if [ -z "$remote_url" ]; then
    remote_url="No remote repository configured."
fi

echo -e "\e[32mRepository: $repo_path\e[0m"
echo -e "\e[32mBranch: $branch_name\e[0m"
echo -e "\e[32mRemote: $remote_url\e[0m"

# Function to parse the user input into a date
parse_date() {
    local input_date="$1"
    local parsed_date

    if [[ "$input_date" == "today" ]]; then
        parsed_date=$(date +%Y-%m-%d)
    elif [[ "$input_date" =~ ^[0-9]+\ *(day|week|month|year)s?\ *ago$ ]]; then
        local number=$(echo "$input_date" | grep -oE '[0-9]+')
        local unit=$(echo "$input_date" | grep -oE '(day|week|month|year)')
        parsed_date=$(date -d "$number $unit ago" +%Y-%m-%d)
    elif [[ "$input_date" == "yesterday" ]]; then
        parsed_date=$(date -d "yesterday" +%Y-%m-%d)
    elif [[ "$input_date" =~ ^[0-9]{1,2}[-/][0-9]{1,2}[-/][0-9]{2,4}$ ]]; then
        parsed_date=$(date -d "$input_date" +%Y-%m-%d)
    else
        echo -e "\e[31mUnrecognized date format. Please try again.\e[0m"
        exit 1
    fi

    echo "$parsed_date"
}

# Prompt user for commit type: single day or range
echo -e "\e[36mDo you want to simulate commits for a single day or a range of dates? (single/1 or range/N):\e[0m"
read commit_type

if [[ "$commit_type" =~ ^(single|1)$ ]]; then
    echo -e "\e[36mEnter the date for the single day (e.g., '1 month ago', '12-05-23', 'today', etc.):\e[0m"
    read single_date_input

    single_date=$(parse_date "$single_date_input")

    commit_count=$((RANDOM % 10 + 1))
    for ((i=1; i<=commit_count; i++)); do
        random_message="Simulated commit #$i on $single_date"
        GIT_AUTHOR_DATE="$single_date" GIT_COMMITTER_DATE="$single_date" git commit --allow-empty -m "$random_message" > /dev/null 2>&1
        echo -e "\e[32mSimulating commit: '$random_message' on $single_date\e[0m"
    done
    echo -e "\e[33mCompleted $commit_count commit(s) on $single_date.\e[0m"
elif [[ "$commit_type" =~ ^(range|n)$ ]]; then
    echo -e "\e[36mEnter the start date (e.g., '1 month ago', '12-05-23', 'today', etc.):\e[0m"
    read start_date_input

    start_date=$(parse_date "$start_date_input")

    echo -e "\e[36mEnter the end date (e.g., '5 days ago', '12-05-23', 'today', etc.):\e[0m"
    read end_date_input

    end_date=$(parse_date "$end_date_input")

    if [[ "$end_date" < "$start_date" ]]; then
        echo -e "\e[31mEnd date cannot be earlier than start date. Please try again.\e[0m"
        exit 1
    fi

    current_date="$start_date"
    while [[ "$current_date" <= "$end_date" ]]; do
        commit_count=$((RANDOM % 10 + 1))
        for ((i=1; i<=commit_count; i++)); do
            random_message="Simulated commit #$i on $current_date"
            GIT_AUTHOR_DATE="$current_date" GIT_COMMITTER_DATE="$current_date" git commit --allow-empty -m "$random_message" > /dev/null 2>&1
            echo -e "\e[32mSimulating commit: '$random_message' on $current_date\e[0m"
        done
        current_date=$(date -d "$current_date + 1 day" +%Y-%m-%d)
    done

    echo -e "\e[33mCompleted commits simulation from $start_date_input to $end_date_input.\e[0m"
else
    echo -e "\e[31mInvalid input. Please enter 'single', '1', 'range', or 'N'.\e[0m"
    exit 1
fi

# Function to validate user input for yes/no questions
validate_yes_no_input() {
    local input_yn="$1"
    case "$input_yn" in
        [Yy]|[Yy][Ee][Ss]) return 0 ;;
        [Nn]|[Nn][Oo]) return 1 ;;
        *) 
            echo -e "\e[31mInvalid input. Please enter 'yes', 'no', 'y', or 'n'.\e[0m"
            exit 1
            ;;
    esac
}

# Prompt the user if they want to push the changes
echo -e "\e[36mDo you want to push the simulated commits to the remote repository? (yes/no):\e[0m"
read push_changes_input

if validate_yes_no_input "$push_changes_input"; then
    git push > /dev/null 2>&1
    echo -e "\e[32mChanges have been pushed to the remote repository.\e[0m"
else
    echo -e "\e[33mChanges were not pushed.\e[0m"
fi
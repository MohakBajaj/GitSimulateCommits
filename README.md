# Git Commit Simulator

## Overview

The **Git Commit Simulator** is a PowerShell script designed to simulate Git commits for a specified date or range of dates. It includes functionalities to display repository information, handle various date formats, simulate commits, and optionally push changes to a remote repository.

## Features

1. **Figlet Art with Rainbow Colors:** Displays a welcoming Figlet ASCII art with a rainbow color effect.
2. **Repository Information:** Shows the current repository path, branch, and remote URL.
3. **Date Parsing:** Handles various date formats, including relative dates like "yesterday" and "1 month ago."
4. **Commit Simulation:** Allows the user to simulate commits for a single day or a range of dates. You can even simulate commit on a future date.
5. **Push Confirmation:** Asks if the user wants to push the simulated commits to the remote repository.

## Usage

Running the Script

To run the script, navigate to the directory containing the script file and execute it using PowerShell:

```powershell
.\main.ps1
```

## Script Execution Flow

1. Rainbow Figlet Art: The script starts by displaying the Figlet ASCII art with a rainbow color effect.
   Display Repository Information: Shows details about the current Git repository, including the repository path, branch name, and remote URL.
2. Date Parsing: Prompts the user to enter a start and end date, or a single date for commit simulation.
3. Commit Simulation:
4. Single Day: If the user chooses to simulate commits for a single day, they are prompted to enter the date, and the script generates a random number of commits for that date.
5. Date Range: If the user chooses a date range, they provide a start and end date, and the script generates random commits for each day in the range.
6. Push Confirmation: Asks if the user wants to push the simulated commits to the remote repository. If confirmed, the script performs the push operation.

## Parameters

- **Single Day Simulation:**
  - **Prompt:** Enter the date for the single day (e.g., '1 month ago', '12-05-23', 'today', etc.):
- **Range Simulation:**

  - **Prompt:** Enter the start date (e.g., '1 month ago', '12-05-23', 'today', etc.):
  - **Prompt:** Enter the end date (e.g., '5 days ago', '12-05-23', 'today', etc.):

- **Push Confirmation:**
  - **Prompt:** Do you want to push the simulated commits to the remote repository? (yes/no):

## Example

Running the Script

```powershell
.\main.ps1
```

### Sample Input/Output

1.  **Date Parsing:**

    - **Prompt:** Enter the date for the single day (e.g., '1 month ago', '12-05-23', 'today', etc.):
    - **User Input:** 1 month ago
    - **Output:** Simulating commit: 'Simulated commit #1 on `parsed-date`' on `parsed-date`

2.  **Range Simulation:**

    - **Prompt:** Enter the start date (e.g., '1 month ago', '12-05-23', 'today', etc.):
    - **User Input:** 10 days ago
    - **Prompt:** Enter the end date (e.g., '5 days ago', '12-05-23', 'today', etc.):
    - **User Input:** 5 days ago
    - **Output:** Completed commits simulation from `start-date` to `end-date`.

3.  **Push Confirmation:**

    - **Prompt:** Do you want to push the simulated commits to the remote repository? (yes/no):
    - **User Input:** yes
    - **Output:** Changes have been pushed to the remote repository.

## Error Handling

- **Not in a Git Repository:** If the script detects that it is not in a Git repository, it will display an error message and exit.
- **Invalid Date Format:** If the date format is unrecognized, the script will prompt the user to try again.
- **End Date Before Start Date:** If the end date is earlier than the start date, the script will notify the user and exit.

## Customization

- **Figlet Text:** Modify the figletLines variable in the Show-RainbowFiglet function to change the displayed ASCII art.
- **Colors:** Adjust the colors array in the Show-RainbowFiglet function to customize the rainbow effect.

## Notes

- Ensure that Git is installed and properly configured in your environment.
- Run the script from a Git repository directory to avoid errors.

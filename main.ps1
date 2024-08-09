# Git Commit Simulator
# Figlet ASCII Art with Color
function Show-RainbowFiglet {
    param (
        [string]$text
    )

    $colors = @(
        "Red", "Yellow", "Green", "Cyan", "Blue", "Magenta"
    )

    $figletLines = @"
Welcome To The OG
  ___  __ ______  ___  ___   ___  __ ____  ___ __ ______  __  __ ___  ___ __ __ __     ___  ______  ___   ____ 
 // \\ || | || | //   // \\  ||\\//| |||\\//|| || | || | (( \ || ||\\//|| || || ||    // \\ | || | // \\  || \\
(( ___ ||   ||  ((   ((   )) || \/ | ||| \/ || ||   ||    \\  || || \/ || || || ||    ||=||   ||  ((   )) ||_//
 \\_|| ||   ||   \\__ \\_//  ||    | |||    || ||   ||   \_)) || ||    || \\_// ||__| || ||   ||   \\_//  || \\

 By: @MohakBajaj`n`n
"@

    $lines = $figletLines -split "`n"
    $colorIndex = 0

    foreach ($line in $lines) {
        Write-Host $line -ForegroundColor $colors[$colorIndex]
        $colorIndex = ($colorIndex + 1) % $colors.Length
    }
}

Show-RainbowFiglet


# Display current repository, branch, and remote information with colors
Write-Host "Fetching repository information..." -ForegroundColor Yellow

try {
    # Get the current repository path
    $repoPath = git rev-parse --show-toplevel 2>$null
    if (!$repoPath) {
        Write-Host "Not in a git repository. Please navigate to a git repository and try again." -ForegroundColor Red
        exit
    }

    # Get the current branch name
    $branchName = git rev-parse --abbrev-ref HEAD

    # Get the remote URL
    $remoteUrl = git remote get-url origin 2>$null
    if (!$remoteUrl) {
        $remoteUrl = "No remote repository configured."
    }

    # Display the information
    Write-Host "Repository: $repoPath" -ForegroundColor Green
    Write-Host "Branch: $branchName" -ForegroundColor Green
    Write-Host "Remote: $remoteUrl`n" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred while fetching repository information. Please ensure you are in a valid git repository." -ForegroundColor Red
    exit
}

# Function to parse the user input into a DateTime object
function Invoke-Parse-Date {
    param (
        [string]$inputDate
    )

    try {
        # Handle the special case of "today"
        if ($inputDate.ToLower() -eq "today") {
            return Get-Date
        }

        # Attempt to parse using built-in .NET methods
        $parsedDate = [DateTime]::Parse($inputDate)
        return $parsedDate
    }
    catch {
        # Handle relative date strings like "1 year ago", "yesterday", etc.
        switch -Regex ($inputDate.ToLower()) {
            '(\d+)\s*day[s]?\s*ago' { return (Get-Date).AddDays(-$matches[1]) }
            '(\d+)\s*week[s]?\s*ago' { return (Get-Date).AddDays( - ($matches[1] * 7)) }
            '(\d+)\s*month[s]?\s*ago' { return (Get-Date).AddMonths(-$matches[1]) }
            '(\d+)\s*year[s]?\s*ago' { return (Get-Date).AddYears(-$matches[1]) }
            'yesterday' { return (Get-Date).AddDays(-1) }
            '(\d{1,2})[-/](\d{1,2})[-/](\d{2,4})' {
                $day = $matches[1]
                $month = $matches[2]
                $year = $matches[3]
                if ($year.Length -eq 2) {
                    $year = "20$year" # Assume 2000s for 2-digit year
                }
                return [DateTime]::Parse("$year-$month-$day")
            }
            default {
                Write-Host "Unrecognized date format. Please try again." -ForegroundColor Red
                exit
            }
        }
    }
}

# Prompt user for commit type: single day or range
Write-Host "Do you want to simulate commits for a single day or a range of dates? (single/1 or range/N):" -ForegroundColor Cyan
$commitType = Read-Host

if ($commitType.ToLower() -match '^(single|1)$') {
    # Prompt user for a single day date
    Write-Host "Enter the date for the single day (e.g., '1 month ago', '12-05-23', 'today', etc.):" -ForegroundColor Cyan
    $singleDateInput = Read-Host

    # Parse the single date
    $singleDate = Invoke-Parse-Date -inputDate $singleDateInput

    # Generate a random number of commits (between 1 and 10) for the single date
    $commitCount = Get-Random -Minimum 1 -Maximum 11
    for ($i = 1; $i -le $commitCount; $i++) {
        $randomMessage = "Simulated commit #$i on $singleDate"
        # Suppress Git output and handle commit with custom message
        git commit --allow-empty -m $randomMessage --date "$singleDate" >$null 2>&1
        Write-Host "Simulating commit: '$randomMessage' on $singleDate" -ForegroundColor Green
    }
    Write-Host "Completed $commitCount commit(s) on $singleDate." -ForegroundColor Yellow
}
elseif ($commitType.ToLower() -match '^(range|n)$') {
    # Prompt user for a start date
    Write-Host "Enter the start date (e.g., '1 month ago', '12-05-23', 'today', etc.):" -ForegroundColor Cyan
    $startDateInput = Read-Host

    # Parse the start date
    $startDate = Invoke-Parse-Date -inputDate $startDateInput

    # Prompt user for an end date
    Write-Host "Enter the end date (e.g., '5 days ago', '12-05-23', 'today', etc.):" -ForegroundColor Cyan
    $endDateInput = Read-Host

    # Parse the end date
    $endDate = Invoke-Parse-Date -inputDate $endDateInput

    # Validate that the end date is not before the start date
    if ($endDate -lt $startDate) {
        Write-Host "End date cannot be earlier than start date. Please try again." -ForegroundColor Red
        exit
    }

    # Iterate from the start date to the end date
    $currentDate = $startDate
    while ($currentDate -le $endDate) {
        $commitCount = Get-Random -Minimum 1 -Maximum 11
        for ($i = 1; $i -le $commitCount; $i++) {
            $randomMessage = "Simulated commit #$i on $currentDate"
            # Suppress Git output and handle commit with custom message
            git commit --allow-empty -m $randomMessage --date "$currentDate" >$null 2>&1
            Write-Host "Simulating commit: '$randomMessage' on $currentDate" -ForegroundColor Green
        }
        $currentDate = $currentDate.AddDays(1)
    }

    Write-Host "Completed commits simulation from $startDateInput to $endDateInput." -ForegroundColor Yellow
}
else {
    Write-Host "Invalid input. Please enter 'single', '1', 'range', or 'N'." -ForegroundColor Red
    exit
}

# Function to validate user input for yes/no questions
function Invoke-Validate-YesNoInput {
    param (
        [string]$inputYN
    )
    
    switch -Regex ($inputYN.ToLower()) {
        '^(yes|y)$' { return $true }
        '^(no|n)$' { return $false }
        default { 
            Write-Host "Invalid input. Please enter 'yes', 'no', 'y', or 'n'." -ForegroundColor Red
            exit
        }
    }
}

# Prompt the user if they want to push the changes
Write-Host "Do you want to push the simulated commits to the remote repository? (yes/no):" -ForegroundColor Cyan
$pushChangesInput = Read-Host
$pushChanges = Invoke-Validate-YesNoInput -input $pushChangesInput

if ($pushChanges) {
    git push >$null 2>&1
    Write-Host "Changes have been pushed to the remote repository." -ForegroundColor Green
}
else {
    Write-Host "Changes were not pushed." -ForegroundColor Yellow
}

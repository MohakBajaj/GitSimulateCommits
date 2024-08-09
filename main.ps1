# Git Commit Simulator
# Function to parse the user input into a DateTime object
function Invoke-Parse-Date {
    param (
        [string]$inputDate
    )

    try {
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
                Write-Error "Unrecognized date format. Please try again."
                exit
            }
        }
    }
}

# Prompt user for a past timeline
$timeline = Read-Host "Enter the past timeline (e.g., '1 year ago', '5 days', '12-05-23', etc.)"

# Parse the input date
$commitDate = Invoke-Parse-Date -inputDate $timeline

# Ask the user if they want to simulate commits up to today
$simulateToToday = Read-Host "Do you want to simulate commits up to today? (yes/no)"

if ($simulateToToday -eq 'yes') {
    # Iterate from the commitDate to today
    while ($commitDate -le (Get-Date)) {
        $commitCount = Get-Random -Minimum 1 -Maximum 11
        for ($i = 1; $i -le $commitCount; $i++) {
            $randomMessage = "Simulated commit #$i on $commitDate"
            git commit --allow-empty -m $randomMessage --date "$commitDate"
            Write-Host "Created commit #$i with message '$randomMessage' on $commitDate"
        }
        $commitDate = $commitDate.AddDays(1)
    }
    Write-Host "Completed commits simulation from $timeline to today."
}
else {
    # Generate a random number of commits (between 1 and 10) for the single date
    $commitCount = Get-Random -Minimum 1 -Maximum 11

    for ($i = 1; $i -le $commitCount; $i++) {
        $randomMessage = "Simulated commit #$i"
        git commit --allow-empty -m $randomMessage --date "$commitDate"
        Write-Host "Created commit #$i with message '$randomMessage' on $commitDate"
    }
    Write-Host "Completed $commitCount commit(s) on $commitDate."
}

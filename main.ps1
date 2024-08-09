# GitCommitSimulator


# Function to parse user input into a DateTime object
function Parse-Date {
    param (
        [string]$inputDate
    )

    try {
        $parsedDate = [DateTime]::Parse($inputDate)
        return $parsedDate
    }
    catch {
        Write-Host "Unable to parse date. Please use formats like '1 year ago', '5 days ago', '12-05-23', etc." -ForegroundColor Red
        exit
    }
}

# Prompt user for start and end dates
Write-Host "Enter the start date (e.g., '1 year ago', '5 days ago', '12-05-23', etc.)" -ForegroundColor Green
$startDateInput = Read-Host "Start Date"
$startDate = Parse-Date -inputDate $startDateInput

Write-Host "Enter the end date (e.g., 'today', '5 days ago', '12-05-23', etc.)" -ForegroundColor Green
$endDateInput = Read-Host "End Date"
$endDate = Parse-Date -inputDate $endDateInput

# Ensure the end date is not before the start date
if ($endDate -lt $startDate) {
    Write-Host "End date cannot be before start date. Please try again." -ForegroundColor Red
    exit
}

# Simulate commits for each day in the range
$currentDate = $startDate
while ($currentDate -le $endDate) {
    $commitCount = Get-Random -Minimum 1 -Maximum 11
    for ($i = 1; $i -le $commitCount; $i++) {
        $randomMessage = "Simulated commit #$i on $currentDate"
        git commit --allow-empty -m $randomMessage --date "$currentDate"
        Write-Host "Created commit #$i on $currentDate"
    }
    $currentDate = $currentDate.AddDays(1)
}
Write-Host "Simulated commits from $startDate to $endDate." -ForegroundColor Cyan

# Summary message
Write-Host "Simulation complete. Check your git log to see the results." -ForegroundColor Yellow

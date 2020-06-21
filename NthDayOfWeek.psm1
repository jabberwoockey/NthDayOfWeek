function Get-NthDayOfWeek {
<#
.SYNOPSiS
Get-NthDayOfWeek calculates the Nth day of the week of a month.
.DESCRIPTION
Get-NthDayOfWeek calculates the Nth day of the week of a month.
By default without arguments the function returns second tuesdays (Patch
Tuesdays) of the current year. It allows to calculate a specific day of the
week for any month you like or a list of days of the week for any year.
.EXAMPLE
Get-NthDayOfWeek
Returns second tuesdays of the current year. 'Get-NthDayOfWeek 2021' or
'Get-NthDayOfWeek -Year 2021' returns second tuesdays of the specific year.
.EXAMPLE
Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October
Returns the fourth Saturday of October. The following commands return the
same result:
Get-NthDayOfWeek Fourth Saturday October
Get-NthDayOfWeek fo sa o
Get-NthDayOfWeek 4 6 10
.EXAMPLE
Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October -Year 1985
Returns the fourth Saturday of October 1985. The following commands return the
same result:
Get-NthDayOfWeek Fourth Saturday October 1985
Get-NthDayOfWeek fo sa o 1985
Get-NthDayOfWeek 4 6 10 1985
.EXAMPLE
Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Year 1985
Returns a list of fourth Saturdays in 1985. The following commands return the
same result:
Get-NthDayOfWeek Fourth Saturday 1985
Get-NthDayOfWeek fo sa 1985
Get-NthDayOfWeek 4 6 1985
#>
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [ArgumentCompleter({"First","Second","Third","Fourth"})]
        [string]$Day = "Second",
        [Parameter(Position=1)]
        [ArgumentCompleter({"Monday","Tuesday","Wednesday","Thursday",
                            "Friday","Saturday","Sunday"})]
        [string]$DayOfWeek = "Tuesday",
        [Parameter(Position=2)]
        [ArgumentCompleter({"January","February","March","April",
                            "May","June","July","August","September",
                            "October","November","December"})]
        [string]$Month = (Get-Date).Month,
        [Parameter(Position=3)]
        [ValidatePattern("^[\d]{4}$")]
        [int]$Year = (Get-Date).Year
        )
        
        # Initial variables
        [int]$WeekCounter = 0
    [int]$DayCounter = 1
    [string]$MonthNum = (Get-Date).month
    $Days = @("First","Second","Third","Fourth")
    $DaysOfWeek = @("Monday","Tuesday","Wednesday","Thursday",
    "Friday","Saturday","Sunday")
    $Months = @("January","February","March","April",
    "May","June","July","August","September",
    "October","November","December")
    
    Write-Verbose 'Check default behavior'
    if (-not $PSBoundParameters.ContainsKey('Day') -and
        -not $PSBoundParameters.ContainsKey('DayOfWeek') -and
        -not $PSBoundParameters.ContainsKey('Month') -and
        -not $PSBoundParameters.ContainsKey('Year')) {
            $PSBoundParameters.Add('Day', 'Second')
            $PSBoundParameters.Add('DayOfWeek', 'Tuesday')
            $PSBoundParameters.Add('Year', (Get-Date).Year)
            Write-Verbose 'The list for the current year was chosen'
    }

    Write-Verbose "Check the day"
    switch -Regex ($Day) {
        "^(fi(r|rs|rst)?|1(st)?)$" {
            $DayNum = 1; $Day = $Days[0]}
        "^(s(e|ec|eco|econ|econd)?|2(nd)?)$" {
            $DayNum = 2; $Day = $Days[1]}
        "^(t(h|hi|hir|hird)?|3(rd)?)$" {
            $DayNum = 3; $Day = $Days[2]}
        "^(fo(u|ur|urt|urth)?|4(th)?)$"      {
            $DayNum = 4; $Day = $Days[3]}
        "^[0-9]{4}$" {
            $DayNum = 2
            $PSBoundParameters.Add('Year', '')
            $Year = $Day
            $Day = 'Second'
            $PSBoundParameters.Add('DayOfWeek', 'Tuesday')
            Write-Verbose 'The day arg was substituted by the year arg'
        }
        Default {
            Write-Error -ErrorAction Stop -Message `
            'Wrong or ambiguous value for the day.'}
    }

    Write-Verbose 'Check amount of parameters'
    if ($PSBoundParameters.ContainsKey('Day') -and
        (-not $PSBoundParameters.ContainsKey('DayOfWeek'))) {
            Write-Error -ErrorAction Stop -Message `
            'Not enough arguments.'
    }

    Write-Verbose "Check the day of the week"
    switch -Regex ($DayOfWeek) {
        "^(m(o|on|ond|onda|onday)?|1)$" {
            $DayOfWeek = $DaysOfWeek[0]}
        "^(tu(e|es|esd|esda|esday)?|2)$" {
            $DayOfWeek = $DaysOfWeek[1]}
        "^(w(e|ed|edn|edne|ednes|ednesd|ednesda|ednesday)?|3)$" {
            $DayOfWeek = $DaysOfWeek[2]}
        "^(th(u|ur|urs|ursd|ursda|ursday)?|4)$" {
            $DayOfWeek = $DaysOfWeek[3]}
        "^(f(r|ri|rid|rida|riday)?|5)$" {
            $DayOfWeek = $DaysOfWeek[4]}
        "^(sa(t|tu|tur|turd|turda|turday)?|6)$" {
            $DayOfWeek = $DaysOfWeek[5]}
        "^(su(n|nd|nda|nday)?|7|0)$" {
            $DayOfWeek = $DaysOfWeek[6]}
        Default {
            Write-Error -ErrorAction Stop `
                -Message 'Wrong or ambiguous value for the day of the week.'}
    }

    Write-Verbose 'Check the month'
    switch -Regex ($Month) {
        "^(j(a|an|anu|anua|anuar|anuary)?|1)$" {
            $MonthNum = 1; $Month = $Months[0]}
        "^(f(e|eb|ebr|ebru|ebrua|ebruar|ebruary)?|2)$" {
            $MonthNum = 2; $Month = $Months[1]}
        "^(mar(c|ch)?|3)$" {
            $MonthNum = 3; $Month = $Months[2]}
        "^(ap(r|ri|ril)?|4)$" {
            $MonthNum = 4; $Month = $Months[3]}
        "^(may|5)$" {
            $MonthNum = 5; $Month = $Months[4]}
        "^(jun(e)?|6)$" {
            $MonthNum = 6; $Month = $Months[5]}
        "^(jul(y)?|7)$" {
            $MonthNum = 7; $Month = $Months[6]}
        "^(au(g|gu|gus|gust)?|8)$" {
            $MonthNum = 8; $Month = $Months[7]}
        "^(s(e|ep|ept|epte|eptem|eptemb|eptembe|eptember)?|9)$" {
            $MonthNum = 9; $Month = $Months[8]}
        "^(o(c|ct|cto|ctob|ctobe|ctober)?|10)$" {
            $MonthNum = 10; $Month = $Months[9]}
        "^(n(o|ov|ove|ovem|ovemb|ovembe|ovember)?|11)$" {
            $MonthNum = 11; $Month = $Months[10]}
        "^(d(e|ec|ece|ecem|ecemb|ecembe|ecember)?|12)$" {
            $MonthNum = 12; $Month = $Months[11]}
        "^[0-9]{4}$" {
            $PSBoundParameters.Add('Year', '')
            $Year = $Month
            # Out-Null to remove verbose output of remove
            $PSBoundParameters.Remove('Month') | Out-Null
            Write-Verbose 'The month arg was substituted by the year arg'}
        Default {
            Write-Error -ErrorAction Stop `
                -Message 'Wrong or ambiguous value for the month.'}
    }

    if ($PSBoundParameters.ContainsKey('Month') -or
            ($PSBoundParameters.ContainsKey('Day') -and
            $PSBoundParameters.ContainsKey('DayOfWeek') -and
            (-not $PSBoundParameters.ContainsKey('Month')) -and
            (-not $PSBoundParameters.ContainsKey('Year')))) {
        Write-Verbose "Calculating the day of the week for $Month $Year"
        while ($WeekCounter -lt $DayNum) {
            if ((Get-Date -Day $DayCounter -Month $MonthNum `
                          -Year $Year).DayOfWeek -eq $DayOfWeek) {
                $WeekCounter += 1
            }
            $DayCounter += 1
        }

        Write-Verbose 'Writing output'
        $obj = [PSCustomObject]@{
            DayOfWeek = $Day + " " + $DayOfWeek + " of " `
                + $Months[$MonthNum - 1] + " " + $Year
            Date  = (Get-Date -Day ($DayCounter - 1) -Month $MonthNum `
                -Year $Year).ToShortDateString()
        }
        Write-Output $obj
    }
    elseif ((-not $PSBoundParameters.ContainsKey('Month')) -and `
            ($PSBoundParameters.ContainsKey('Year'))) {
        foreach ($i in (1..12)) {
            Write-Verbose "Calculating the day of the week for $i month $Year"
            while ($WeekCounter -lt $DayNum) {
                if ((Get-Date -Day $DayCounter -Month $i `
                        -Year $Year).DayOfWeek -eq $DayOfWeek) {
                    $WeekCounter += 1
                }
                $DayCounter += 1
            }

            Write-Verbose 'Writing output'
            $obj = [PSCustomObject]@{
                DayOfWeek = $Day + " " + $DayOfWeek + " of " `
                    + $Months[$i - 1] + " " + $Year
                Date  = (Get-Date -Day ($DayCounter - 1) -Month $i `
                    -Year $Year).ToShortDateString()
            }
            Write-Output $obj
            $WeekCounter = 0
            $DayCounter = 1
        }
    }
}
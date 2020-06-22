function Get-NthDayOfWeek {
<#
.SYNOPSiS
Get-NthDayOfWeek calculates the Nth day of the week.
.DESCRIPTION
Get-NthDayOfWeek calculates the Nth day of the week.
By default without arguments the function returns second tuesdays (Patch
Tuesdays) for the current year (or the next year with the switch '-Next').
It allows to calculate a specific day of the week for any month you like or
a list of days of the week for any year.
.EXAMPLE
Get-NthDayOfWeek
Returns second tuesdays of the current year. 'Get-NthDayOfWeek 2021' or
'Get-NthDayOfWeek -Year 2021' returns second tuesdays of the specific year.
.EXAMPLE
Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October
Returns the fourth Saturday of October. The following commands return the
same result:
Get-NthDayOfWeek Fourth Saturday October
gndw fo sa o
gndw 4 6 10
.EXAMPLE
Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October -Year 1985
Returns the fourth Saturday of October 1985. The following commands return the
same result:
Get-NthDayOfWeek Fourth Saturday October 1985
gndw fo sa o 1985
gndw 4 6 10 1985
.EXAMPLE
Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Year 1985
Returns a list of fourth Saturdays in 1985. The following commands return the
same result:
Get-NthDayOfWeek Fourth Saturday 1985
gndw fo sa 1985
gndw 4 6 1985
.EXAMPLE
Get-NthDayOfWeek -Day Second -DayOfWeek Tuesday -Next
Returns the next closest day of week for the current or next month. 
gndw 2 2 -next
.EXAMPLE
Get-NthDayOfWeek -Day Last -DayOfWeek Tuesday -Month March -Year 1961
Returns the last day of week for a month or a year.
Get-NthDayOfWeek Last Tuesday March
gndw -2 2 3 2025
#>
    [CmdletBinding()]
    [Alias('gndw')]
    param (
        [Parameter(Position=0)]
        [ArgumentCompleter({'First','Second','Third','Fourth',
                            'Fifth','Last','Penultimate',
                            'Antepenultimate','Preantepenultimate',
                            'Propreantepenultimate'})]
        [string]$Day = 'Second',
        [Parameter(Position=1)]
        [ArgumentCompleter({'Monday','Tuesday','Wednesday','Thursday',
                            'Friday','Saturday','Sunday'})]
        [string]$DayOfWeek = 'Tuesday',
        [Parameter(Position=2)]
        [ArgumentCompleter({'January','February','March','April',
                            'May','June','July','August','September',
                            'October','November','December'})]
        [string]$Month = (Get-Date).Month,
        [Parameter(Position=3)]
        [ValidatePattern('^[\d]{4}$')]
        [int]$Year = (Get-Date).Year,
        [switch]$Next
        )

    function Get-Day {
        param (
            [int]$DayVar,
            [int]$MonthVar
        )
        Write-Verbose "Calculating the $Day $DayOfWeek for $MonthVar/$Year"
        $LastDay = (Get-Date -Day 1 -Month $MonthVar -Year $Year).AddMonths(1).AddDays(-1).Day
        [string]$DateValue = ''
        [int]$WeekCounter = 0
        Write-Debug "LastDay: $LastDay; DayVar: $DayVar; MonthVar: $MonthVar"
        if ($DayVar -lt 0) {
            [int]$DayCounter = $LastDay
            Write-Debug "WeekCounter: $WeekCounter; DayCounter: $DayCounter"
            while ($WeekCounter -lt [Math]::abs($DayVar) -and $DayCounter -ge 1) {
                if ((Get-Date -Day $DayCounter -Month $MonthVar `
                              -Year $Year).DayOfWeek -eq $DayOfWeek) {
                    $WeekCounter += 1
                }
                elseif ($DayCounter -eq 1) {
                    $DateValue = 'No such a day'
                }
                $DayCounter -= 1
                Write-Debug "WeekCounter: $WeekCounter; DayCounter: $DayCounter"
            }
            $DayCounter += 1
        }
        else {
            [int]$DayCounter = 1
            Write-Debug "WeekCounter: $WeekCounter; DayCounter: $DayCounter"
            while ($WeekCounter -lt $DayVar -and $DayCounter -le $LastDay) {
                if ((Get-Date -Day $DayCounter -Month $MonthVar `
                              -Year $Year).DayOfWeek -eq $DayOfWeek) {
                    $WeekCounter += 1
                }
                elseif ($DayCounter -eq $LastDay) {
                    $DateValue = 'No such a day'
                }
                $DayCounter += 1
                Write-Debug "WeekCounter: $WeekCounter; DayCounter: $DayCounter"
            }
            $DayCounter -= 1
        }
        if ($DateValue -eq '') {
            $DateValue = (Get-Date -Day ($DayCounter) -Month $MonthVar `
                -Year $Year).ToShortDateString()
        }
        return $DateValue
        Write-Verbose "Calculated date is $DateValue"
    } # end of Get-Day function

    function Write-OutputObject {
        param (
            [string]$NameField,
            [string]$DateField
        )
        Write-Verbose 'Creating output object'
        $obj = [PSCustomObject]@{
            $Props[0] = $NameField
            $Props[1] = $DateField
        }
        Write-Verbose 'Writing output'
        Write-Output $obj
    } # end of Write-OutputObject function

    $Days = @('First','Second','Third','Fourth',
            'Fifth','Last','Second to last','Third to last',
            'Fourth to last','Fifth to last')
    $DaysOfWeek = @('Monday','Tuesday','Wednesday','Thursday',
            'Friday','Saturday','Sunday')
    $Months = @('January','February','March','April',
            'May','June','July','August','September',
            'October','November','December')
    $Props = @('DayOfWeek','Date')

    Write-Debug "Bound Parameters: $(($PSBoundParameters).keys)"
    Write-Verbose 'Check default behavior'
    if (-not $PSBoundParameters.ContainsKey('Day') -and
            -not $PSBoundParameters.ContainsKey('DayOfWeek') -and
            -not $PSBoundParameters.ContainsKey('Month') -and
            -not $PSBoundParameters.ContainsKey('Year')) {
        $PSBoundParameters.Add('Day', $Day)
        $PSBoundParameters.Add('DayOfWeek', $DayOfWeek)
        $PSBoundParameters.Add('Year', $Year)
        if ($PSBoundParameters.ContainsKey('Next')) {
            $Year = ((Get-Date).Year + 1)
        }
        Write-Verbose 'The list for the current year was chosen'
        Write-Debug "Bound Parameters: $(($PSBoundParameters).keys)"
        Write-Debug "Day: $Day; DayOfWeek: $DayOfWeek; Year: $Year"
    }

    Write-Verbose 'Check the day'
    switch -Regex ($Day) {
        '^(fir(s|st)?|1(st)?)$' {
            $DayNum = 1; $Day = $Days[0]}
        '^(s(e|ec|eco|econ|econd)?|2(nd)?)$' {
            $DayNum = 2; $Day = $Days[1]}
        '^(t(h|hi|hir|hird)?|3(rd)?)$' {
            $DayNum = 3; $Day = $Days[2]}
        '^(fo(u|ur|urt|urth)?|4(th)?)$' {
            $DayNum = 4; $Day = $Days[3]}
        '^(fif(t|th)?|5(th)?)$' {
            $DayNum = 5; $Day = $Days[4]}
        '^(l(a|as|ast)?|-1)$' {
            $DayNum = -1; $Day = $Days[5]}
        '^(pe(n|nu|nul|nult(.{1,5})?)?|-2)$' {
            $DayNum = -2; $Day = $Days[6]}
        '^(a(n|nt|nte|ntep|ntepe|ntepen(.{1,8})?)?|-3)$' {
            $DayNum = -3; $Day = $Days[7]}
        '^(pre(a|an|ant|ante|antep(.{1,10})?)?|-4)$' {
            $DayNum = -4; $Day = $Days[8]}
        '^(pro(p|pr|pre|prea|prean|preant(.{1,12}))?|-5)$' {
            $DayNum = -5; $Day = $Days[9]}
        '^[0-9]{4}$' {
            $DayNum = 2
            $PSBoundParameters.Add('Year', '')
            $Year = $Day
            $Day = 'Second'
            $PSBoundParameters.Add('DayOfWeek', 'Tuesday')
            Write-Verbose 'The day arg was substituted by the year arg'
            Write-Debug "Bound Parameters: $(($PSBoundParameters).keys)"
        }
        Default {
            Write-Error -ErrorAction Stop -Message `
            'Wrong or ambiguous value for the day.'}
    }
    Write-Debug "DayNum: $DayNum; Day: $Day"

    Write-Verbose 'Check amount of parameters'
    if ($PSBoundParameters.ContainsKey('Day') -and
        (-not $PSBoundParameters.ContainsKey('DayOfWeek'))) {
            Write-Error -ErrorAction Stop -Message `
            'Not enough arguments.'
    }

    Write-Verbose 'Check the day of the week'
    switch -Regex ($DayOfWeek) {
        '^(m(o|on|ond|onda|onday)?|1)$' {
            $DayOfWeek = $DaysOfWeek[0]}
        '^(tu(e|es|esd|esda|esday)?|2)$' {
            $DayOfWeek = $DaysOfWeek[1]}
        '^(w(e|ed|edn|edne|ednes|ednesd|ednesda|ednesday)?|3)$' {
            $DayOfWeek = $DaysOfWeek[2]}
        '^(th(u|ur|urs|ursd|ursda|ursday)?|4)$' {
            $DayOfWeek = $DaysOfWeek[3]}
        '^(f(r|ri|rid|rida|riday)?|5)$' {
            $DayOfWeek = $DaysOfWeek[4]}
        '^(sa(t|tu|tur|turd|turda|turday)?|6)$' {
            $DayOfWeek = $DaysOfWeek[5]}
        '^(su(n|nd|nda|nday)?|7|0)$' {
            $DayOfWeek = $DaysOfWeek[6]}
        Default {
            Write-Error -ErrorAction Stop `
                -Message 'Wrong or ambiguous value for the day of the week.'}
    }
    Write-Debug "DayOfWeek: $DayOfWeek"

    Write-Verbose 'Check the month'
    switch -Regex ($Month) {
        '^(j(a|an|anu|anua|anuar|anuary)?|1)$' {
            $MonthNum = 1; $Month = $Months[0]}
        '^(f(e|eb|ebr|ebru|ebrua|ebruar|ebruary)?|2)$' {
            $MonthNum = 2; $Month = $Months[1]}
        '^(mar(c|ch)?|3)$' {
            $MonthNum = 3; $Month = $Months[2]}
        '^(ap(r|ri|ril)?|4)$' {
            $MonthNum = 4; $Month = $Months[3]}
        '^(may|5)$' {
            $MonthNum = 5; $Month = $Months[4]}
        '^(jun(e)?|6)$' {
            [int]$MonthNum = 6; $Month = $Months[5]}
        '^(jul(y)?|7)$' {
            $MonthNum = 7; $Month = $Months[6]}
        '^(au(g|gu|gus|gust)?|8)$' {
            $MonthNum = 8; $Month = $Months[7]}
        '^(s(e|ep|ept|epte|eptem|eptemb|eptembe|eptember)?|9)$' {
            $MonthNum = 9; $Month = $Months[8]}
        '^(o(c|ct|cto|ctob|ctobe|ctober)?|10)$' {
            $MonthNum = 10; $Month = $Months[9]}
        '^(n(o|ov|ove|ovem|ovemb|ovembe|ovember)?|11)$' {
            $MonthNum = 11; $Month = $Months[10]}
        '^(d(e|ec|ece|ecem|ecemb|ecembe|ecember)?|12)$' {
            $MonthNum = 12; $Month = $Months[11]}
        '^[0-9]{4}$' {
            $PSBoundParameters.Add('Year', '')
            $Year = $Month
            # Out-Null to remove verbose output of remove
            $PSBoundParameters.Remove('Month') | Out-Null
            Write-Verbose 'The month arg was substituted by the year arg'
            Write-Debug "Bound Parameters: $(($PSBoundParameters).keys)"}
        Default {
            Write-Error -ErrorAction Stop `
                -Message 'Wrong or ambiguous value for month or year.'}
    }
    Write-Debug "MonthNum: $MonthNum; Month: $Month"

    Write-Verbose 'Start calculation'
    if ($Next -eq $true -and
            $PSBoundParameters.ContainsKey('Day') -and
            $PSBoundParameters.ContainsKey('DayOfWeek') -and
            (-not $PSBoundParameters.ContainsKey('Month')) -and
            (-not $PSBoundParameters.ContainsKey('Year'))) {
        Write-Verbose "Looking for the next $Day $DayOfWeek"
        # TODO: see below
        if ($DayNum -eq -5) {
            Write-Error -ErrorAction Stop `
                -Message "Support for Day = -5 and Next isn't implemented yet."
        }
        $DateResult = Get-Day -MonthVar $MonthNum -DayVar $DayNum
        if ((Get-Date $DateResult) -le (Get-Date).Date) {
            if ($MonthNum -eq 12) {
                Write-Verbose 'Last month, incrementing the year'
                $Year += 1
                $MonthNum = 0
            }
            $DateResult = Get-Day -MonthVar $($MonthNum + 1) `
                -DayVar $DayNum
        }
        $DayTitle = 'Next ' + $Day + ' ' + $DayOfWeek
        Write-OutputObject -NameField $DayTitle -DateField $DateResult
    }
    elseif ($PSBoundParameters.ContainsKey('Month') -or
            ($PSBoundParameters.ContainsKey('Day') -and
            $PSBoundParameters.ContainsKey('DayOfWeek') -and
            (-not $PSBoundParameters.ContainsKey('Month')) -and
            (-not $PSBoundParameters.ContainsKey('Year')))) {
        $DateResult = Get-Day -MonthVar $MonthNum -DayVar $DayNum
        $DayTitle = $Day + ' ' + $DayOfWeek + ' of ' `
            + $Months[$MonthNum - 1] + ' ' + $Year
        Write-OutputObject -NameField $DayTitle -DateField $DateResult
    }
    elseif ((-not $PSBoundParameters.ContainsKey('Month')) -and `
            ($PSBoundParameters.ContainsKey('Year'))) {
        Write-Verbose "Calculating for year $Year"
        foreach ($iMonth in (1..12)) {
            Write-Verbose 'Creating object'
            $DateResult = Get-Day -MonthVar $iMonth -DayVar $DayNum
            $DayTitle = $Day + ' ' + $DayOfWeek + ' of ' `
                + $Months[$iMonth - 1] + ' ' + $Year
            Write-OutputObject -NameField $DayTitle -DateField $DateResult
        }
    }
}
function Get-NthDayOfWeek {
<#
.SYNOPSiS
Get-NthDayOfWeek calculates the Nth day of the week.
.DESCRIPTION
Get-NthDayOfWeek calculates the Nth day of the week.
By default without arguments the function returns second tuesdays (Patch
Tuesdays) for the current year (or the next or previous year with an according
switch). It allows to calculate a specific day of the week for any month you
like or a list of days of the week for any year.
.PARAMETER Day
Specifies an ordinal number of the day. Possible values: words and their
shortened forms - first, second, sec, s, 1st, 3rd, last, penultimate and so on;
numbers - 1..5 or -1..-5 for last, second to last, etc.
.PARAMETER DayOfWeek
Specifies a day of the week. Possible values: words and their shortened forms -
monday, tue, su and so on; numbers - 1, 2, 3, 4, 5, 6, 7(0).
.PARAMETER Month
Specifies a month. Possible values: words and their shortened forms - January,
feb, s, n and so on; numbers - 1..12.
.PARAMETER Year
Specifies a year. Possible values: a four digit number.
.PARAMETER Next
A switch that specifies whether to show the next date(s) or not. It works with a
Day/DayOfWeek pair or with a Year.
.PARAMETER Previous
A switch that specifies whether to show the previous date(s) or not. It works
with a Day/DayOfWeek pair or with a Year.
.PARAMETER Friday13th
A switch to search Friday 13th in the current, next/previous (with an
according switch), or any other specified year.
.INPUTS
Not implemented yet.
.OUTPUTS
[System.Management.Automation.PSCustomObject]
.NOTES
Various examples:
"1..7 | foreach {gndw 5 $_ 8 1999}"
"1..12 | foreach {gndw 1 1 $_}" all first Mondays of the year
"1..5 | foreach {gndw $_ 1 -n}" next five Mondays
"foreach ($y in 1900..2000) {gndw 2 2 -Year $y}" all Second Tuesdays of 20th century
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
Returns the next closest day of week for the current or next/previous month.
gndw 2 2 -next
gndw -2 4 -previous
.EXAMPLE
Get-NthDayOfWeek -Day Last -DayOfWeek Tuesday -Month March -Year 1961
Returns the last day of week for a month or a year.
Get-NthDayOfWeek Last Tuesday March
gndw -2 2 3 2025
.LINK
https://github.com/jabberwoockey/NthDayOfWeek
.LINK
Get-Date
#>
    [CmdletBinding(DefaultParameterSetName='Base')]
    [Alias('gndw')]
    param (
        [Parameter(Position=0,ParameterSetName='Base')]
        [Parameter(Position=0,ParameterSetName='BaseMonth')]
        [Parameter(Position=0,ParameterSetName='BaseNext')]
        [Parameter(Position=0,ParameterSetName='BasePrev')]
        [ArgumentCompleter({'First','Second','Third','Fourth',
                            'Fifth','Last','Penultimate',
                            'Antepenultimate','Preantepenultimate',
                            'Propreantepenultimate'})]
        [string]$Day = 'Second',
        [Parameter(Position=1,ParameterSetName='Base')]
        [Parameter(Position=1,ParameterSetName='BaseMonth')]
        [Parameter(Position=1,ParameterSetName='BaseNext')]
        [Parameter(Position=1,ParameterSetName='BasePrev')]
        [ArgumentCompleter({'Monday','Tuesday','Wednesday','Thursday',
                            'Friday','Saturday','Sunday'})]
        [string]$DayOfWeek = 'Tuesday',
        [Parameter(Mandatory=$true,Position=2,ParameterSetName='BaseMonth')]
        [ArgumentCompleter({'January','February','March','April',
                            'May','June','July','August','September',
                            'October','November','December'})]
        [string]$Month = (Get-Date).Month,
        [Parameter(Mandatory=$true,ParameterSetName='Friday13th')]
        [Parameter(Mandatory=$true,ParameterSetName='Friday13thNext')]
        [Parameter(Mandatory=$true,ParameterSetName='Friday13thPrev')]
        [switch]$Friday13th,
        [Parameter(Position=3,ParameterSetName='Base')]
        [Parameter(Position=3,ParameterSetName='BaseMonth')]
        [Parameter(ParameterSetName='Friday13th')]
        [int]$Year = (Get-Date).Year,
        [Parameter(ParameterSetName='Base')]
        [Parameter(Mandatory=$true,ParameterSetName='BaseNext')]
        [Parameter(Mandatory=$true,ParameterSetName='Friday13thNext')]
        [switch]$Next,
        [Parameter(ParameterSetName='Base')]
        [Parameter(Mandatory=$true,ParameterSetName='BasePrev')]
        [Parameter(Mandatory=$true,ParameterSetName='Friday13thPrev')]
        [switch]$Previous
    )

    Set-StrictMode -Version 3.0
    function Get-Day {
        param (
            [int]$DayVar,
            [int]$MonthVar
        )
        Write-Verbose ('Calculating the {0} {1} for {2}/{3}' `
            -f $Day, $DayOfWeek, $MonthVar, $Year)
        $LastDay = (Get-Date -Day 1 -Month $MonthVar `
            -Year $Year).AddMonths(1).AddDays(-1).Day
        [string]$DateValue = ''
        [int]$WeekCounter = 0
        Write-Debug ('LastDay: {0}; DayVar: {1}; MonthVar: {2}' `
            -f $LastDay, $DayVar, $MonthVar)
        if ($DayVar -lt 0) {
            [int]$DayCounter = $LastDay + 1
            Write-Debug ('WeekCounter: {0}; DayCounter: {1}' `
                -f $WeekCounter, $DayCounter)
            while ($WeekCounter -lt [Math]::abs($DayVar) -and
                    $DayCounter -ge 1) {
                $DayCounter -= 1
                if ($DayCounter -lt 1) {
                    $DateValue = 'No such a day'
                }
                elseif ((Get-Date -Day $DayCounter -Month $MonthVar `
                              -Year $Year).DayOfWeek -eq $DayOfWeek) {
                    $WeekCounter += 1
                }
                Write-Debug ('WeekCounter: {0}; DayCounter: {1}' `
                    -f $WeekCounter, $DayCounter)
            }
        }
        else {
            [int]$DayCounter = 0
            Write-Debug ('WeekCounter: {0}; DayCounter: {1}' `
            -f $WeekCounter, $DayCounter)
            while ($WeekCounter -lt $DayVar -and $DayCounter -le $LastDay) {
                $DayCounter += 1
                if ($DayCounter -gt $LastDay) {
                    $DateValue = 'No such a day'
                }
                elseif ((Get-Date -Day $DayCounter -Month $MonthVar `
                              -Year $Year).DayOfWeek -eq $DayOfWeek) {
                    $WeekCounter += 1
                }
                Write-Debug ('WeekCounter: {0}; DayCounter: {1}' `
                    -f $WeekCounter, $DayCounter)
            }
        }
        if ($DateValue -eq '') {
            $DateValue = (Get-Date -Day ($DayCounter) -Month $MonthVar `
                -Year $Year).ToShortDateString()
        }
        Write-Verbose ('Calculated date is {0}' -f $DateValue)
        return $DateValue, $LastDay
    } # end of Get-Day function

    function Write-OutputObject {
        param (
            [string]$NameField,
            [string]$DateField
        )
        Write-Verbose 'Creating output object'
        if ($DateField -match '[0-9].+') {
            $DaysUntilEndOfMonth = $LastDay - (Get-Date $DateField).Day

        } else {
            $DaysUntilEndOfMonth = ''

        }
        if ($DateField -match '^[0-9].+' -and
                (Get-Date $DateField) -gt (Get-Date).Date) {
            $DaysUntilDate = `
                (((Get-Date $DateField).Date).Subtract($(Get-Date))).Days
            $DaysAfterDate = ''
        } elseif ($DateField -match '^[0-9].+' -and
                (Get-Date $DateField) -lt (Get-Date).Date) {
            $DaysUntilDate = ''
            $DaysAfterDate = `
                (((Get-Date).Date).Subtract($(Get-Date $DateField))).Days
        } else {
            $DaysUntilDate = ''
            $DaysAfterDate = ''
        }
        if ($DateField -match '^[0-9].+') {
            $DayOfYear = Get-Date $DateField -UFormat '%j'
            $WeekOfYear = Get-Date $DateField -UFormat '%V'
        } else {
            $DayOfYear = ''
            $WeekOfYear = ''
        }
        $obj = [PSCustomObject]@{
            $Props[0] = $NameField
            $Props[1] = $DateField
            $Props[2] = $LastDay
            $Props[3] = $DaysUntilEndOfMonth
            $Props[4] = $DaysUntilDate
            $Props[5] = $DaysAfterDate
            $Props[6] = $DayOfYear
            $Props[7] = $WeekOfYear
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
    $Props = @('DayOfWeek','Date','DaysInMonth','DaysUntilEndOfMonth',
            'DaysUntilDate','DaysAfterDate','DayOfYear','WeekOfYear')

    Write-Verbose 'Check default behavior'
    Write-Debug ('Bound Parameters: {0}' -f $(($PSBoundParameters).keys))
    if (-not $PSBoundParameters.ContainsKey('Day') -and
            -not $PSBoundParameters.ContainsKey('DayOfWeek') -and
            -not $PSBoundParameters.ContainsKey('Month') -and
            -not $PSBoundParameters.ContainsKey('Year') -and
            $Friday13th -eq $false) {
        $PSBoundParameters.Add('Day', $Day)
        $PSBoundParameters.Add('DayOfWeek', $DayOfWeek)
        $PSBoundParameters.Add('Year', $Year)
        Write-Verbose 'The list for the current year was chosen'
        Write-Debug ('Bound Parameters: {0}' -f $(($PSBoundParameters).keys))
        Write-Debug ('Day: {0}; DayOfWeek: {1}; Year: {2}' `
            -f $Day, $DayOfWeek, $Year)
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
            Write-Debug ('Bound Parameters: {0}' -f $(($PSBoundParameters).keys))
        }
        Default {
            Write-Error -ErrorAction Stop -Message `
            'Wrong or ambiguous value for the day.'}
    }
    Write-Debug ('DayNum: {0}; Day: {1}' -f $DayNum, $Day)
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
    Write-Debug ('DayOfWeek: {0}' -f $DayOfWeek)

    Write-Verbose 'Check the month'
    Write-Debug ('Month: {0}' -f $Month)
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
            $MonthNum = 6; $Month = $Months[5]}
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
        '^([1][3-9]|[2-9][0-9]|[0-9]{3,4})$' {
            $PSBoundParameters.Add('Year', '')
            $Year = $Month
            $MonthNum = ''
            $Month = ''
            # Out-Null to remove verbose output of remove
            $PSBoundParameters.Remove('Month') | Out-Null
            Write-Verbose 'The month arg was substituted by the year arg'
            Write-Debug ('Bound Parameters: {0}' -f $(($PSBoundParameters).keys))
        }
        Default {
            Write-Error -ErrorAction Stop `
            -Message 'Wrong or ambiguous value for month or year.'}
        }
    Write-Debug ('MonthNum: {0}; Month: {1}' -f $MonthNum, $Month)

    Write-Verbose 'Check the year'
    Write-Debug ('Year: {0}' -f $Year)
    if ($Year -le 0 -or $Year -ge 9998) {
        Write-Error -ErrorAction Stop `
            -Message 'Wrong or ambiguous value for year.'
    }

    Write-Verbose 'Start calculation'
    if ($Next -eq $true -and
            $PSBoundParameters.ContainsKey('Day') -and
            $PSBoundParameters.ContainsKey('DayOfWeek') -and
            (-not $PSBoundParameters.ContainsKey('Month')) -and
            (-not $PSBoundParameters.ContainsKey('Year'))) {
        Write-Verbose ('Looking for the next {0} {1}' -f $Day, $DayOfWeek)
        $DateResult, $LastDay = Get-Day -DayVar $DayNum -MonthVar $MonthNum
        Write-Verbose ('{0} in {1}' -f $DateResult, $Months[$MonthNum-1])
        while ($DateResult -match '^No.+$' -or
                (Get-Date $DateResult) -le (Get-Date).Date) {
            $MonthNum += 1
            Write-Verbose ('Looking for another one in {0}' `
                -f $Months[$MonthNum-1])
            if ($MonthNum -ge 13) {
                Write-Verbose ('Last month, incrementing the year: {0}' -f $Year)
                $Year += 1
                $MonthNum = 1
            }
            $DateResult, $LastDay = Get-Day -DayVar $DayNum -MonthVar $MonthNum
            Write-Verbose ('Found: {0}' -f $DateResult)
        }
        $DayTitle = 'Next ' + $Day + ' ' + $DayOfWeek
        Write-OutputObject -NameField $DayTitle -DateField $DateResult
    }
    elseif ($Previous -eq $true -and
            $PSBoundParameters.ContainsKey('Day') -and
            $PSBoundParameters.ContainsKey('DayOfWeek') -and
            (-not $PSBoundParameters.ContainsKey('Month')) -and
            (-not $PSBoundParameters.ContainsKey('Year'))) {
        Write-Verbose ('Looking for the previous {0} {1}' -f $Day, $DayOfWeek)
        $DateResult, $LastDay = Get-Day -DayVar $DayNum -MonthVar $MonthNum
        Write-Verbose ('{0} in {1}' -f $DateResult, $Months[$MonthNum-1])
        while ($DateResult -match '^No.+$' -or
                (Get-Date $DateResult) -ge (Get-Date).Date) {
            $MonthNum -= 1
            Write-Verbose ('Looking for another one in {0}' `
                -f $Months[$MonthNum-1])
            if ($MonthNum -le 0) {
                Write-Verbose ('Last month, incrementing year: {0}' -f $Year)
                $Year -= 1
                $MonthNum = 12
            }
            $DateResult, $LastDay = Get-Day -DayVar $DayNum -MonthVar $MonthNum
            Write-Verbose ('Found: {0}' -f $DateResult)
        }
        $DayTitle = 'Previous ' + $Day + ' ' + $DayOfWeek
        Write-OutputObject -NameField $DayTitle -DateField $DateResult
    }
    elseif ($Friday13th) {
        $DayTitle = 'Friday 13th'
        if ($Next -eq $true) {
            $Year += 1
        } elseif ($Previous -eq $true) {
            $Year -= 1
        }
        foreach ($iMonth in (1..12)) {
            Write-Verbose ('Looking for Friday 13th in {0}' `
                -f $Months[$iMonth-1])
            $LastDay = (Get-Date -Day 1 -Month $iMonth `
                -Year $Year).AddMonths(1).AddDays(-1).Day
            if ((Get-Date -Day 13 -Month $iMonth -Year $Year).DayOfWeek `
                    -eq 'Friday') {
                $DateResult = (Get-Date -Day 13 -Month $iMonth `
                    -Year $Year).ToShortDateString()
                Write-OutputObject -NameField $DayTitle -DateField $DateResult
            }
        }
    }
    elseif ($PSBoundParameters.ContainsKey('Month') -or
            ($PSBoundParameters.ContainsKey('Day') -and
            $PSBoundParameters.ContainsKey('DayOfWeek') -and
            (-not $PSBoundParameters.ContainsKey('Month')) -and
            (-not $PSBoundParameters.ContainsKey('Year')))) {
        $DateResult, $LastDay = Get-Day -DayVar $DayNum -MonthVar $MonthNum
        $DayTitle = $Day + ' ' + $DayOfWeek + ' of ' `
        + $Months[$MonthNum - 1] + ' ' + $Year
        Write-OutputObject -NameField $DayTitle -DateField $DateResult
    }
    elseif ((-not $PSBoundParameters.ContainsKey('Month')) -and `
    ($PSBoundParameters.ContainsKey('Year'))) {
        Write-Verbose ('Calculating for year {0}' -f $Year)
        if ($PSBoundParameters.ContainsKey('Next')) {
            $Year += 1
        } elseif ($PSBoundParameters.ContainsKey('Previous')) {
            $Year -= 1
        }
        foreach ($iMonth in (1..12)) {
            $DateResult, $LastDay = Get-Day -DayVar $DayNum -MonthVar $iMonth
            $DayTitle = $Day + ' ' + $DayOfWeek + ' of ' `
                + $Months[$iMonth - 1] + ' ' + $Year
            Write-OutputObject -NameField $DayTitle -DateField $DateResult
        }
    }
} # end of Get-NthDayOfWeek
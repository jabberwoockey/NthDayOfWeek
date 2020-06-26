$ThisModule = $MyInvocation.MyCommand.Path -replace '\.Tests\.ps1$'
$ThisModuleName = $ThisModule | Split-Path -Leaf
Get-Module -Name $ThisModuleName -All | Remove-Module -Force -ErrorAction Ignore
Import-Module -Name "$ThisModule.psm1" -Force -ErrorAction Stop

InModuleScope $ThisModuleName {
    Describe 'Check day and day of week' {
        It "outputs without arguments" {
            (Get-NthDayOfWeek).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs year -Next" {
            (Get-NthDayOfWeek -n).Date | Should Match '[0-9]{2}\.[0-9]{2}\.' + (Get-Date).Year+1
        }
        It "outputs year -Previous" {
            (Get-NthDayOfWeek -p).Date | Should Match '[0-9]{2}\.[0-9]{2}\.' + (Get-Date).Year-1
        }
        It "outputs date of the current month (regex)" {
            (Get-NthDayOfWeek 2 4).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the current month (regex)" {
            (Get-NthDayOfWeek 3 5).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the current month (regex)" {
            (Get-NthDayOfWeek 3 5).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the current month (regex)" {
            (Get-NthDayOfWeek 4 6).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek 3 4 10).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek 2 1 7).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek -3 3 3).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek Penultimate Tuesday March).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek Fourth Saturday October).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek fo sa o).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek 4 6 10).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek -Month February).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month and year" {
            (Get-NthDayOfWeek -Day Last -DayOfWeek Tuesday -Month March -Year 1961).Date | Should Match '28.03.1961'
        }
        It "outputs date of the specific month and year" {
            (Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October -Year 1985).Date | Should Match '26.10.1985'
        }
        It "outputs date of the specific month and year" {
            (Get-NthDayOfWeek Fourth Saturday October 1985).Date | Should Match '26.10.1985'
        }
        It "outputs date of the specific month and year" {
            (Get-NthDayOfWeek fo sa o 1985).Date | Should Match '26.10.1985'
        }
        It "outputs date of the specific month and year" {
            (Get-NthDayOfWeek 4 6 10 1985).Date | Should Match '26.10.1985'
        }
        It "outputs date of the specific month and year" {
            (Get-NthDayOfWeek 5 2 6 2020).Date | Should Match '30.06.2020'
        }
        It "outputs date of the specific year" {
            (Get-NthDayOfWeek -Year 2021).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs date of the specific month" {
            (Get-NthDayOfWeek 2021).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs next date" {
            (Get-NthDayOfWeek -Next).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs next date" {
            (Get-NthDayOfWeek -Day Second -DayOfWeek Tuesday -Next).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs previous date" {
            (Get-NthDayOfWeek -Previous).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs previous date" {
            (Get-NthDayOfWeek 2 2 -prev).Date | Should Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It "outputs -Friday13th" {
            (Get-NthDayOfWeek -Friday13th).Date | Should Match '13\.[0-9]{2}\.' + (Get-Date).Year
        }
        It "outputs next -Friday13th" {
            (Get-NthDayOfWeek -Friday13th -Next).Date | Should Match '13\.[0-9]{2}\.' + (Get-Date).Year+1
        }
        It "outputs previous -Friday13th" {
            (Get-NthDayOfWeek -Friday13th -Previous).Date | Should Match '13\.[0-9]{2}\.' + (Get-Date).Year-1
        }
        It "outputs No such a day" {
            (Get-NthDayOfWeek 5 3 4 1999).Date | Should Match 'No such a day'
        }
        It "outputs No such a day" {
            (Get-NthDayOfWeek -5 2 2 1961).Date | Should Match 'No such a day'
        }
        It "outputs No such a day" {
            (Get-NthDayOfWeek 5 3 6 2020).Date | Should Match 'No such a day'
        }
        It "outputs an error - Wrong or ambiguous value for the day" {
            {Get-NthDayOfWeek 0} | Should Throw 'Wrong or ambiguous value for the day.'
        }
        It "outputs an error - Wrong or ambiguous value for year" {
            {Get-NthDayOfWeek 9999} | Should Throw 'Wrong or ambiguous value for year.'
        }
        It "outputs an error - Not enough arguments" {
            {Get-NthDayOfWeek 4} | Should Throw 'Not enough arguments.'
        }
        It "outputs an error - Wrong or ambiguous value for the day" {
            {Get-NthDayOfWeek 45 6} | Should Throw 'Wrong or ambiguous value for the day.'
        }
        It "outputs an error - Wrong or ambiguous value for the day of the week" {
            {Get-NthDayOfWeek 4 56} | Should Throw 'Wrong or ambiguous value for the day of the week.'
        }
        It "outputs an error - Wrong or ambiguous value for month or year." {
            {Get-NthDayOfWeek 1 3 20122} | Should Throw 'Wrong or ambiguous value for month or year.'
        }
    }
}
BeforeAll {
    Get-Module -Name NthDayOfWeek -All | Remove-Module -Force -ErrorAction Ignore
    Import-Module '.\NthDayOfWeek.psm1' -Force -ErrorAction Stop
}

Describe 'Check day and day of week' {
    It 'outputs without arguments' {
        (Get-NthDayOfWeek).Date | Should -Match $('[0-9]{2}\.[0-9]{2}\.' + ((Get-Date).Year))
    }
    Context 'Year tests' {
        It 'outputs date of the specific year' {
            (Get-NthDayOfWeek -Year 2021).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.2021'
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek 2021).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.2021'
        }
        It 'outputs year -Next' {
        (Get-NthDayOfWeek -n).Date | Should -Match $('[0-9]{2}\.[0-9]{2}\.' + ((Get-Date).Year + 1))
        }
        It 'outputs year -Previous' {
            (Get-NthDayOfWeek -p).Date | Should -Match $('[0-9]{2}\.[0-9]{2}\.' + ((Get-Date).Year - 1))
        }
        It 'outputs date and year' {
            (Get-NthDayOfWeek 3 7 1978).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.1978'
        }
        It 'outputs date and year' {
            (Get-NthDayOfWeek -4 3 1789).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.1789'
        }
    }
    Context 'Day tests' {
        It 'outputs date of the current month (regex)' {
            (Get-NthDayOfWeek 2 4).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs date of the current month (regex)' {
            (Get-NthDayOfWeek 3 5).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs date of the current month (regex)' {
            (Get-NthDayOfWeek 1 7).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs date of the current month (regex)' {
            (Get-NthDayOfWeek 4 6).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs date of the current month (regex)' {
            (Get-NthDayOfWeek 1 3).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs date of the current month (regex)' {
            (Get-NthDayOfWeek 2 1).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs date of the current month (regex)' {
            (Get-NthDayOfWeek 3 2).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
    }
    Context 'Month tests' {
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek 4 6 1).Date | Should -Match $('[0-9]{2}\.01\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek -2 4 2).Date | Should -Match $('[0-9]{2}\.02\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek -3 3 3).Date | Should -Match $('[0-9]{2}\.03\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek 3 2 4).Date | Should -Match $('[0-9]{2}\.04\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek 4 5 5).Date | Should -Match $('[0-9]{2}\.05\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek 1 6 6).Date | Should -Match $('[0-9]{2}\.06\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek 2 1 7).Date | Should -Match $('[0-9]{2}\.07\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek -1 7 8).Date | Should -Match $('[0-9]{2}\.08\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek -2 0 9).Date | Should -Match $('[0-9]{2}\.09\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek -3 1 10).Date | Should -Match $('[0-9]{2}\.10\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek -4 4 11).Date | Should -Match $('[0-9]{2}\.11\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek 3 6 12).Date | Should -Match $('[0-9]{2}\.12\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek Penultimate Tuesday March).Date | Should -Match $('[0-9]{2}\.03\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October).Date | Should -Match $('[0-9]{2}\.10\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek Fourth Saturday October).Date | Should -Match $('[0-9]{2}\.10\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek fo sa may).Date | Should -Match $('[0-9]{2}\.05\.' + ((Get-Date).Year))
        }
        It 'outputs date of the specific month' {
            (Get-NthDayOfWeek -Month February).Date | Should -Match $('[0-9]{2}\.02\.' + ((Get-Date).Year))
        }
    }
    Context 'Next date tests' {
        It 'outputs next date' {
            (Get-NthDayOfWeek -Next).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs next date' {
            (Get-NthDayOfWeek -Day Second -DayOfWeek Tuesday -Next).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs next date' {
            (Get-NthDayOfWeek 5 4 -n).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
    }
    Context 'Previous date tests' {
        It 'outputs previous date' {
            (Get-NthDayOfWeek -Previous).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs previous date' {
            (Get-NthDayOfWeek 2 2 -prev).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs previous date' {
            (Get-NthDayOfWeek -4 5 -p).Date | Should -Match '[0-9]{2}\.[0-9]{2}\.[0-9]{4}'
        }
    }
    Context 'Full date tests' {
        It 'outputs date of the specific month and year' {
            (Get-NthDayOfWeek -Day Last -DayOfWeek Tuesday -Month March -Year 1961).Date | Should -Match '28.03.1961'
        }
        It 'outputs date of the specific month and year' {
            (Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October -Year 1985).Date | Should -Match '26.10.1985'
        }
        It 'outputs date of the specific month and year' {
            (Get-NthDayOfWeek Fourth Saturday September 1985).Date | Should -Match '28.09.1985'
        }
        It 'outputs date of the specific month and year' {
            (Get-NthDayOfWeek fo sa d 1985).Date | Should -Match '28.12.1985'
        }
        It 'outputs date of the specific month and year' {
            (Get-NthDayOfWeek 1 6 11 1985).Date | Should -Match '02.11.1985'
        }
        It 'outputs date of the specific month and year' {
            (Get-NthDayOfWeek 5 2 6 2020).Date | Should -Match '30.06.2020'
        }
        It 'outputs date and year' {
            (Get-NthDayOfWeek -2 3 8 2125).Date | Should -Match '22.08.2125'
        }    
        It 'outputs object properties' {
            (Get-NthDayOfWeek 2 6 8 1941).DaysAfterDate | Should -Match '^[0-9]+'
        }
        It 'outputs object properties' {
            (Get-NthDayOfWeek 1 4 5 1945).DaysAfterDate | Should -Match ''
        }
        It 'outputs object properties' {
            (Get-NthDayOfWeek -2 5 9 2100).DaysUntilDate | Should -Match '^[0-9]+'
        }
        It 'outputs object properties' {
            (Get-NthDayOfWeek -4 1 1 2200).DaysUntilDate | Should -Match ''
        }
        It 'outputs object properties' {
            (Get-NthDayOfWeek 3 5 2 2020).DaysInMonth | Should -Match '29'
        }
        It 'outputs object properties' {
            (Get-NthDayOfWeek 1 0 6).DaysInMonth | Should -Match '30'
        }
        It 'outputs object properties' {
            (Get-NthDayOfWeek -1 7 9 2018).DaysUntilEndOfMonth | Should -Match '0'
        }
        It 'outputs object properties' {
            (Get-NthDayOfWeek 1 6 10 2005).DaysUntilEndOfMonth | Should -Match '30'
        }
    }
    Context 'Friday 13th tests' {
        It 'outputs -Friday13th' {
            (Get-NthDayOfWeek -Friday13th).Date | Should -Match '13\.[0-9]{2}\.[0-9]{4}'
        }
        It 'outputs next -Friday13th' {
            (Get-NthDayOfWeek -Friday13th -Next).Date | Should -Match $('[0-9]{2}\.[0-9]{2}\.' + ((Get-Date).Year + 1))
        }
        It 'outputs previous -Friday13th' {
            (Get-NthDayOfWeek -Friday13th -Previous).Date | Should -Match $('[0-9]{2}\.[0-9]{2}\.' + ((Get-Date).Year - 1))
        }
    }
    Context 'No such a day' {
        It 'outputs No such a day' {
            (Get-NthDayOfWeek 5 3 4 1999).Date | Should -Match 'No such a day'
        }
        It 'outputs No such a day' {
            (Get-NthDayOfWeek -5 2 2 1961).Date | Should -Match 'No such a day'
        }
        It 'outputs No such a day' {
            (Get-NthDayOfWeek 5 3 6 2020).Date | Should -Match 'No such a day'
        }
    }
    Context 'Error tests' {
        It 'outputs an error - Wrong or ambiguous value for the day' {
            {Get-NthDayOfWeek 0} | Should -Throw 'Wrong or ambiguous value for the day.'
        }
        It 'outputs an error - Wrong or ambiguous value for the day' {
            {Get-NthDayOfWeek 20000} | Should -Throw 'Wrong or ambiguous value for the day.'
        }
        It 'outputs an error - Wrong or ambiguous value for year' {
            {Get-NthDayOfWeek 9999} | Should -Throw 'Wrong or ambiguous value for year.'
        }
        It 'outputs an error - Not enough arguments' {
            {Get-NthDayOfWeek 4} | Should -Throw 'Not enough arguments.'
        }
        It 'outputs an error - Not enough arguments' {
            {Get-NthDayOfWeek -5} | Should -Throw 'Not enough arguments.'
        }
        It 'outputs an error - Wrong or ambiguous value for the day' {
            {Get-NthDayOfWeek 45 6} | Should -Throw 'Wrong or ambiguous value for the day.'
        }
        It 'outputs an error - Wrong or ambiguous value for the day of the week' {
            {Get-NthDayOfWeek 4 56} | Should -Throw 'Wrong or ambiguous value for the day of the week.'
        }
        It 'outputs an error - Wrong or ambiguous value for month or year.' {
            {Get-NthDayOfWeek 1 3 20122} | Should -Throw 'Wrong or ambiguous value for month or year.'
        }
    }
}
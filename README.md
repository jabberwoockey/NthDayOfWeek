# NthDayOfWeek

The Powershell function Get-NthDayOfWeek calculates the Nth day
of the week in a specific month.

By default, without parameters, the function returns second tuesdays
(Patch Tuesdays) of the current year. It returns a specific day of the week
(first, second, third, fourth, or even fifth) for any month you like,
or a list of days of the week for any year.

To install clone or download repository, copy the directory into your user
module folder (`$HOME\Documents\WindowsPowerShell\Modules\`), and then import
the module.

- `Import-Module NthDayOfWeek`

---

### How to use

Run the following command in the shell to get help:

- `help gndw -s`

To get second tuesdays (Patch Tuesdays) of the current year run the function
without parameters:

- `Get-NthDayOfWeek`

Or with the switch `-Next` for the tuesdays of the next year:

- `gndw -Next` 

To get second tuesdays (Patch Tuesdays) of a specific month of the current year
or a specific year run any one of the following commands:

- `Get-NthDayOfWeek -Month February`

- `Get-NthDayOfWeek -Year 2021`

- `gndw 2021`

To get the fourth Saturday of October run any one of the following commands
(returns a day of the week for the current month if a month is not defined):

- `Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October`

- `Get-NthDayOfWeek Fourth Saturday October`

- `Get-NthDayOfWeek fo sa o`

- `gndw 4 6 10`

To get the fourth Saturday of October 1985 run any one of the following
commands:

- `Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Month October -Year 1985`

- `Get-NthDayOfWeek Fourth Saturday October 1985`

- `Get-NthDayOfWeek fo sa o 1985`

- `gndw 4 6 10 1985`

To get a list of fourth Saturdays in 1985 run run any one of the following
commands:

- `Get-NthDayOfWeek -Day Fourth -DayOfWeek Saturday -Year 1985`

- `Get-NthDayOfWeek Fourth Saturday 1985`

- `Get-NthDayOfWeek fo sa 1985`

- `gndw 4 6 1985`

To get the last (penultimate and so on) specific day of week use the `Last`
argument for -Day or a negative number `-1`, `-2`, etc:

- `Get-NthDayOfWeek -Day Last -DayOfWeek Tuesday -Month March -Year 1961`

- `Get-NthDayOfWeek Penultimate Tuesday March`

- `gndw -3 3 3`

To get the next closest specific day of week in the current or next month
starting from tomorrow, use `-Next` switch:

- `Get-NthDayOfWeek -Day Second -DayOfWeek Tuesday -Next`

- `gndw 2 2 -next`

To get all properties of the output object run `Get-NthDayOfWeek | Format-List *`

Do not forget to use Tab to autocomplete arguments: `get-nth` > 'Tab' >
'Space' > 'Tab','Tab' > 'Space' > 'Tab','Tab' > 'Space' > 'Tab','Tab','Tab'

---
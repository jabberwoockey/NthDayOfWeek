# NthDayOfWeek

The Powershell function Get-NthDayOfWeek calculates the Nth day
of the week in a specific month.

By default, without parameters, the function returns second tuesdays
(Patch Tuesdays) of the current year. It returns a specific day of the week
(first, second, third, fourth, or even fifth) for any month you like,
or a list of days of the week for any year.

To install clone or download repository and import the module.

- `Import-Module NthDayOfWeek`

---

### Usage

To get second tuesdays (Patch Tuesdays) of the current year run the function
without parameters:

- `Get-NthDayOfWeek`

To get second tuesdays (Patch Tuesdays) of a specific month of the current year
or a specific year run the following commands:

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

Do not forget to use Tab: `get-nth` > 'Tab' > 'Space' > 'Tab','Tab' > 'Space' >
'Tab','Tab' > 'Space' > 'Tab','Tab','Tab'

---
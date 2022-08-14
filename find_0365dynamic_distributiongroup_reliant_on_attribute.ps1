$usercredential = get-credential

$field = "Department"

Connect-ExchangeOnline -Credential $usercredential

Get-DynamicDistributionGroup| where recipientfilter -match $field|select name

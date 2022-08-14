#Edit mailboxes in various ways within O365
#

$usercredential = get-credential
Connect-MsolService -Credential $usercredential

#Adjust regional configuration for a mailbox (Ie language, date/time format, timezone etc)
Get-Mailbox -RecipientTypeDetails UserMailbox -Identity  | Set-MailboxRegionalConfiguration -Language en-GB -DateFormat 'dd/MM/yyyy' -TimeFormat 'h:mm:tt' -TimeZone 'GMT'

#check regional configuration for a mailbox (Ie language, date/time format, timezone etc)
Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited | get-MailboxRegionalConfiguration 

#Give access to a mailbox to an individual.
Add-MailboxPermission -Identity '' -AccessRights FullAccess -InheritanceType All -AutoMapping:$true -User ''

#Give the user send as permissions for a given account.
Add-RecipientPermission -Identity '' -AccessRights SendAs -Confirm:$false -Trustee ''
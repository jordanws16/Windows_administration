# Specify the policy, Source, and target domains and the policy will be copied over. Targetname can be changed also to reflect a different new name for the policy.
# Created by: Jordan Smith

$Policy=""
$SourceDomain=""
$TargetDomain=""

get-GPO -Name $Policy -Domain $SourceDomain | copy-gpo -TargetName $Policy -TargetDomain $TargetDomain -SourceDomain $SourceDomain
#Add at the end

readonly ORIG_USER=$(who -mu | awk '{print $1}') 

function CheckCommands {
local AUDIT_CMD="$(history 1 | awk '{ORS=""} {for(i=2;i<=NF;i++) {print $i" "} {print "n"}}')"
if [ "$AUDIT_CMD" != "" ]; then 
echo $AUDIT_CMD | logger -p authpriv.alert -t "- CheckCommands > RealUser: $ORIG_USER - User: $USER[$$] - SSHSource: $SSH_CLIENT - Path: $PWD - Command";
fi
}

trap CheckCommands DEBUG;

# Namn   :      checkServerStatus.sh
# Purpose:      Script for printing sas server status.
# Created:      2016-04-21  Mattias Moliis
# Changes:      
#
# Print sasserver status to temporary file.
/opt/sas/config/Lev1/sas.servers status > /tmp/SASServerStatus.txt

#!/bin/ksh -p
#
# pgbackup_audit_archive.sh
#
# Tar backup av Postgres tabeller SAS_AUDIT_ENTRY_ARCHIVE och SAS_AUDIT_ARCHIVE.
# Rensar samma tabeller om backup gått igenom.
#
# Initierar Postgres
POSTGRES_HOME=/opt/sas/sashome/SASWebInfrastructurePlatformDataServer/9.4
export PATH=$POSTGRES_HOME/bin:$PATH
export LD_LIBRARY_PATH=$POSTGRES_HOME/lib:$LD_LIBRARY_PATH

# Loggfil
dt=`date +%Y%m%d`
LOG_FILE=/tmp/postgresbackup_audit_archive_$dt.log

# Startar postgres backup. Byt plats för backup till mountad disk. 
pg_dump -h localhost -p 9432 -U SharedServices -w -a --inserts -t public.sas_audit_archive -t public.sas_audit_entry_archive > /mnt/audit/prod/sharedservices_audit_archive$dt.tar 2> $LOG_FILE


if [ $? -eq 0 ]         # Om backupen har gått bra, starta rensning av postgres tabeller.
then
  psql -h localhost -p 9432 -U SharedServices -w -c "truncate public.sas_audit_archive cascade;"
  psql -h localhost -p 9432 -U SharedServices -w -c "truncate public.sas_audit_entry_archive;"
  sendmail fredrik.hansson@regionuppsala.se  < /root/pgmailsuccess_audit_archive.txt
else  			# Om backupen har gått illa, mejla.Här borde $MAINTANERS ersätta epostadress
  sendmail fredrik.hansson@regionuppsala.se  < /root/pgmailerror_audit_archive.txt
fi

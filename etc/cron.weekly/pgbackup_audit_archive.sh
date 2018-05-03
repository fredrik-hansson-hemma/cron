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
hostname=`hostname`
backup_folder=/mnt/audit/${hostname}
# Parents-flaggan nedan finns endast för att slippa error om katalogen redan finns.
[ -d $backup_folder ] || mkdir $backup_folder
backup_name=$backup_folder/sharedservices_audit_archive_${hostname}_$dt.tar


touch $backup_name

if [ $? -ne 0 ]         # Om det inte går att skriva till backupfilen
then
	touch_error="Problemet är att det inte går att skriva till filen $backup_name. Antagligen är det den monterade disken som har hoppat bort igen. Kontakta MSI och be dem montera den på nytt."
else
	touch_error=" "
fi




# Startar postgres backup.
# För att det här ska fungera behöver användarens lösenord finnas i filen ~/.pgpass
pg_dump --host=localhost --port=9432 --username=SharedServices --no-password --data-only --inserts --table=public.sas_audit_archive --table=public.sas_audit_entry_archive > $backup_name 2> $LOG_FILE


if [ $? -eq 0 ]         # Om backupen har gått bra, starta rensning av postgres tabeller.
then
  psql --host=localhost --port=9432 --username=SharedServices --no-password -c "truncate public.sas_audit_archive cascade;"
  psql --host=localhost --port=9432 --username=SharedServices --no-password -c "truncate public.sas_audit_entry_archive;"
  
  echo "Subject: Complete - Postgresql audit_archive backup (${hostname})" > /tmp/pgmail_audit_archive.txt
  echo "" >> /tmp/pgmail_audit_archive.txt
  echo "Backup finns under $backup_name" >> /tmp/pgmail_audit_archive.txt
  
else  			# Om backupen har gått illa, mejla.Här borde $MAINTANERS ersätta epostadress

  echo "Subject: Error - Postgresql audit_archive backup (${hostname})" > /tmp/pgmail_audit_archive.txt
  echo "" >> /tmp/pgmail_audit_archive.txt
  echo "Se felmeddelanden i $LOG_FILE" >> /tmp/pgmail_audit_archive.txt
  echo "" >> /tmp/pgmail_audit_archive.txt
  echo "=============================================" >> /tmp/pgmail_audit_archive.txt
  echo "" >> /tmp/pgmail_audit_archive.txt
  echo $LOG_FILE >> /tmp/pgmail_audit_archive.txt
  echo "$touch_error" >> /tmp/pgmail_audit_archive.txt
  
fi

sendmail fredrik.hansson@regionuppsala.se  < /tmp/pgmail_audit_archive.txt

# Städning
rm /tmp/pgmail_audit_archive.txt
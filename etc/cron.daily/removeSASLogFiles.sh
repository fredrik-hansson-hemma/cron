# Namn   :      removeSASLogFiles.sh
# Purpose:      Script for cleaning SAS log directories.
# Created:      2014-05-08  Mattias Moliis
# Changes:      2017-01-30  Björn - lagt till cleanwork-körning.
#
# Delete logfiles older than 60 days
# Script is running every weekday in crontab as Root.

# Flytta WebAppServerloggar till separat katalog. Rensar den katalogen regelbundet.
find /opt/sas/config/Lev1/Web/WebAppServer/SASServer1_1/logs/localhost_access_log*.txt -mtime +7 -exec mv '{}' /SASLOG/WebAppServer/SASServer1_1/logs/ \;
find /SASLOG/WebAppServer/SASServer1_1/logs/* -mtime +60 -exec rm '{}' \;

find /opt/sas/config/Lev1/Web/WebServer/logs/access_*.log -mtime +60 -exec rm '{}' \;
find /opt/sas/config/Lev1/Web/Logs/SASServer1_1/*.log.2* -mtime +60 -exec rm '{}' \;
find /opt/sas/config/Lev1/SASApp_VA/PooledWorkspaceServer/Logs/*.log -mtime +60 -exec rm '{}' \;
find /opt/sas/config/Lev1/SASApp_VA/StoredProcessServer/Logs/*.log -mtime +60 -exec rm '{}' \;
find /opt/sas/config/Lev1/SASApp_VA/BatchServer/Logs/*.log -mtime +60 -exec rm '{}' \;
find /opt/sas/config/Lev1/ObjectSpawner/Logs/*.log -mtime +60 -exec rm '{}' \;
find /opt/sas/config/Lev1/WebInfrastructurePlatformDataServer/Logs/*.log -mtime +60 -exec rm '{}' \;
find /opt/sas/config/Lev1/SchedulingServer/Logs/*.log -mtime +60 -exec rm '{}' \;
find /opt/sas/config/Lev1/Applications/SASInformationRetrievalStudioforSAS/logs/pipeline-server_*.flatsite -mtime +60 -exec rm '{}' \;
find /opt/sas/config/Lev1/Web/activemq/data/kahadb/*.log -mtime +30 -exec rm '{}' \;

# Flytta metadataserverloggar till separat katalog. Rensar den katalogen regelbundet.
find /opt/sas/config/Lev1/SASMeta/MetadataServer/Logs/SASMeta_MetadataServer_*.log -mtime +7 -exec mv '{}' /SASLOG/MetadataServer/Logs/ \;
find /SASLOG/MetadataServer/Logs/SASMeta_MetadataServer_*.log -mtime +90 -exec rm '{}' \;

# Delete Workspaceserver logfiles and dummy Workfolders older than 60 days
find /opt/sas/config/Lev1/SASApp_VA/WorkspaceServer/Logs/*.log -mtime +60 -exec rm '{}' \;
find /saswork/SAS_work* -mtime +60 -exec rm -r '{}' \;

# Delete VA usage logfiles older than 7 days
# Bortkommenterad eftersom den här katalogen inte finns i nuvarande miljö
# find /opt/sas/config/Lev1/Web/Logs/SASServer1_1/VAusage_logs/*.log.* -mtime +7 -exec rm '{}' \;


# Delete VA maintenance logfiles older than 30 days
# Bortkommenterad eftersom den här katalogen inte finns i nuvarande miljö
# find /opt/sas/config/Lev1/Web/Logs/SASServer1_1/VAmaintenance_logs/*.log.* -mtime +30 -exec rm '{}' \;

# Delete backupfiles older than 14 days
find /opt/sas/backup/*.spk -mtime +14 -exec rm '{}' \;
# Use cleanwork-command to remove junkfiles from SASWORK
/opt/sas/sashome/SASFoundation/9.4/utilities/bin/cleanwork /saswork

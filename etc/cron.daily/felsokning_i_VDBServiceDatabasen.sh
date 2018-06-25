
# Det här skriptet används enbart för felsökning. Se SAS-supportärende "7612417778 - LASR-table and Hadoop-table switch places in the output tab in DataBuilder"



# Sätter några miljövariabler
SASHOME=/opt/sas/sashome
POSTGRES_HOME=${SASHOME}/SASWebInfrastructurePlatformDataServer/9.4
export PATH=${POSTGRES_HOME}/bin:$PATH 
export LD_LIBRARY_PATH=${POSTGRES_HOME}/lib:$LD_LIBRARY_PATH   

# Change to the SASHOME/SASWebInfrastructurePlatformDataServer/9.4/bin folder or directory.
cd ${POSTGRES_HOME}/bin



# Submit the following command in SASHOME/SASWebInfrastructurePlatformDataServer/9.4/bin to obtain a complete VDBService database dump file. 
pg_dump -f /mnt/audit/$(hostname)/vdbs_`date +"%Y%m%d"`.backup -h $(hostname) -p 9432 -U vdbadm --no-password VDBService > /tmp/vdbs_backup_`date +"%Y%m%d"`.log
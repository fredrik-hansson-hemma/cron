# Namn   :      checkServerStatus.sh
# Purpose:      Script for printing sas server status.
# Created:      2016-04-21  Mattias Moliis
# Changes:      2018-01-16: Lägger till kontroll av Web-delar.
#
# Print sasserver status to temporary file.

# Kollar status enbart på huvudnoden
# /opt/sas/config/Lev1/sas.servers status > /tmp/SASServerStatus.txt

# Kollar status på huvudnoden och workernoderna
echo "Filen skapades:" > /tmp/SASServerStatus.txt
date >> /tmp/SASServerStatus.txt
echo " " >> /tmp/SASServerStatus.txt
echo "Huvudnoden======================" >> /tmp/SASServerStatus.txt
runuser --login sas --command='/opt/sas/config/Lev1/status_nodes.sh' >> /tmp/SASServerStatus.txt
echo " " >> /tmp/SASServerStatus.txt
echo "Office Analytics-servern======================" >> /tmp/SASServerStatus.txt
runuser --login sas --command='ssh bs-ap-19 "/opt/sas/config/Lev1/sas.servers status;"' >> /tmp/SASServerStatus.txt

# Inga mellanslag mellan mailadresserna!
mailadress=fredrik.hansson@regionuppsala.se,bjorn.rengerstam@akademiska.se,magnus.knopf@akademiska.se
from=Skriptet_checkServerStatus.sh



# Genomsöker filen /tmp/SASServerStatus.txt först efter rader som INTE innehålle webserverns status (den visar alltid att den är nere)
# Sen skickas svaret vidare till en ny genom sökning som letar texten 'is NOT UP'. Om kommandot lyckas hitta sådana rader (returkoden blir 0)
# har vi problem. Då skickas ett mail.
SERVERS_DOWN=$(grep --invert-match 'SAS Web Server is NOT up' /tmp/SASServerStatus.txt | grep 'is NOT UP')
if [ $? -eq "0" ]
then
	echo $?

	subject="VARNING: En server svarar inte"
	mail="subject:$subject\nfrom:$from\n\n$SERVERS_DOWN"
	echo -e "$mail" | sendmail $mailadress 
	
fi



# Förväntad returkod är 0. Det ska går att ladda ner https://rapport.lul.se/index.html
wget --quiet --delete-after https://rapport.lul.se/
if [ $? -ne "0" ]
then
	echo $?
	# Observera att man inte kan tabba in texten nedan. Då slutar det fungera.
	sendmail "$mailadress" <<EOF
subject: Oväntat svar från https://rapport.lul.se/
from:$from

Oväntat svar från https://rapport.lul.se/. Är VA uppe?
EOF

fi


# Förväntad returkod är 6. Det ska bli "Unauthorized"
wget --quiet --delete-after https://rapport.lul.se/SASVisualAnalyticsHub
if [ $? -ne "6" ]
then
	echo $?

	# Observera att man inte kan tabba in texten nedan. Då slutar det fungera.
	sendmail "$mailadress" <<EOF
subject: Oväntat svar från https://rapport.lul.se/SASVisualAnalyticsHub
from:$from

Oväntat svar från https://rapport.lul.se/SASVisualAnalyticsHub. Är VA uppe?
EOF

fi
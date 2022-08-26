user=$1
remoteServer=$2

function iam ()
{
	echo "Let's begin. Establishing user.."
	whoami
	hostname -I
	echo "Start Nipe to go anonymous!" 
}

# Step 2. start nipe

function startnipe ()
{
	echo "Starting nipe.. Hang on.."
	cd /home/hairkal/nipe
	sudo perl nipe.pl start
	active=$(sudo perl nipe.pl status | grep activated | awk '{print $3}')
	echo "Nipe is $active" 
}

# Step 3 & 4. User wants to ensure that user is Anonymous. Echo location 

function anonchecker ()
{
	echo "Checking if you are Anonymous.."
	cd /home/hairkal/nipe
	anon=$(sudo perl nipe.pl status | grep Ip | awk '{print $3}')
	echo "You are now $anon" 
	location=$(geoiplookup $anon | awk -F: '{print $2}')
	echo "located in: $location"
	stat_check=$(sudo perl nipe.pl status | grep -w activated)
	
	
if [ ! -z "$stat_check" ]
	then 
		echo "You are Anonymous.. Let's go!!" 
	else
		echo "You are Expose!! Restart before you proceed.. " 	
fi
}

# Step 5 & 6. Run nmap/whois. echo the answer 

function options ()  
{
	read -p "Would you like to A) NMAP? or B) WHOIS? : " choose
case $choose in
        A)
			echo "IP address for NMAP: "
			read IP
			echo "$IP"

            

			for target in "${remteServer[@]}"
			do
			ssh -T ${user}@${target}<<-END
			echo "You are in as.. "
	        whoami
			nmap "$IP" -oN nmapscan.txt
	
			END
			done 	
			
options
        ;;

        B)
			echo "IP address for WHOIS: "
            read IP
			echo "$IP"
                
            # user="root"
			# server="fmvpay7ghi4gly3333gdwn4ebkb3pt6toxhspplmftyuakufhm2zyafhld.onion"
			
			for target in "${remoteServer[@]}"
			do
			ssh -T ${user}@${target}<<-END
			echo "You are in as.. "
	        whoami
			whois "$IP" > whoisresult.txt 
            whois "$IP" | grep OrgName
            echo "$wresult"  
	
			END
			done
			
options
        ;;

        C)
                exit
        esac
}

iam
startnipe
anonchecker
options
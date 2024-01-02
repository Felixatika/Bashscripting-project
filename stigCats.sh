#!/bin/bash

##############################################################################################################################
# Auuthor: Felix Atika
#Instructor: Prof, Ivan Hovermale
#Course: Linux and Bash Scripting
#Date: December 28 2023
#
#
#About: In this script I go through the stigs documentation using the STIG viewer, check for the documented issues and fix
#if there is anything to be fixed. I levereged knowledge gained in class, linux testout course, chatgpt, google and youtube
#linux scripting course.
#############################################################################################################################





echo "Checking CAT I severity ************"
#Severity CAT I
#Group ID: V-238326
#Rule Title:The Ubuntu operating system must not have the telnet package installed.

#This line is referred to as the shebang, it tells to use bash as the interpreter

# Check if script is run as root
#This is a test condition. It checks if the Effective User ID is not equal to 0. In unix-like system a user with an ID of 0 is the root user.
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root"
    exit
fi

# Check and fix CAT I STIG recommendations
	echo "The system must not have the telnet package installed. Lets verify if found we fix the finding"
#Ubuntu operating system must not have the telnet package installed.
#This package does not encrypt passwords. Passwords should be encrypted at all times(protected from reading). Plainly read passwords can be read and easily compromised.
stig_id="V-238326"
description="Description 1"
#Verify that the telnet package is not installed on the ubuntu operating system by running the following command
check_command="dpkg -l | grep 'telnetd'"
#Remove the telnet package (telnetd) from the ubuntu Operating system the runing this command
fix_command="apt-get remove telnetd"
#echo -n is an option for the echo command, it means no newline. It prevents the addition of a newline character at the end of the output.
echo -n  "Checking CAT I STIG $stig_id - $description... "
eval "$check_command"
#This if statement is used as a test, we use exit codes to help us determine if our command ran successifully. exit code of 0 shows that it ran successifully if its not equal to zero then the
#problem should be fixed
if [ $? -eq 0 ]; then
    echo "Not compliant - Attempting to fix..."
    eval "$fix_command"
    if [ $? -eq 0 ]; then
        echo "Fixed"
    else
        echo "Fix failed"
    fi
else
    echo "Compliant"
fi
sleep 0.5
echo "Second CAT I *******************************************"
echo "*******************************************************************"
#Group ID: V-238327
#Rule Title: The Ubuntu operating system must not have the rsh-server package installed

echo "The Ubuntu Operating system must not have the rsh-server package installed."
stig_id="V-238327"
description="Description 2"
check_command="dpkg -l | grep rsh-server"
fix_command="apt-get remove rsh-server"
echo -n "Checking CAT I STIG $stig_id - $description... "
eval "$check_command"
if [ $? -eq 0 ]; then
    echo "Not compliant - Attempting to fix..."
    eval "$fix_command"
    if [ $? -eq 0 ]; then
        echo "Fixed"
    else
        echo "Fix failed"
    fi
else
    echo "Compliant"
fi
sleep 0.5
echo "Beginning CAT II ........................................."
echo "Checking If UFW is enabled, if not enable it.............."
echo "CAT II........................"
echo ".........................................................."

#Severity: CAT II
#Group ID: V-238374
#Rule Title:The Ubuntu operating system must have an application firewall enabled.



# Check if UFW is enabled
if systemctl status ufw.service | grep -q -i "active: active"; then
  echo "UFW is already enabled. No action needed."
else
  echo "Enabling UFW..."

  # Enable UFW
  sudo systemctl enable ufw.service

  # Start UFW
  sudo systemctl start ufw.service

  echo "UFW has been enabled and started."
fi



echo "Second CAT II....................................................................."
echo "Checking if Kdumps are disabled, if not disable them..............................."
echo "....................................................................................."

#Severity CAT II
#Group ID V-238334
#Rule Title: The Ubuntu operating system must disable kernel core dumps  so that it can fail to a secure
#state if system initialization fails, shutdown fails or aborts fail



# Check if kdump service is active
if [ "$(systemctl is-active kdump.service)" == "inactive" ]; then
  echo "The kdump service is already inactive. No action needed."
else
  echo "Checking if the use of the kdump service is required and documented..."

  # Check if the use of kdump service is documented
  if [ -f "/etc/kdump.conf" ]; then
    echo "The use of the kdump service is documented. No action needed."
  else
    echo "Disabling the kdump service..."

    # Disable the kdump service
    sudo systemctl disable kdump.service

    echo "The kdump service has been disabled."
  fi
fi


echo "3rd CAT II ........................................................................."
echo "Check if UFW is installed, if not install it............................................."
echo "..........................................................................................."

#Severity: CAT II
#Group ID V-238354
#Rule Title:The Ubuntu operating system must have an application firewall installed in order to control remote access methods.



# Check if UFW is installed
if dpkg -l | grep -q "ufw"; then
  echo "UFW is already installed. No action needed."
else
  echo "Installing UFW..."

  # Install UFW if not already installed
  sudo apt-get install -y ufw

  echo "UFW has been installed."
fi





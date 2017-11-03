#!/bin/bash
# This CLImenu is a skeleton script for playing with 
# various simple command line and menu interaction designs.
# Look at function 'about' for some details.

# The actual main loop for getting user input is 
# after the functions at the end of the script.

version="0.2a"

# Modify/edit your own text-based main menu here
function text_menu {
   text_menu="
   \n\t  My Menu
   \n\n
   \t    1)\t Dialog1 (First name)   \n
   \t    2)\t Dialog2 (Last name)   \n
   \t    3)\t Output (Full name)  \n
   \t    m)\t Select-style Whiptail menu   \n
   \t    many)\t Use multiple words in the command   \n
   \t    view)\t View this script in a text window \n
   \t    edit)\t Edit this script with nano \n
   \t    cls)\t Clear the screen \n
   \t    gui)\t A GUI example (NOTE! requires X windowing)  \n
   \t    quit)\t Stop the script \n
   "
   
   echo -e $text_menu
}


# This function gets input using Whiptail UI
function whiptail_input {

   COLOR=$(
   whiptail --inputbox "What is your favorite Color?" 8 50 \
   Blue --title "Example Dialog" 3>&1 1>&2 2>&3
   )

   whiptail --title "Color" --msgbox "You said\nyour favorite color\nis $COLOR.\nCool." 10 25
}


# This function implements a menu with whiptail
function whiptail_menu {

   CHOICE=$(
   whiptail --title " Menu " --menu "Make your choice" 16 50 9 \
	"1" "This is a more interactive menu"   \
	"2" "Implemented with Whiptail"  \
	"3" "However" \
	"4" "These items do not take you anywhere"  \
	"5" "Except this to whiptail_input"  \
	"9" "End script."  3>&2 2>&1 1>&3
   )

   whiptail --title "Selected Item" --msgbox "You selected\n$CHOICE\nfrom the menu." 10 20

   if [[ $CHOICE == "5" ]]; then
      whiptail_input
   fi
}


# This requires that you have X server running and X11 forwarding on
# in your own computer. The script uses gdialog for the GUI windows.
function gui_menu {

   message="This function requires a running X server "
   message=$message"and X11 forwarding ON in your computer. Do you have these? "
   message=$message"(Absense of X results in error!) "

   # Initiate function in text mode, return if no X window server
   if !(whiptail --title "X Windows Dialog" --yesno "$message" 8 60) then
      return
   fi
   
   echo "Starting X. Please look around for the GUI windows!"

   gdialog --title "X window" --msgbox "Welcome to the GUI world!" 100 100

   CHOICE=$(
   gdialog --title " Menu " --menu "Make your choice" 16 50 9 \
	"1" "This is a more interactive GUI menu"   \
	"2" "Implemented with gdialog"  \
	"3" "However" \
	"4" "These items do not take you anywhere"  \
	"9" "End script."  3>&2 2>&1 1>&3
   )

   gdialog --title "Menu item" --msgbox "You selected menu item $CHOICE. The GUI will now stop." 100 100

}


# The 'about this script' function. Initially, this is not visible in the UI menu.
function about {

   echo "
   This is a non-menu-visible 'about' function. 
   It tells you some background about the script.

   (You may need to scroll down and press tab to proceed 
   from this screen.)
   
   This skeleton script CLImenu is meant for playing
   with command line and menu interfaces.
   The aim is to enable studying of different simple dialogue 
   structures and interaction flow with the user. 
   The script makes use of BASH shell scripts as well as 
   some Whiptail user interface elements and functionality. 
   More information about the commands and uses of Whiptail 
   are available e.g. at
   https://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail
   
   The original 'CLImenu' has been created by 
   Marko Nieminen for the User Interface Construction 
   course at Aalto University, Finland. The script is not
   intended to be used for technical or any other 
   particular purposes than stydying and playing with it - 
   so feel free to use and modify it according to your needs.
   
   " > climenu.about.txt
   
   whiptail --textbox --scrolltext --title "About" climenu.about.txt 12 70
   rm climenu.about.txt

}


# This is not really needed much at all
function version_check {

   echo "CliMenu v"$version
   wget https://users.aalto.fi/mhtn/climenu.ver.txt >/dev/null 2>&1
   version_available=(`cat climenu.ver.txt`)
   rm climenu.ver.txt
   echo "Current version available at the web: v"$version_available

}


# No need to modify this function
function pause {
   read -n1 -r -p "Press any key to continue..." key
}


# Create the desired amount of functions like this dialog1
# and add them to the menus.
function dialog1 {
   echo -e ""
   echo -e "This is dialog1."
   echo -e "Here are the instructions.\n"
   echo -n "Ask something here; Your first name, perhaps? "
   read firstname
   echo -n -e "Your input/name is: "
   echo $firstname
   
   # do something with answer and
   # continue dialog1 here
   #
   
   echo -e ""
   pause
   
}

# Just a skeleton function, sort of repeating the previous one
function dialog2 {
   echo -n "This prompt requests your last name > "
   read lastname
   echo ""
   echo "Your last name is:" $lastname
   pause
}


# Get more than just one command from the command line
function parse_text {
	
   echo "Your command contained following parameters:"
   echo "#1: "$1
   echo "#2: "$2
   echo "#3: "$3
   echo "#4: "$4
   echo "#5: "$5
	
}


# And, finally...
# Here begins the main script
clear
echo "CLImenu v"$version
echo "A template script for studying command line and menu interaction."
echo ""
echo "Type help for instructions."
echo ""


# Main loop of the script
while [ true ]; do

   # The plain command prompt
   echo -n "Command > "
   read my_command
   
   # Fork according to my_command
   case "$my_command" in
        help)
            # Provide help and documentation to the user
            echo -e "\nType 'menu' for menu.\n"
            ;;
        menu)
            # Show the menu in the text_menu function
            text_menu
            ;;
        1)
            # Run a dialog script in function
            dialog1
            ;;
        2)
            # Another script
            dialog2
            ;;
        3)
            # Create output from the previous steps
            echo "Your name may be the following:" $firstname $lastname
            ;;
        m)
            # Present a different type of more interactive menu
            whiptail_menu
            ;;
        ver)
            # Check for new version of the script
            version_check
            ;;
        edit)
            # Edit this script with nano editor. You need to restart the script 
            # after modifying it, though.
            nano climenu.sh
            ;;
        view)
            # View the script in a text box
            whiptail --textbox --scrolltext --title "climenu.sh" climenu.sh 22 75
            ;;
        cls)
            # Clean the messy screen as needed. MS-DOS users remember this command :)
            clear
            ;;
        about)
            # A hidden function that does not appear in the menu
            about
            ;;
        dir)
            # Enable Windows users to list files in a Linux box
            ls -la
            ;;
        many*)
            # Get multiple words from the command line
            parse_text $my_command
            ;;
        gui)
            # Experiment with a GUI menu, too
            gui_menu
            ;;
        quit|stop)
            # Quit the script with 'quit' or 'stop' command
            exit 0
            ;;
        "")
            # Just the ENTER key, do nothing
            ;;
        *)
            # Any other command: inform user that the command is not known.
            echo "Unknown command. Type 'help' for instructions."
            ;;
   esac
done


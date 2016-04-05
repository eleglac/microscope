#microscope

This script ties together the raspistill and raspivid utilities
to allow more convenient control of the RasPi camera when taking
multiple pictures.
 
The script will prompt for an email address for any pictures taken
in a session. mpack is used to send the email with the picture as
an attachment, and so must be configured (/etc/ssmtp/ssmtp.conf).
The email address is not currently checked in any way, beyond
seeing if a string was entered, so make sure you don't mess it up.

##Features/Functions

While the script is running:
 - press 'p' to take a picture.
 - press 'q' to quit.

##Credits

Thanks to Franklin52 on the unix.com forums for the keypress polling
code.  The remainder of the script was written by Alex J. Ponting.


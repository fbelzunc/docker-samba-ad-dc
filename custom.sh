#!/bin/bash

#
# Custom script
#

# add groups
samba-tool group add CSC-ADMIN
samba-tool group add CSC-MANAGER
samba-tool group add CSC-AGENT
samba-tool group add CSC-COMPLIANCE

# add users
samba-tool user add gogo ia4uV1EeKait
samba-tool user add gogo2 ia4uV1EeKait
samba-tool user add gogo3 ia4uV1EeKait
samba-tool user add gogo4 ia4uV1EeKait

# add users to groups
samba-tool group addmembers CSC-ADMIN gogo
samba-tool group addmembers CSC-MANAGER gogo2,gogo
samba-tool group addmembers CSC-AGENT gogo3
samba-tool group addmembers CSC-COMPLIANCE gogo4

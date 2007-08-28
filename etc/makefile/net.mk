#!/usr/bin/make -f
# $Id: net.mk,v 1.19 2005/09/02 11:05:15 jaalto Exp $
#
#	Copyright (C)  Jari Aalto
#
#	This program is free software; you can redistribute it and/or
#	modify it under the terms of the GNU General Public License as
#	published by the Free Software Foundation; either version 2 of the
#	License, or (at your option) any later version
#
#	Make targets to update files to a remote location.

SOURCEFORGE_UPLOAD_HOST	= upload.sourceforge.net
SOURCEFORGE_UPLOAD_DIR	= /incoming

SOURCEFORGE_DIR		  = /home/groups/c/cy/cygbuild
SOURCEFORGE_SHELL	  = shell.sourceforge.net
SOURCEFORGE_USER	  = $(USER)
SOURCEFORGE_LOGIN	  = $(SOURCEFORGE_USER)@$(SOURCEFORGE_SHELL)
SOURCEFORGE_SSH_DIR	  = $(SOURCEFORGE_LOGIN):$(SOURCEFORGE_DIR)

CYGETC_DIR		  = etc/cygwin
CYGETC_UPLOAD_DIR	  = $(SOURCEFORGE_SSH_DIR)

# ######################################################### &targets ###

sf-uload-no-root:
	@if [ $(SOURCEFORGE_USER) = "root" ]; then			    \
	    echo "'root' cannot upload files. ";			    \
	    echo "Please call with 'make USER=<sourceforge-user> <target>"; \
	    return 1;							    \
	fi

# Rule: sf-upload-doc - [Maintenence] Sourceforge; Upload documentation
sf-upload-doc: sf-uload-no-root doc
	scp index.html $(SOURCEFORGE_SSH_DIR)/htdocs
	scp doc/*.html $(SOURCEFORGE_SSH_DIR)/htdocs/doc

# Rule: sf-upload-cygwin-setup-ini - [Maintenence] Sourceforge; Upload setup.ini
sf-upload-cygwin-setup-ini: sf-uload-no-root
	scp $(CYGETC_DIR)/setup.ini $(CYGETC_UPLOAD_DIR)/htdocs

# Rule: sf-upload-cygwin-release - [Maintenence] Sourceforge; Upload cygbuild Net release
sf-upload-cygwin-release: sf-uload-no-root
	@echo -e "If this fails, SCP file manually and run:\n"	     \
	     "	 ssh $(SOURCEFORGE_LOGIN); newgrp <project> \n"	     \
	     "	 mv ~/*bz2 $(SOURCEFORGE_DIR)/htdocs"
	scp $(CYGWIN_RELEASE_FILE_PATH) $(CYGETC_UPLOAD_DIR)/htdocs

sf-upload-release-check:
	@if [ -f $(CYGWIN_RELEASE_FILE_PATH).tar.gz ]; then		\
	    echo "$(CYGWIN_RELEASE_FILE_PATH) Release path not found";	\
	    false;							\
	fi

# Rule: sf-upload-release - [Maintenence] Sourceforge; Upload documentation
sf-upload-release: sf-upload-release-check
	@echo "-- run command --"
	@echo $(FTP)			    \
		$(SOURCEFORGE_UPLOAD_HOST)  \
		$(SOURCEFORGE_UPLOAD_DIR)   \
		$(CYGWIN_RELEASE_FILE_PATH)

# End of file

Avatar Classroom IAR
http://www.avatarclassroom.com

This repo is for the IAR archive of the Avatar Classroom rezzer.
It is provided by Paul Preibisch and Edmund Edgar

Source code (in this case LSL scripts) is shared with SLOODLE and available under the GPL 3. 
However we reserve the right to include 3D objects and graphical elements assets with different licenses.

The contents of the IAR archive is stored in decompressed form.
To import it into an OpenSim grid, you need to archive it with tar / gzip.

As of 2012-05-12, the scripts are all part of the public SLOODLE git repo:
https://github.com/sloodle/moodle-mod_sloodle

Some of the same objects can also be found in the SLOODLE IAR repo:
https://github.com/sloodle/sloodle_opensim_iar

Some scripts are provided for synchronizing with SLOODLE at:
https://github.com/sloodle/sloodle_development_tools/tree/master/opensim_sync


Examples of usage (also apply to the SLOODLE iar):

# Go into the directory containing the IAR. 
cd iar/

# Archive the contents as a file called /tmp/avatarclassroom.iar.
# NB OpenSim may choke on the archive unless the files are archived in the specified order.
# Also it prefers the directory/* formulation to avoid spurious errors.
tar zcvf /tmp/avatarclassroom.iar archive.xml inventory/* assets/*

# In the OpenSim console, you should now be able to load the archive:
load iar Your Avatar / yourpassw0rd /tmp/avatarclassroom.iar

# Note that even after you reload the archive, OpenSim sometimes uses cached versions.
# To avoid this:
# 1) Clear your viewer cache.
# 2) Delete the contents of bin/ScriptEngines
# 3) If possible, delete the relevant assets from the database.


To recreate this iar and update the Git repo, do the following:

# Make a directory in inventory - recommend iar/export/avatarclassroom

# Make a directory on the disk that the opensim user can write to - recommend /tmp/iar/export
mkdir /tmp/iar/export

# In the OpenSim console, export the iar: 
save iar Your Avatar /iar/export/sloodle/ yourpassw0rd /tmp/iar/export/avatarclassroom.iar

# Remove the contents of the current iar directory, and unpack the new iar instead.
rm -rf iar/*
cd iar
tar zxvf /tmp/iar/export/avatarclassroom.iar

# Tell Git to accept all the changes, commit and push
git add .
git commit -a
git push 


# Syncing with SLOODLE:

# The following assumes you have the sloodle_development_tools repo and the moodle-mod_sloodle repo checked out next to this repo.

# Having exported an IAR and committed it (see above), you can do:
find iar/ -name '*.lsl' -exec ../sloodle_development_tools/opensim_sync/syncSVNScriptsToOar.sh {} \;
# This will overwrite any scripts in your IAR with the versions that SLOODLE thinks it has.

# You can check which assets have changed with 
git diff
# ...and check what the changed scripts correspond to with 
tail iar/assets/<asset id>.lsl

# If you want all the SLOODLE versions, you can commit the changes as they are and re-import the IAR.

# If you want your IAR version to go into SLOODLE, copy it over to SLOODLE and commit.
# You should then  rerun the syncSVNScriptsToOar.sh step in case you have more than one of the same script in the IAR, and forgot to update some of them.

# Once complete, do:
git add .
git commit -a
git push 
# ...then reimport the IAR.

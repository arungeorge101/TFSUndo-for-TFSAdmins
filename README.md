TFS UNDO others checkout - recursively for all users

As a TFS admin, time and again I have to archive/move the branches to other folders to make sure that our TFS folders are not cluttered with old un-used branches. But when I try to MOVE the branches, if any of the developers have checked-out a file from that branch in their workspace then TFS doesn't allow me complete the operation. I have to undo all those checkouts (by all the users) before I can MOVE the branch.

The TFS Power tools provides some relief here. It helps you to undo others checkout from within Visual studio (or command line).
But the catch is that it can only perform the UNDO operation for one user at a time. So in a large organization if you have 100-200 developers working in a branch, that means if 100 developers have each checked out 1 file each from the branch, then I will have to press UNDO button 100 times to make the branch checkout free.

I searched extensively and couldnt find any out of the box solution. Finally the solution that I came up for this it to create a powershell script which queries the TFS (for a specific branch) to find the list of files checked out to users, then it loops through the user list and UNDO all the files checked-out to that user under the branch.

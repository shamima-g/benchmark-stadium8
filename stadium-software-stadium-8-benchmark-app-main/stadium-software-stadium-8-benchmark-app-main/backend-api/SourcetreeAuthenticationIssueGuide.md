# SourceTree Authentication Issue #
*[Home](README.md)*

Please follow the steps below if you are struggling to clone your repository due to an authentication issue on SourceTree

## Steps ##

1. Uninstall SourceTree
2. Restart your PC
3. Delete Atlassian folder in AppData>Local (AppData might be a hidden folder)
    - ![AppData Folder](Images/ImageAuthenticationIssueAppDataFolder.png)
4. Delete SourceTree Folder in AppData>Local
    - ![SourceTree Folder to delete](Images/ImageAuthenticationIssueAppDataFolderToDelete.png)
5. Delete Atlassian folder in AppData>Roaming (AppData might be a hidden folder)
    - ![Atlassian Folder to delete](Images/ImageAuthenticationIssueAppDataRoamingFolderToDelete.png)
6. Delete all Bitbucket and SourceTree related credentials in Control Panel Credential manager 
    - ![Delete Credentials](Images/ImageAuthenticationIssueDeleteCredentials.png)
7. Reinstall Source Tree
8. Log in with BitBucket (Your Microsoft account should automatically Authenticate) NOT BitBucket Server 
    - ![Choose Bitbucket when installing](Images/ImageAuthenticationIssueSourcetreeBitbucketLogin.png)
9. Tick the Git box only for Tools download and install
10. Open SourceTree
11. Select No SSH Key
12. When performing a Clone, Fetch, Pull or Put function for the first time a credential manager should pop up. **Select Manager and tick the use always box**

*[Home](README.md)*
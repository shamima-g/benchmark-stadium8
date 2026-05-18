*[Home](README.md)*

## Sourcetree ##

We use Sourcetree for the GIT client:

* Sourcetree can be downloaded from [here](https://www.sourcetreeapp.com/)
    * Upon installing, the window prompts Bitbucket server or Bitbucket
        * Click "skip", do the default for the rest of the installation

After installing SourceTree, kindly action the 2 points below to ensure that Windows and Git can handle long file paths:

**Git Long File Paths**

1. Run "Git Bash" as Admin
2. Copy, paste the run the following command on Git Bash: `git config --global core.longpaths true`

**Windows Long File Paths**

1. Press `Win + R`, type `gpedit.msc`, and press **Enter**.
2. Navigate to: `Local Computer Policy > Computer Configuration > Administrative Templates > System > Filesystem`
3. Double-click **Enable WIN32 long paths**.
4. Set it to **Enabled**, then click **OK**

If you are having issues with authentication when trying to clone your repository using Bitbucket, try the steps in the guide below:

* [SourceTree Authentication Issue Guide](SourcetreeAuthenticationIssueGuide.md)

*[Home](README.md)*
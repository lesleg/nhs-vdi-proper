& "$Env:ProgramFiles\Mozilla Firefox\uninstall\helper.exe" /S;
Disable-WindowsOptionalFeature –FeatureName "WindowsMediaPlayer" -Online
Disable-windowsoptionalfeature -online -featureName Internet-Explorer-Optional-amd64;

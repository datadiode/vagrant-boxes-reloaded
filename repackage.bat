@echo off

for %%u in (dalvaro74 datadiode) do (
	for /F "tokens=1,2,3,4 delims=(,) " %%a in ('vagrant box list') do (
		if "%%~dpa"=="%~dp0%%u\" (
			echo ``` > %%u-VAGRANTSLASH-%%~na.json
			for /F %%m in (%VAGRANT_HOME%\boxes\%%u-VAGRANTSLASH-%%~na\metadata_url) do curl -L %%m | jq . >> %%u-VAGRANTSLASH-%%~na.json
			echo ``` >> %%u-VAGRANTSLASH-%%~na.json
			gh release edit %%a --notes-file %%u-VAGRANTSLASH-%%~na.json --repo https://github.com/datadiode/vagrant-boxes-reloaded
			vagrant box repackage %%a %%b %%c
			move package.box %%u-VAGRANTSLASH-%%~na.box
			7z a %%u-VAGRANTSLASH-%%~na.7z -mx0 %%u-VAGRANTSLASH-%%~na.box -v2047m
			gh release upload %%a %%u-VAGRANTSLASH-%%~na.7z.* --clobber --repo https://github.com/datadiode/vagrant-boxes-reloaded
		)
	)
)

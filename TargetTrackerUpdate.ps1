#——————————————————————————————–#
# Script_Name : TargetTrackerUpdate.ps1
# Description : Update Target Tracker Application(http://www.eesforschools.org/TargetTracker); Current latest version is 15.7.4.64 and deployed version is 15.7.2.61
#               Script could be run as a standalone for individual endpoints or deployed over GPO.
# InfoSec Risk: Writes a clear-text log to %systemroot%\system32 to assess deployment status; This might be flagged by some AV solutions as a false-positive case of system-file tampering
# Version : 1.2
# Changes: 
#   v1.1: Removed typos; Changed msiexec display option from /qb(Basic UI) to /qn(no UI)
#   v1.2: Added logic to uninstall legacy version of applications(Tested successfully on v15.6, v15.5)
# Date : February 2019
# Created by Arjun N
# Disclaimer:
# THE SCRIPT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
# AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SCRIPT OR THE USE OR OTHER DEALINGS IN THE SCRIPT.
#——————————————————————————————-#

#Get current version of installed product
$prod = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "Primary Target Tracker"}
$version = $prod.DisplayVersion

$successlog = "%systemroot%\system32\TTv1574.log"

if(!(Test-Path $successlog) -and ($version -eq '15.7.2.61'))
{
# uninstall version 15.7.2.61
cmd /c msiexec /qn /x "\\FileServer\apps\TargetTrackerSetup15.7\Primary Target Tracker.msi" /L+* %systemroot%\temp\ttlog1.txt
# install version 15.7.4.64
cmd /c msiexec /qn /i "\\FileServer\apps\TargetTrackerSetup15.7.4\primary Target Tracker.msi" /L+* %systemroot%\temp\ttlog2.txt
# Copy a logfile to remote workstation
cmd /c copy "\\FileServer\Apps\TargetTrackerSetup15.7.4\TTv1574.log" "%systemroot%\system32\TTv1574.log"
}

elseif(!(Test-Path $successlog) -and ($version -ne ('15.7.2.61' -or '15.7.4.64')))
{
# install version 15.7.4.64
cmd /c msiexec /qn /i "\\FileServer\apps\TargetTrackerSetup15.7.4\primary Target Tracker.msi" /L+* %systemroot%\temp\ttlog2.3.txt
# Copy a logfile to remote workstation
cmd /c copy "\\FileServer\Apps\TargetTrackerSetup15.7.4\TTv1574.log" "%systemroot%\system32\TTv1574.log"
}

elseif((Test-Path $successlog) -and ($version -eq '15.7.4.64'))
{ echo latest version already installed
}

elseif((Test-Path $successlog) -and ($version -ne '15.7.4.64'))
{ echo Problemo...
 Remove-Item "%systemroot%\system32\TTv1574.log"
}

elseif(!(Test-Path $successlog) -and ($version -eq '15.7.4.64'))
{ echo No Problemo...
 # Copy a logfile to remote workstation
 cmd /c copy "\\FileServer\Apps\TargetTrackerSetup15.7.4\TTv1574.log" "%systemroot%\system32\TTv1574.log"
}

else
{
echo .........
pause 10 #doesnot work on PS v2
echo ........
}
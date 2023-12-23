# VRSDatabaseUpdate

The only works if you have installed VRS via the [mypiaware script](https://github.com/mypiaware/virtual-radar-server-installation) for linux. The script assumes that you have installed it in the default location. There are NO plans to port this to windows.

Also requires a PlaneBase subscription and access to PlaneBase SQB_Creator to provide some of the files required during the process. These files will NOT be and are NOT provided as part of this repo.

1) Clone Repo
2) Ensure PB files `BizJets.sqb`, `JetProp.sqb`, `Misocode.csv` and `Year.csv` are in `/VirtualRadarServer/VRS-Extras/DatabaseUpdateFiles` (Contact me for what you need to export from PlaneBase)
3) The base_path in the scripts is currently set to `/home/pi` if your home dir is not this then you will need to change it. `cd` into VRSDatabaseUpdate and run
   
`find . -type f -not -path "./sql/*" -exec sed  's#/home/pi#/home/'"$(whoami)"'#g' {} +`

  This should replace the base_path to your home directory
   
5) run `00_updateVRSDatabase.sh` - this can be run while VRS is active.
6) The scripts should perform a backup as part of the update process, just before any changes are made. However, you may wish to make your own as well.
  
   **I am _not_ responsible if your BaseStation.sqb becomes courrupted.** Use at your own risk.

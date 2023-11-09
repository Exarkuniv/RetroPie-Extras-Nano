# RetroPie-Extras-Nano
RetroPie Extras install scripts for Jetson Nano

This is all WIP right now. 

The following commands clone the repo to your Jetson Nano and then run install-scripts.sh to install the scripts in the master branch directly to the proper directories in the ARES-Setup/ folder.

```
cd ~
git clone https://github.com/Exarkuniv/Ares-Nano-Extras.git
sudo chmod 755 ~/Ares-Nano-Extras/install-extras.sh
cd ~/Ares-Nano-Extras && ./install-extras.sh
```


**UPDATE**
AS id 10-19-23 Im still working on these, i have got more of the older ones to work and will update soonish. 
i have come across a few bugs and a script that breaks something with the cmake. so im hunting that down and seeing WTF is up with that

I still have a handfull of edits i need to get done, but as of 9-20-23 all the scripts do install. and almost all do play
there are a few i have not tested yet as i dont have the game files (yet)

I will also go through all the normal port scripts that the other boards have and see what works and what dont

if you want background music i have figured that out also
all you need to do is add a ``music`` folder here 

``/opt/ares/configs/all/emulationstation``

ALSO
as of right now, you do need to install the runcommand to get the ports to work. 
possiable that will be fixed but i dont know how

**Other fixes and tweeks**

Fix to get sound on Quake 2. for whatever reason the control panel will swith to the analog output for the sound, 
you will have to switch it to HDMI if thats what you have.

i install the ``PulseAudio Volume Control`` app and just disable analog output, since using command line was abit confusing. 

to get the **rigelengine, tfe, dxx-rebirth, nblood, rednukem, and pcexhumed**  script to install, you need to change the GCC and G++ from version 7 to version 10 and 11

so use ``sudo update-alternatives --config gcc`` and ``sudo update-alternatives --config g++`` and change it to whatever number the higher version is on your system

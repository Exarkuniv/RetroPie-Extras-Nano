# RetroPie-Extras-Nano
RetroPie Extras install scripts for Jetson Nano

The following commands clone the repo to your Jetson Nano and then run install-scripts.sh to install the scripts in the master branch directly to the proper directories in the ARES-Setup/ folder.

```
cd ~
git clone https://github.com/Exarkuniv/Ares-Nano-Extras.git
sudo chmod 755 ~/Ares-Nano-Extras/install-extras.sh
cd ~/Ares-Nano-Extras && ./install-extras.sh
```


**UPDATE**
AS id 11-27-23 I think for the most part this is good to go. of course odd things come up, but i belive i got most of it cleaned up


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

to get the **rigelengine, tfe, dxx-rebirth, nblood, rednukem, and pcexhumed and others**  script to install, you need to change the GCC and G++ from version 7 to version 10 and 11

so use ``sudo update-alternatives --config gcc`` and ``sudo update-alternatives --config g++`` and change it to whatever number the higher version is on your system


here is what is needed to be added to the ``es_system.cfg`` for things to work or be seen

```
<system>
    <name>supermodel</name>
    <fullname>Sega supermodel 3</fullname>
    <path>/home/aresuser/ARES/roms/model3</path>
    <extension>.zip  .ZIP </extension>
    <command>/opt/ares/supplementary/runcommand/runcommand.sh 0 _SYS_ model3 %ROM%</command>
    <platform>supermodel</platform>
    <theme>model3</theme>
  </system>
  ```
    ```
	<system>
    <name>ports</name>
    <fullname>Ports</fullname>
    <path>/home/aresuser/ARES/roms/ports</path>
    <extension>.sh .SH</extension>
    <command>bash %ROM%</command>
    <platform>pc</platform>
    <theme>ports</theme>
  </system>
  ```
  ```
    <system>
    <name>solarus</name>
    <fullname>Solarus Engine</fullname>
    <path>/home/aresuser/ARES/roms/solarus</path>
    <extension>.solarus .zip .SOLARUS .ZIP</extension>
    <command>/opt/ares/supplementary/runcommand/runcommand.sh 0 _SYS_ solarus %ROM%</command>
    <platform>solarus</platform>
    <theme>solarus</theme>
	<system>
	```
	```
<system>
    <name>doom</name>
    <fullname>DOOM</fullname>
    <path>/home/aresuser/ARES/roms/doom</path>
    <extension>.sh .SH</extension>
    <command>bash %ROM%</command>
    <platform>doom</platform>
    <theme>doom</theme>
  </system>
  ```

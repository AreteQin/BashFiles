# for version in v1.14.0 v1.13.3 v1.13.2 v1.13.1 v1.13.0 v1.12.3 v1.12.2 v1.12.1 v1.12.0 v1.11.3 v1.11.2 v1.11.1 v1.11.0 v1.10.0 v1.9.0 v1.8.0 v1.7.0 v1.6.5 v1.5.5 v1.2.0 v1.1.3 v1.0.1;
for version in v1.6.5 v1.5.5 v1.2.0 v1.1.3 v1.0.1;
do
   echo $version
   cd ~/Downloads
   mkdir ./$version
   cd ./$version
   git clone -b $version https://github.com/PX4/PX4-Autopilot.git --recursive
   cd PX4-Autopilot
   make px4_fmu-v2_multicopter
done
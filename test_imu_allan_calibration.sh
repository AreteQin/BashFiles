#! /bin/bash

cd /home/qin/Downloads/IMUCalibration/IMUSimulationAllanVariance/

mkdir LatestTest
cd LatestTest

/home/qin/catkin_ws/src/imu_calibration_ros/cmake-build-debug/devel/lib/imu_calibration_ros/imu_simulator imu_static_simulation.bag

python3 /home/qin/catkin_ws/src/allan_variance_ros/scripts/cookbag.py --input ./imu_static_simulation.bag --output ./cooked_imu_static_simulation.bag

/home/qin/catkin_ws/src/allan_variance_ros/cmake-build-debug/devel/lib/allan_variance_ros/allan_variance ./cooked_imu_static_simulation.bag /home/qin/catkin_ws/src/allan_variance_ros/config/qcar_imu.yaml

python3 /home/qin/catkin_ws/src/allan_variance_ros/scripts/analysis.py --data ./allan_variance.csv
#! /bin/bash

cd /home/qin/Downloads/IMUCalibration/IMUSimulationTK/

mkdir LatestTest
cd LatestTest

/home/qin/catkin_ws/src/imu_calibration_ros/cmake-build-debug/devel/lib/imu_calibration_ros/imu_simulator imu_TK_simulation.bag

/home/qin/catkin_ws/src/imu_calibration_ros/cmake-build-debug/devel/lib/imu_calibration_ros/test_imu_calib ./imu_TK_simulation.bag
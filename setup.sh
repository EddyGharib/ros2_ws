#!/bin/bash

set -eo pipefail

rm -rf repos tmp
mkdir -p repos tmp

pushd tmp

git clone git@github.com:idealworks/bazel-public-registry.git -b feature/update_ros_jazzy_packages

popd

pushd repos

# Layer 1
git clone https://github.com/osrf/osrf_testing_tools_cpp -b jazzy

# Layer 2
git clone https://github.com/ros2/rcutils -b jazzy

# Layer 3
git clone https://github.com/ros2/rosidl -b jazzy

# Layer 4
git clone https://github.com/ros2/rmw -b jazzy
git clone https://github.com/ros2/rcpputils -b jazzy

# Layer 5
git clone https://github.com/ament/ament_index -b jazzy
git clone https://github.com/ros2/rosidl_dynamic_typesupport -b jazzy
git clone https://github.com/eProsima/Fast-CDR
pushd Fast-CDR
git checkout 0e2650a58c1968ca2acc3314e17ed2f8a1188f93
popd
git clone https://github.com/ros2/rosidl_typesupport_fastrtps -b jazzy
git clone https://github.com/ros2/rosidl_typesupport -b jazzy
git clone https://github.com/ros2/ros2_tracing -b jazzy

# Layer 5.1, rosidl_python is part of a cyclic dep because it's interconnected with com_github_mvukov_rules_ros2
# Others are it's deps

git clone https://github.com/ros2/rpyutils -b jazzy
git clone https://github.com/ros2/rosidl_python -b jazzy

# layer 5.2 roscli

git clone https://github.com/ros2/unique_identifier_msgs -b jazzy
git clone https://github.com/ros2/test_interface_files -b jazzy
git clone https://github.com/ros2/rcl_interfaces -b jazzy
git clone https://github.com/ros2/rmw_cyclonedds -b jazzy
git clone https://github.com/ros2/rmw_zenoh -b jazzy
git clone https://github.com/ros2/rmw_implementation -b jazzy
git clone https://github.com/ros2/rcl -b jazzy
git clone https://github.com/ros2/rclpy -b jazzy
git clone https://github.com/ros2/rosidl_runtime_py -b jazzy
git clone https://github.com/ros2/ros2cli -b jazzy

git clone https://github.com/EddyGharib/rules_ros2 -b jazzy



git clone https://github.com/ros2/rmw_dds_common -b 3.1.1
git clone https://github.com/ros2/rcl_logging -b 3.1.1

# Layer 6






popd

pushd tmp/bazel-public-registry
bazel run //scripts:apply_overlay_and_patches -- ros2_osrf_testing_tools_cpp `pwd` `pwd`/../../repos/osrf_testing_tools_cpp
bazel run //scripts:apply_overlay_and_patches -- ros2_rcutils `pwd` `pwd`/../../repos/rcutils
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl `pwd` `pwd`/../../repos/rosidl
bazel run //scripts:apply_overlay_and_patches -- ros2_rmw `pwd` `pwd`/../../repos/rmw
bazel run //scripts:apply_overlay_and_patches -- ros2_rcpputils `pwd` `pwd`/../../repos/rcpputils
bazel run //scripts:apply_overlay_and_patches -- ros2_ament_index `pwd` `pwd`/../../repos/ament_index
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl_dynamic_typesupport `pwd` `pwd`/../../repos/rosidl_dynamic_typesupport
bazel run //scripts:apply_overlay_and_patches -- fast_cdr `pwd` `pwd`/../../repos/Fast-CDR
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl_typesupport_fastrtps `pwd` `pwd`/../../repos/rosidl_typesupport_fastrtps
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl_typesupport `pwd` `pwd`/../../repos/rosidl_typesupport
bazel run //scripts:apply_overlay_and_patches -- ros2_tracing `pwd` `pwd`/../../repos/ros2_tracing

# Layer 5.1
bazel run //scripts:apply_overlay_and_patches -- ros2_rpyutils `pwd` `pwd`/../../repos/rpyutils
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl_python `pwd` `pwd`/../../repos/rosidl_python

# layer 5.2
bazel run //scripts:apply_overlay_and_patches -- ros2_unique_identifier_msgs `pwd` `pwd`/../../repos/unique_identifier_msgs
bazel run //scripts:apply_overlay_and_patches -- ros2_test_interface_files `pwd` `pwd`/../../repos/test_interface_files
bazel run //scripts:apply_overlay_and_patches -- ros2_rcl_interfaces `pwd` `pwd`/../../repos/rcl_interfaces
bazel run //scripts:apply_overlay_and_patches -- ros2_rmw_cyclonedds `pwd` `pwd`/../../repos/rmw_cyclonedds
bazel run //scripts:apply_overlay_and_patches -- ros2_rmw_zenoh_cpp `pwd` `pwd`/../../repos/rmw_zenoh
bazel run //scripts:apply_overlay_and_patches -- ros2_rmw_implementation `pwd` `pwd`/../../repos/rmw_implementation

bazel run //scripts:apply_overlay_and_patches -- ros2_rcl `pwd` `pwd`/../../repos/rcl
bazel run //scripts:apply_overlay_and_patches -- ros2_rclpy `pwd` `pwd`/../../repos/rclpy
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl_runtime_py `pwd` `pwd`/../../repos/rosidl_runtime_py
bazel run //scripts:apply_overlay_and_patches -- ros2cli `pwd` `pwd`/../../repos/ros2cli

bazel run //scripts:apply_overlay_and_patches -- ros2_rmw_dds_common `pwd` `pwd`/../../repos/rmw_dds_common
bazel run //scripts:apply_overlay_and_patches -- ros2_rcl_logging `pwd` `pwd`/../../repos/rcl_logging

popd

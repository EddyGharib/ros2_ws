#!/bin/bash

set -eo pipefail

rm -rf repos tmp
mkdir -p repos tmp

pushd tmp

git clone git@github.com:idealworks/bazel-public-registry.git -b feature/update_ros_jazzy_packages

popd

pushd repos

# Layer 0
git clone https://github.com/eProsima/Fast-CDR
pushd Fast-CDR
git checkout 0e2650a58c1968ca2acc3314e17ed2f8a1188f93
popd

git clone https://github.com/EddyGharib/rules_ros2 -b 2.0.0.eddy.9

# Layer 1
git clone https://github.com/osrf/osrf_testing_tools_cpp -b 2.0.0

# Layer 2
git clone https://github.com/ros2/rcutils -b 6.7.7

# Layer 3
git clone https://github.com/ros2/rosidl -b 4.6.10

# Layer 4
git clone https://github.com/ros2/rmw -b 7.3.4
git clone https://github.com/ros2/rcpputils -b 2.4.3

# Layer 5
git clone https://github.com/ament/ament_index -b 1.8.4
git clone https://github.com/ros2/rosidl_dynamic_typesupport -b 0.1.2
git clone https://github.com/ros2/rosidl_typesupport_fastrtps -b 3.6.4
git clone https://github.com/ros2/rosidl_typesupport -b 3.2.3
git clone https://github.com/ros2/ros2_tracing -b 8.2.6
git clone https://github.com/ros2/rmw_dds_common -b 3.1.1
git clone https://github.com/ros2/rcl_logging -b 3.1.1

# Layer 6






popd

pushd tmp/bazel-public-registry
bazel run //scripts:apply_overlay_and_patches -- fast_cdr `pwd` `pwd`/../../repos/Fast-CDR
bazel run //scripts:apply_overlay_and_patches -- com_github_mvukov_rules_ros2 `pwd` `pwd`/../../repos/rules_ros2
bazel run //scripts:apply_overlay_and_patches -- ros2_osrf_testing_tools_cpp `pwd` `pwd`/../../repos/osrf_testing_tools_cpp
bazel run //scripts:apply_overlay_and_patches -- ros2_rcutils `pwd` `pwd`/../../repos/rcutils
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl `pwd` `pwd`/../../repos/rosidl
bazel run //scripts:apply_overlay_and_patches -- ros2_rmw `pwd` `pwd`/../../repos/rmw
bazel run //scripts:apply_overlay_and_patches -- ros2_rcpputils `pwd` `pwd`/../../repos/rcpputils
bazel run //scripts:apply_overlay_and_patches -- ros2_ament_index `pwd` `pwd`/../../repos/ament_index
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl_dynamic_typesupport `pwd` `pwd`/../../repos/rosidl_dynamic_typesupport
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl_typesupport_fastrtps `pwd` `pwd`/../../repos/rosidl_typesupport_fastrtps
bazel run //scripts:apply_overlay_and_patches -- ros2_rosidl_typesupport `pwd` `pwd`/../../repos/rosidl_typesupport
bazel run //scripts:apply_overlay_and_patches -- ros2_tracing `pwd` `pwd`/../../repos/ros2_tracing
bazel run //scripts:apply_overlay_and_patches -- ros2_rmw_dds_common `pwd` `pwd`/../../repos/rmw_dds_common
bazel run //scripts:apply_overlay_and_patches -- ros2_rcl_logging `pwd` `pwd`/../../repos/rcl_logging

popd

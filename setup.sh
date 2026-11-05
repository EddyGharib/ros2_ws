#!/bin/bash

set -eo pipefail

rm -rf repos tmp
mkdir -p repos tmp

pushd tmp

git clone git@github.com:idealworks/bazel-public-registry.git -b next
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
# 2.2.x is what Jazzy's ros2.repos tracks (master is 2.5.x)
git clone https://github.com/eProsima/Fast-CDR -b 2.2.x
git clone https://github.com/ros2/rosidl_typesupport_fastrtps -b jazzy
git clone https://github.com/ros2/rosidl_typesupport -b jazzy
git clone https://github.com/ros2/ros2_tracing -b jazzy

# Layer 5.1, rosidl_python is used by rules_ros2_interfaces
# Others are it's deps

git clone https://github.com/ros2/rpyutils -b jazzy
git clone https://github.com/ros2/rosidl_python -b jazzy

# Layer 5.2, interface rules split out of rules_ros2 to break the rules_ros2 <-> ros2cli cycle
git clone https://github.com/EddyGharib/rules_ros2_interfaces -b jazzy

# Layer 5.2.1, ros2_plugin split out of rules_ros2 (depends only on rules_cc)
# feature branch until the PR into jazzy merges
git clone https://github.com/EddyGharib/rules_ros2_plugins -b jazzy

# layer 5.3 ros2cli

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

# fork changes collect on this branch until the final PR into jazzy
git clone https://github.com/EddyGharib/rules_ros2 -b fix/drop_unused_deps_jazzy



git clone https://github.com/ros2/rmw_dds_common -b 3.1.1
git clone https://github.com/ros2/rcl_logging -b 3.1.1

# Layer 6
git clone https://github.com/ros/resource_retriever -b jazzy
git clone https://github.com/ros2/launch -b jazzy

# Layer 7
git clone https://github.com/ros-tooling/libstatistics_collector -b jazzy

# Layer 8
git clone https://github.com/ros2/ament_cmake_ros -b jazzy
git clone https://github.com/ros2/launch_ros -b jazzy

# Layer 9
git clone https://github.com/ros/class_loader -b jazzy
git clone https://github.com/ros/pluginlib -b jazzy
git clone https://github.com/ros2/common_interfaces -b jazzy
git clone https://github.com/ros2/example_interfaces -b jazzy
git clone https://github.com/ros-tooling/keyboard_handler -b jazzy
git clone https://github.com/ros2/rclcpp -b jazzy
# xacro has one branch for all distros; Jazzy's rosdistro tracks ros2
git clone https://github.com/ros/xacro -b ros2

# Layer 10
git clone https://github.com/ros2/message_filters -b jazzy
git clone https://github.com/ros-perception/image_common -b jazzy
git clone https://github.com/ros/diagnostics -b ros2-jazzy
git clone https://github.com/ros2/demos -b jazzy
git clone https://github.com/RobotWebTools/rosbridge_suite -b jazzy
git clone https://github.com/ros2/rosbag2 -b jazzy
git clone https://github.com/ros2/rclc -b jazzy

# Layer 11
git clone https://github.com/ros/urdfdom_headers -b jazzy
git clone https://github.com/ros/urdfdom -b jazzy
git clone https://github.com/ros2/urdf -b jazzy
git clone https://github.com/ros/kdl_parser -b jazzy
git clone https://github.com/ros2/geometry2 -b jazzy
git clone https://github.com/ros-perception/laser_geometry -b jazzy
git clone https://github.com/ros/robot_state_publisher -b jazzy
# rosdistro's source entry says ros2, but the Jazzy releases (4.2.0, 1.0.6) are the jazzy branches
git clone https://github.com/ros/bond_core -b jazzy
git clone https://github.com/ros-geographic-info/geographic_info -b jazzy
git clone https://github.com/ros-navigation/navigation2 -b jazzy
git clone https://github.com/facontidavide/rosx_introspection -b master
# iw_hub dependency (sd-bus C++ bindings); latest release
git clone https://github.com/Kistler-Group/sdbus-cpp -b v2.3.1
git clone https://github.com/AlexKaravaev/ros2_laser_scan_matcher -b main
# untagged: version names count from a virtual 0.0.0 tag on the root commit (registry README)
git -C ros2_laser_scan_matcher tag 0.0.0 "$(git -C ros2_laser_scan_matcher rev-list --max-parents=0 HEAD)"
git clone https://github.com/alexkaravaev/csm -b ros2_csm_eigen
# iw_hub dependencies that used to be http_archives in iw_hub_ros2
git clone https://github.com/ros-perception/vision_opencv -b 4.1.0
git clone https://github.com/ros-perception/image_transport_plugins -b 4.0.4
git clone https://github.com/IntelRealSense/realsense-ros -b 4.55.1
git clone https://github.com/aiekick/ImGuiFileDialog -b v0.6.8

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

# layer 5.3
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

# Layer 6
bazel run //scripts:apply_overlay_and_patches -- ros2_resource_retriever `pwd` `pwd`/../../repos/resource_retriever
bazel run //scripts:apply_overlay_and_patches -- ros2_launch `pwd` `pwd`/../../repos/launch

# Layer 7
bazel run //scripts:apply_overlay_and_patches -- ros2_libstatistics_collector `pwd` `pwd`/../../repos/libstatistics_collector

# Layer 8
bazel run //scripts:apply_overlay_and_patches -- ros2_ament_cmake_ros `pwd` `pwd`/../../repos/ament_cmake_ros
bazel run //scripts:apply_overlay_and_patches -- ros2_launch_ros `pwd` `pwd`/../../repos/launch_ros

# Layer 9
bazel run //scripts:apply_overlay_and_patches -- ros2_class_loader `pwd` `pwd`/../../repos/class_loader
bazel run //scripts:apply_overlay_and_patches -- ros2_pluginlib `pwd` `pwd`/../../repos/pluginlib
bazel run //scripts:apply_overlay_and_patches -- ros2_common_interfaces `pwd` `pwd`/../../repos/common_interfaces
bazel run //scripts:apply_overlay_and_patches -- ros2_example_interfaces `pwd` `pwd`/../../repos/example_interfaces
bazel run //scripts:apply_overlay_and_patches -- ros2_keyboard_handler `pwd` `pwd`/../../repos/keyboard_handler
bazel run //scripts:apply_overlay_and_patches -- ros2_rclcpp `pwd` `pwd`/../../repos/rclcpp
bazel run //scripts:apply_overlay_and_patches -- ros2_xacro `pwd` `pwd`/../../repos/xacro

# Layer 10
bazel run //scripts:apply_overlay_and_patches -- ros2_message_filters `pwd` `pwd`/../../repos/message_filters
bazel run //scripts:apply_overlay_and_patches -- ros2_image_common `pwd` `pwd`/../../repos/image_common
bazel run //scripts:apply_overlay_and_patches -- ros2_diagnostics `pwd` `pwd`/../../repos/diagnostics
bazel run //scripts:apply_overlay_and_patches -- ros2_demos `pwd` `pwd`/../../repos/demos
bazel run //scripts:apply_overlay_and_patches -- ros2_rosbridge_suite `pwd` `pwd`/../../repos/rosbridge_suite
bazel run //scripts:apply_overlay_and_patches -- ros2_rosbag2 `pwd` `pwd`/../../repos/rosbag2
bazel run //scripts:apply_overlay_and_patches -- ros2_rclc `pwd` `pwd`/../../repos/rclc

# Layer 11
bazel run //scripts:apply_overlay_and_patches -- ros2_urdfdom_headers `pwd` `pwd`/../../repos/urdfdom_headers
bazel run //scripts:apply_overlay_and_patches -- ros2_urdfdom `pwd` `pwd`/../../repos/urdfdom
bazel run //scripts:apply_overlay_and_patches -- ros2_urdf `pwd` `pwd`/../../repos/urdf
bazel run //scripts:apply_overlay_and_patches -- ros2_kdl_parser `pwd` `pwd`/../../repos/kdl_parser
bazel run //scripts:apply_overlay_and_patches -- ros2_geometry2 `pwd` `pwd`/../../repos/geometry2
bazel run //scripts:apply_overlay_and_patches -- ros2_laser_geometry `pwd` `pwd`/../../repos/laser_geometry
bazel run //scripts:apply_overlay_and_patches -- ros2_robot_state_publisher `pwd` `pwd`/../../repos/robot_state_publisher
bazel run //scripts:apply_overlay_and_patches -- bond `pwd` `pwd`/../../repos/bond_core
bazel run //scripts:apply_overlay_and_patches -- geographic_info `pwd` `pwd`/../../repos/geographic_info
bazel run //scripts:apply_overlay_and_patches -- ros2_nav2 `pwd` `pwd`/../../repos/navigation2
bazel run //scripts:apply_overlay_and_patches -- ros2_rosx_introspection `pwd` `pwd`/../../repos/rosx_introspection
bazel run //scripts:apply_overlay_and_patches -- ros2_laser_scan_matcher `pwd` `pwd`/../../repos/ros2_laser_scan_matcher
bazel run //scripts:apply_overlay_and_patches -- com_github_alexkaravaev_csm `pwd` `pwd`/../../repos/csm
bazel run //scripts:apply_overlay_and_patches -- sdbus_cpp `pwd` `pwd`/../../repos/sdbus-cpp
bazel run //scripts:apply_overlay_and_patches -- vision_opencv `pwd` `pwd`/../../repos/vision_opencv
bazel run //scripts:apply_overlay_and_patches -- ros2_image_transport_plugins `pwd` `pwd`/../../repos/image_transport_plugins
bazel run //scripts:apply_overlay_and_patches -- lips_hci_realsense_ros `pwd` `pwd`/../../repos/realsense-ros
bazel run //scripts:apply_overlay_and_patches -- imgui_file_dialog `pwd` `pwd`/../../repos/ImGuiFileDialog

popd

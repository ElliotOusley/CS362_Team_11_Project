#!/bin/bash
godot --headless -s addons/gut/gut_cmdln.gd -d --path "$PWD/codeQuest/codeQuest" -gdir=res://Tests/Unit/ -glog=1 -gexit -gsuffix=.test.gd -gprefix=
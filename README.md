# CodeQuest

Codequest is a puzzle role playing game that teaches programming through rpg mechanics like battles and puzzles. In this game, the player makes progress through completing puzzles in which they drag text blocks to answer questions and complete partial code snippets. This game is aimed at users who are new to programming, or those who would like an overview of programming in general.

Codequest was created by Seth Taylor, Elliot Ousley, Nathen dela Torre, Carlos Vasquez, Ben Snider, and Hau’oli O’Brien.
This repository contains all materials and documentation related to our project.

# Living Document
Our [final report](https://github.com/ElliotOusley/CS362_Team_11_Project/blob/main/Living%20Document/Final_Report.md), along with other documentation files, can be found [here.](https://github.com/ElliotOusley/CS362_Team_11_Project/tree/main/Living%20Document)

# Itch.io (Downloads)

To play CodeQuest in your browser or download the Windows version, visit our [itch.io page](https://elliot-ousley.itch.io/codequest)

# Game Files

All Game Development related files can be found in the Source Directory. The directory can be found [here](https://github.com/ElliotOusley/CS362_Team_11_Project/tree/main/Source/codeQuest)

# Reports

Weekly meeting reports are located in the [reports folder](https://github.com/ElliotOusley/CS362_Team_11_Project/tree/main/Living%20Document/reports), and Team meeting notes can be found in the [meeting notes folder](https://github.com/ElliotOusley/CS362_Team_11_Project/tree/main/Living%20Document/Meeting_Notes)

# Trello

Progress on the project can be seen on our [Trello Board](https://trello.com/b/Lz0f5vrL/pt11-project)

# Wiki

A guide on gameplay features can be found in our [wiki page](https://github.com/ElliotOusley/CS362_Team_11_Project/wiki)



# Testing

```BASH
godot --headless -s addons/gut/gut_cmdln.gd -d --path "$PWD/codeQuest/codeQuest" -gdir=res://Tests/Unit/ -glog=1 -gexit -gsuffix=.test.gd -gprefix=
```

# CodeQuest

Codequest is a puzzle role playing game that teaches programming through rpg mechanics like battles and puzzles. In this game, the player makes progress through completing puzzles in which they drag text blocks to answer questions and complete partial code snippets. This game is aimed at users who are new to programming, or those who would like an overview of programming in general.

Codequest was created by Seth Taylor, Elliot Ousley, Nathen dela Torre, Philensakada Thavrin, Carlos Vasquez, Ben Snider, and Hau’oli O’Brien.
This repository contains all materials and documentation related to our project.

# Living Document

- [Project Proposal](https://github.com/ElliotOusley/CS362_Team_11_Project/blob/main/ProjectProposal.md)
- [Requirements Elicitation](https://github.com/ElliotOusley/CS362_Team_11_Project/blob/main/ProjectElicitation.md)
- [Architecture and Design](https://github.com/ElliotOusley/CS362_Team_11_Project/blob/main/Project%20Architecture%20and%20Design.md)
- [Mid Term Report](https://github.com/ElliotOusley/CS362_Team_11_Project/blob/main/Mid_Term_Report.md)
- [Developer Documentation](https://github.com/ElliotOusley/CS362_Team_11_Project/blob/main/Developer_Documentation.md)
- [User Documentation](https://github.com/ElliotOusley/CS362_Team_11_Project/blob/main/User_Documentation.md)

# Itch.io (Web Version)

To play CodeQuest in your browser, visit our [itch.io page](https://elliot-ousley.itch.io/codequest)

# Game Files

All Game Development related files can be found in the CodeQuest Directory. The directory can be found [here](https://github.com/ElliotOusley/CS362_Team_11_Project/tree/main/codeQuest/codeQuest)

# Reports

Weekly meeting reports are located in the [reports folder](https://github.com/ElliotOusley/CS362_Team_11_Project/tree/main/reports), and Team meeting notes can be found in the [meeting notes folder](https://github.com/ElliotOusley/CS362_Team_11_Project/tree/main/Meeting_Notes)

# Trello

Progress on the project can be seen on our [Trello Board](https://trello.com/b/Lz0f5vrL/pt11-project)

# Wiki

A guide on gameplay features can be found in our [wiki page](https://github.com/ElliotOusley/CS362_Team_11_Project/wiki)



# Testing

```BASH
godot --headless -s addons/gut/gut_cmdln.gd -d --path "$PWD/codeQuest/codeQuest" -gdir=res://Tests/Unit/ -glog=1 -gexit -gsuffix=.test.gd -gprefix=
```

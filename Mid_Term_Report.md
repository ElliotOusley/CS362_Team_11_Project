# 1. Project Problem and Solution 

Many learners struggle to stay motivated when acquiring new skills, especially in programming. Often, learning can feel like a chore, and access to educational resources can be hindered by paywalls.
CodeQuest aims to make learning engaging by integrating coding challenges into an RPG-style game, where players earn incentives for solving coding problems. Players can redo challenges up to three times before engaging in battles,
reinforcing knowledge retention. Our solution leverages a well-structured architecture with a game loop, UI integration, and a challenge validation system, ensuring an engaging and educational experience.
Testing will include user engagement analysis, success rates of coding challenges, and gameplay balancing metrics to validate the effectiveness of our approach. 

# 2. Software architecture 

### Major Components
* User Interface - provides players with interactive elements such as menus, inventory, settings, and dialogue, ensuring an accessible and user-friendly experience.  

* Game Scene - acts as the primary environment where gameplay takes place, allowing players to navigate, interact with objects, and engage in various challenges.  

* Dialogue System - facilitates communication between players and non-player characters (NPCs) using Area2D nodes to trigger conversations.  

* Code Puzzle System - enables coding challenges, validates player input, and provides real-time feedback.  

* Save System - ensures that player progress and game configurations are stored and retrieved efficiently using user files and configuration settings. 

### Event-Driven Architecture
Godot uses event-driven Architecture. In the context of Godot, events are the signals emitted by nodes, like a button being pressed, in the case of menus, or like the player entering a dialogue actionable Area2D Node. 
These nodes also function as event handlers, as signals from one node are sent to others through scripts. This architecture is useful because nodes can be asynchronous, and do not necessarily need to know about one another, 
just that a signal was sent from one to another. For example, a node with a script that detects when the player picks up an item may not need to know what was picked up, just that an item was picked up.

### Component Interfacing

Each component in CodeQuest interacts with others through well-defined interfaces. The User Interface overlays the Game Scene, responding to player input and triggering necessary actions.
The Game Scene connects to both the Dialogue System and Code Puzzle System, using Area2D nodes to initiate interactions when a player approaches an NPC or a coding challenge object. 
The Save System integrates with all components by managing stored data, ensuring seamless game state transitions and persistence of user preferences. 

### Data Storage

CodeQuest employs a file-based storage approach for managing player progress and settings. The system saves essential gameplay information such as current level, inventory, and quest completion status. Game settings, 
including audio levels, control mappings, and UI preferences, are preserved using a ConfigFile node.
Additionally, the Code Puzzle System maintains a log of player submissions and solutions to facilitate progress tracking and debugging. 

### Alternatives
Instead of Godot, the game could be developed in Unity or Unreal Engine 

#### Unity 

Pros: 

* Industry Standard: Unity is used by many major game companies and has a large following behind it, meaning that resources are easier to find 

Cons: 

#### Unreal Engine 

Pros: 

* Graphics: Unreal has features that allow for more advanced graphics 

* Visual Coding: Unreal allows for games to be developed using a visual code format, which may be easier 

Cons: 

* Specification: While Unreal can be used to develop 2D games, it is far more specialized for 3D 

	Instead of GDScript, the game could be developed using C++ or C+ 

#### C++ 

Pros: 

* Familiarity: Most of the team has used C++ to develop projects in previous classes 

Cons: 

* Lack of support: While Godot allows C++ to be used to develop games, the support for it is fairly weak, as C# and GDScript are preferred 

* Lack of Documentation: Many parts of the Godot Documentation do not have anything listed for C++ 

#### C# 

Pros: 

* Supported: While it doesn’t have as much support as GDScript, C# is fairly well supported within the documentation and in-editor. 

* Speed: C# is a faster language than GDScript 

Cons: 

* New Addition: Support for C# is a newer addition to the Godot engine, and therefore does not have as much support. 

# 3. Software design 

### Component Parts 

Godot abstracts components as nodes and scenes, where scenes are a collection of nodes. Currently, our game uses the following scenes: 

* Main 

* Player 

* Main Menu 

* Options 

* NPC  

### Component Responsibilities

* The Main scene is where the player interacts with the world. All other scenes interact with it. 

* The player scene controls the player character and all of its related functions 

* The Main Menu is not held in the main scene, but allows the player to access the Options and Main scenes. 

* The Options scene allows the player to configure the volume and game controls 

* The NPC scene handles all non-player characters. 

# 4. Coding guideline 

For our work in GDScript, we will use the GDScript style guide, provided in the [Godot Documentation]( https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html )

We chose these guidelines because they are the most used in Godot development, and make scripts very easy to read, especially on smaller monitors or screen sizes.  

Additionally, Godot’s script editor automatically uses parts of this style guide. For example, adding in a function via node automatically provides the double white space noted in the style guide. As another example, the Godot editor displays a transparent vertical line at the 80 and 100 character mark. 

# 5. Process description 

### i. Risk assessment 

**Scope Creep:**
Scope management is an important part of game development. The scale of the project must be controlled to prevent wasted work and unreachable goals. 
If the scope of the project gets too large, major parts of the project may be missing essential features that affect the player 
experience. This issue has a high likelihood of occurring. As the team is new to game development,
we do not yet have the experience needed to limit the scope of development. To reduce the likelihood,
we have created weekly goals for game progress, that we will follow without attempting to add additional features
until essential features are done. We can detect this issue by checking in with all members
to ensure that we all take on work that is achievable. 

**Inexperience:**
While all members of the team have experience with programming, they do not have experience with 
GDScript or the Godot engine. Because of this, learning and project development must be done
at the same time, which could lead to mistakes. This has a high likelihood of occurring, 
and a high impact to progress if it occurs. This issue has already occured a few times as the team gets used to Godot.
This issue can be minimized by the amount of educational resources available for learning Godot,
like their incredibly comprehensive documentation and YouTube guides made by experienced users of Godot.

**Playtesting and Bug fixing:**
To ensure that players have a positive experience with this project,
it is essential that members test to ensure that the game is interesting, not too difficult,
and free of bugs. These issues  have a medium likelihood of occuring, and a medium impact on the project. 
Even with testing and bugfixing, some issues may occur. This risk can be minimized by encouraging people
outside of the development team to playtest the game, in order to receive unique and genuine feedback. 
Additionally, we will be using GitHub Issues to document bugs. 

**Finding the fun:**
While having good art assets and complicated systems can help with a user’s experience,
players will not play games that are not fun, no matter how technically impressive or visually appealing it is.
As such, we must identify what parts of our game are interesting and enjoyable, and develop those with more attention.
This issue has a medium likelihood of occurring, but will not affect project completion. It will, however, 
affect the final product if fun mechanics are not identified. This issue can be minimized by running frequent
playtesting to get feedback on what others find fun. 

**Audiences:**
Our game combines multiple genres as a way to teach programming in a fun way. However, 
this runs the risk of alienating audiences. As an example, combining a puzzle game with a role playing game may 
not appeal to players who are a fan of either genre, but instead a smaller subset of player who enjoy both. As such,
it is important to consider ways to get players who only enjoy one genre to try the game. This issue has high risk
of occuring, as we are combining multiple genres for this game. However, it has a low impact.
It could lead to less player engagement. This risk can be detected through playtesting with 
people who are fans of one of the two genres we combine. This risk can be minimized by ensuring that both genres 
are properly represented with extra care taken to develop game mechanics. 

**Integration Issues:**
Since the project involves multiple components working together, integration issues have a high likelihood and a medium impact if not managed properly.
These issues could happen when members independently developed codes fail to function correctly as a whole. Based on past development, integration problems often surface late in the project if components are not tested together early.
To mitigate this, we will continuously testing our codes as they are developed. Regular integration tests will be conducted to detect mismatches in APIs, data formats, or dependencies. If integration failures occur, debugging will be prioritized,
and adjustments will be made to ensure compatibility across all modules.

### ii. Project schedule 

Identify milestones (external and internal), define tasks along with effort estimates (at granularity no coarser than 1-person-week units), and identify dependences among them. (What has to be complete before you can begin implementing component X? What has to be complete before you can start testing component X? What has to be complete before you can run an entire (small) use case?) This should reflect your actual plan of work, possibly including items your team has already completed. 

To build a schedule, start with your major milestones (tend to be noun-like) and fill in the tasks (tend to start with a verb) that will allow you to achieve them. A simple table is sufficient for this size of a project. 

Timeline 
| Week     | Development Tasks | Design Tasks |
| ----------- | ----------- | ---------------- |
| Week 3  | Polish existing movement system | Create tile map and two NPC sprites  |
| Week 4  | Implement dialogue system | Design UI for dialogue and inventory systems  |
| Week 5  | Implement placing blocks in UI | Design UI for code block puzzles and make prototypes for levels  |
| Week 6  | Implement code block functionality  | Create levels and environments and design code block puzzles  |
| Week 7  | Create save system  | Create or find appropriate music and sound effects  |
| Week 8  | Polish and test code block system  | Polish Existing sprites |
| Week 9  | Implement battle system and other stretch goals |  Add additional animations and animation trees |
| Week 10 | Final Testing | Final Testing |

Logistics Team: 

Every Week: write documentation, set up meetings, communicate with project managers, keep up to date with team progress, and step in to assist sub-teams when time allows. 


### iii. Team structure 

#### Development Team: 

* Carlos Vasqez 

* Nathen dela Torre 

The development team is responsible for essential game mechanics that make the project work. Responsibilities include implementing core gameplay mechanics such as dialogue, inventory systems, and movement 

#### Design Team: 

* Ben Snider 

* Seth Taylor 

* Philensakada Thavrin 

The design team is responsible for ensuring that the project is visually appealing and fun to the player. Responsibilities include creating art and music assets, level design, fine-tuning systems, and UI design 

#### Logistics Team: 

* Elliot Ousley 

* Hau’oli O’Brien 

The Logistics team is responsible for ensuring that the team meets its goals and communicates effectively within the team, to clients, and to management. Responsibilities include writing documentation, creating schedules, leading meetings with clients and management, and delegating tasks. 

#### Specific Roles: 

Elliot Ousley: Project Manager: Responsible for overall project coordination, task delegation, and ensuring the team meets deadlines. 

Nathen dela Torre: Gameplay Developer: Implements key game mechanics such as movement, inventory systems, and battle scenes using Godot. 

Carlos Vasquez: Backend Systems Developer: Focuses on implementing underlying game logic, data handling, and ensuring smooth integration of features like saving/loading game states. 

Ben Snider: Audio and Music Designer: Composes background music, sound effects, and ensures audio integration aligns with gameplay and player experience. 

Hau’oli O’Brien: QA Tester and Documentation Specialist: Ensures the game is thoroughly tested, tracks bugs, and documents processes for future use. 

Seth Taylor: Level Designer: Designs and builds engaging levels and environments, ensuring a seamless blend of challenge, exploration, and visual appeal. 

Philensakada Thavrin: UI/UX Designer: Create interfaces and ensures a smooth user experience by focusing on accessibility and visual clarity. 

 

### iv. Test plan & bugs 

We plan to use unit testing to test components that use complicated scripts, like the player movements system. We will test this by using Godot's built-in testing features to create scripts that test these components. By doing so, we hope to catch bugs early in the development process.

With integration testing, we plan to test how systems like the inventory and player interact with one another. We will test this by creating a separate scene to simulate gameplay scenarios in which these systems would interact.

It is essential that we conduct frequent usability testing, given that we are developing an educational game. Since our game features puzzle and RPG elements, there are many points that could lead to player confusion. This testing will be done through playtesting, in which we ask people to play our game and record their feedback.



### v. Documentation plan 

Our team plans to create a player’s guide through Github’s Wiki. As new features and parts of the story are added, we will add walkthroughs and solutions, so that players who are confused about any part of the game can refer back to the Wiki 
The in-game options menu will also provide some documentation to assist players who may be stuck. 

Additionally, we plan to include NPCs around the play area that provide hints to the player.

# 6. Use Cases

**Major Changes**

Combat System Removal: The original plan included a multiplayer combat system as a secondary gameplay mechanic. However, due to time constraints and the complexity of implementing balanced combat interactions, this feature has been removed. 

Expansion of Code Puzzles: To compensate for the removal of the multiplayer combat system, we have incorporated additional code-based challenges. These puzzles now serve as the primary progression mechanic. 

Progress Tracking & Save System: A simple save system has been implemented to track completed puzzles and game progression, allowing players to resume their journey at any time. 

### Use Case 1: Player receives a Code Quiz

Actors 
* Player: The primary character is controlled by the user. 
* Quiz Giver: An NPC (non-player character) that the player encounters. 

Triggers 
* The player interacts with a quiz giving NPC 

Preconditions 
* The NPC must be within the player's range. 

Postconditions (Success Scenario) 
* The player completes the quiz, gaining exp or loot. 
* The NPC is removed or has their dialogue changed to reflect the player's victory 

List of Steps (Success Scenario) 
1. The player selects or encounters a quiz giver to initiate a quiz. 
2. The code quiz system starts. 
3. The player types in an answer. 
4. The system calculates the outcome of the player’s action. 
5. The player loses health if their answer is incorrect. 
6. Steps 3–5 repeat until the player completes the quiz or loses all health. 
7. If the player wins, they are rewarded with exp or loot. 

Exceptions: Failure Conditions and Scenarios 
* Player Runs Out of Health: If the player’s health reaches zero, they lose the quiz and restart at a checkpoint.  


### Use Case 2: Saving and loading game progress so players can resume their game

Actors:
* The player
* The save and load system
  
Triggers: 
* Player clicks save or load game 

Preconditions:  
* The player must be in an active session to save the game  
* The player must have a saved game state in order to load a game. 
* Must have storage system in place to save game states  

Postconditions: 
* The game must be successfully saved after clicking save game 
* The player must be able to resume playing their game after it is loaded 

List of Steps: 

Saving game: 
1. Player pauses the game and selects save game 
2. System collects current game state 
3. The system serializes the collected data into a file  
4. Save file is stored in a directory  
5. Confirmation message to the player  

Loading game: 
1. The player clicks load game  
2. System displays save files  
3. Player chooses file to load 
4. The system reads and deserializes the save file  
5. The game state is restored  

Extensions: 
* Auto-Save Feature: The game periodically saves progress without player intervention. 
* Multiple Save Slots: Players can maintain and select from multiple save files. 
* Cloud Saves: Game progress is synchronized across devices using cloud storage. 

Exceptions: 

Save Error: 
* Condition: Insufficient storage space or lack of permissions. 
* Response: Display an error message ("Save Failed: Insufficient Storage"). 

Load Error: 
* Condition: Missing or corrupted save files. 
* Response: Display an error message ("Load Failed: File Not Found or Corrupted"). 

 

### Use Case 3:  Setting and replaying music and sound effects based on location and action to lend to the game’s atmosphere.
Actors
* Player  
* Entering a new area triggers the game to start playing the accompanying soundtrack. 
* Taking certain actions and interacting with certain objects will trigger sound effects, or short jingles to indicate progression. 
*Enemies/environment:* 
* Enemies will make certain noises to announce the start and end of their encounter. 
* Ambient sounds such as forest noises will help to create a greater ambiance and improve user experience. 

Triggers:  
* Soundtrack: Upon loading a new area or event, the game will check for what soundtrack corresponds to the situation and begin to play it on loop. 

Effects:  
* Certain actions taken by the player tell the game to play a specific sound effect (While walking, a crunching sound for example) once, or on repeat until the trigger action ceases. 

Preconditions: 
* Before selecting a soundtrack or sound effect, the game must verify the correct location and event trigger. 

Postconditions (success): 
* Track continues to play on repeat for as long as the player is in the triggering location. 
* Sound effect plays once and then ceases. 

List of steps: 
Soundtrack: 
1. Player enters triggering area or event. 
2. Game selects and plays accompanying soundtrack. 
3. Soundtrack continues to play as long as player is in the triggering area. Immediately stop and change soundtrack upon exiting the triggering area. 

Extension: 
* Soundtrack ends while player is still in triggering area. Repeat soundtrack. 

Exceptions (raise an error in these cases):  
* A soundtrack is expected to be played, but none exists. 
* Soundtrack does not loop while still in trigger area.  
* Soundtrack does not end upon leaving trigger area.  

Sound effect:  
* Player takes an action that triggers a sound effect (Open door, obtain item, select option in menu, etc.). 
* Game plays accompanying sound effect one time. 
* Sound effect ends, continue monitoring for more sound effect triggers. 

Exceptions:  
See soundtrack exceptions. In addition: 
* Sound effect repeats instead of playing just once. 


### Use case 4: Solving a mini learning challenge to “unlock” more parts of the game, or advance to a new level.

Triggers:
The player reaches a certain point in the game (i.e a locked door) and will need to complete a challenge to advance to the next level or portion of the game. 

Preconditions:  
* The player must have access to the game/coding challenge interface 
* The challenge is generated and displayed to the users with all proper instructions needed for them to solve and advance. 
* The player must have completed any prior challenges or quests such as gathering clues or tips (these can be collected before the challenge to help them solve the challenge to advance) 

Postconditions (success scenario): 
* The challenge is solved correctly and the player advances to a new level  
* The player receives in-game rewards as part of doing the challenge correctly and advancing 

List of Steps (success scenario): 
1. The player finds themself at a checkpoint which triggers the challenge to come up (challenge interface) 
2. The challenge is presented to the user, requiring the player to solve in order to continue 
3. The player completes the challenge successfully and submits their answer/solution 
4. The system checks for the right solution 
5. If correct, player advances to next level and receives rewards 

Extensions:  
* The player completes the challenge but with multiple attempts, which reduces the player's health upon a failed guess  

Exceptions:  
* Maximum 3 attempts at solving the challenge or else players will have to go back and collect hints then re-attempt the challenge 
 
### Use Case 5: NPC Dialogue

Actors: 
* Player – The program’s user 
* Non-Player Character – An in-game character that gives the player hints through the game’s dialogue system 

Triggers 
* The player interacts with a friendly Non-Player Character  

Preconditions: 
* The Player is in an area with friendly Non-Player Characters present 
* The Non-Player Character has written dialogue 
 
Postconditions (success scenario): 
* The player receives information, hints, or objectives from talking to the Non-Player Character 

List of steps (success scenario) 
1. The player approaches a Non Player Character and presses the interact button 
2. The dialogue system provides the player with a list of 0-3 dialogue options 
3. The player selects a dialogue option 
4. The Non-Player Character responds with pre-programmed dialogue 
5. The Non-Player Character ends the dialogue, or provides more dialogue options for larger dialogue trees, returning to step 2 

Extensions/variations of the success scenario 
* Multiple dialogue paths – The player may be presented with more than one dialogue choice, with more branching off of that. 
* Challenges within dialogue – A Non-Player Character may challenge a player with a coding challenge or combat 

Exceptions: failure conditions and scenarios 
* Missing Prerequisites – The player has not achieved a certain goal or obtained a certain item that would open up dialogue trees. 


### Use Case 6: Use Item from Inventory

Actors: 
* Player: The program’s user. 
* System: Game inventory and equipment system. 

Triggers: 
* The player opens the inventory menu. 

Preconditions: 
* The player has at least one usable item in their inventory. 
* The inventory menu is accessible via the game’s UI. 

Postconditions (Success Scenario): 
* The item is successfully used, activating an effect like restoring health (if applicable). 
* The item is removed from the player's inventory. 

List of Steps (Success Scenario): 
1. Player presses a designated button to open the inventory menu. 
2. System displays the inventory UI, showing all items. 
3. Player selects an usable item (e.g., potion) from the list. 
4. Player confirms the selection to use the item. 
5. System updates the character’s stats based on the item’s attributes. 
6. System deletes the item. 
7. Player exits the inventory menu and returns to gameplay. 

Extensions/Variations of the Success Scenario: 
* The player uses filters to quickly view specific categories (e.g., only potions). 

Exceptions: Failure Conditions and Scenarios: 
* Invalid Item Type: Player tries to use an item that has no special characteristics.

## Non-functional Requirements 

1. The game should be responsive, taking no less than 2 seconds to switch between scenes 
2. The game should be able to save the user’s progress, so that they do not lose progress when quitting 
3. The game should allow users to customize their experience with a settings menu 

## External Requirements 

1. The game must be resilient and avoid all crashes. 
2. The game must be easy to install, using Godot’s export system to create a Windows build 
3. The project must be resilient against scope creep to ensure that all goals are reachable. 

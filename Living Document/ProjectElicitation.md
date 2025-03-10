# Project Requirements Elicitation 

## 1. Use Cases (Functional Requirements)  

#### Seth 

**Use Case 1: Player Battles an Enemy**

Actors 
* Player: The primary character is controlled by the user. 
* Enemy: An NPC (non-player character) that the player encounters. 

Triggers 
* The player enters an area with enemies or initiates combat with an enemy by interacting with it. 

Preconditions 
* The enemy must be alive and within the player's range for combat initiation. 

Postconditions (Success Scenario) 
* The player defeats the enemy, gaining exp or loot. 
* The enemy's health reaches zero, and it is removed from the active area. 

List of Steps (Success Scenario) 
1. The player selects or encounters an enemy to initiate combat. 
2. The battle system starts. 
3. The player chooses an action, such as attacking, defending, using an item, or fleeing. 
4. The system calculates the outcome of the player’s action based on stats, abilities, or random chance. 
5. The enemy performs its action (if not defeated). 
6. Steps 3–5 repeat until the player or the enemy is defeated. 
7. If the player wins, they are rewarded with exp or loot. 

Extensions/Variations of the Success Scenario 
* Critical Hits: Certain actions have a chance of inflicting extra damage. 
* Status Effects: Actions can cause effects like poisoning, freezing, or paralysis. 

Exceptions: Failure Conditions and Scenarios 
* Player Runs Out of Health: If the player’s health reaches zero, they lose the battle and might restart at a checkpoint. 
* Failed Escape Attempt: If the player tries to flee but the escape fails, the enemy attacks again. 

#### Nathen 

#### Carlos 

**Use Case 3: Saving and loading game progress so players can resume their game**

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

 

 

#### Ben 

**Use Case 4:  Setting and replaying music and sound effects based on location and action to lend to the game’s atmosphere.** 

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

#### Hau’oli: 

**Use case 5: Solving a mini learning challenge to “unlock” more parts of the game, or advance to a new level.**

Triggers:
The player reaches a certain point in the game (i.e a locked door) and will need to complete a challenge to advance to the next level or portion of the game. Depending on overall game, trigger could also be losing a battle, need to solve challenge to revive. 

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
* The player completes the challenge but with multiple attempts, which reduces the amount of rewards they can receive  

Exceptions:  
* Maximum 3 attempts at solving the challenge or else players will have to go back and collect hints then re-attempt the challenge 
 
#### Elliot 

**Use Case 6: NPC Dialogue **

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

#### Philensakada 

**Use Case 7: Equip Item from Inventory**

Actors: 
* Player: The program’s user. 
* System: Game inventory and equipment system. 

Triggers: 
* The player opens the inventory menu during exploration or between battles. 

Preconditions: 
* The player has at least one equippable item in their inventory. 
* The inventory menu is accessible via the game’s UI. 

Postconditions (Success Scenario): 
* The item is successfully equipped, updating the character’s stats and appearance (if applicable). 
* The inventory menu reflects the equipped item, and the previously equipped item (if any) is unequipped. 

List of Steps (Success Scenario): 
1. Player presses a designated button to open the inventory menu. 
2. System displays the inventory UI, showing all items. 
3. Player selects an equippable item (e.g., sword) from the list. 
4. Player confirms the selection to equip the item. 
5. System updates the character’s stats based on the item’s attributes. 
6. System marks the item as equipped and unequips any conflicting item. 
7. Player exits the inventory menu and returns to gameplay. 

Extensions/Variations of the Success Scenario: 
* The player uses filters to quickly view specific categories (e.g., only weapons). 

Exceptions: Failure Conditions and Scenarios: 
* Invalid Item Type: Player tries to equip an item incompatible with their character:  

## 2. Non-functional Requirements 

1. The game should be responsive, taking no less than 2 seconds to switch between scenes 
2. The game should be able to save the user’s progress, so that they do not lose progress when quitting 
3. The game should allow users to customize their experience with a settings menu 

## 3. External Requirements 

1. The game must be resilient and avoid all crashes. 
2. The game must be easy to install, using Godot’s export system to create a Windows build 
3. The project must be resilient against scope creep to ensure that all goals are reachable. 

## 4. Team process description 

#### Toolset 
* Godot will be used to develop this project. Godot is a free, open-source, easy to pick-up engine that is primarily used for 2-dimensional games, like this project. 
* GitHub will be used for version control. It is the standard for developing games on Godot and allows for teams to work together effectively. 

#### Team Member Roles 

**Development Team:** 
* Carlos Vasqez 
* Nathen dela Torre 

The development team is responsible for the most essential game mechanics that make the project work. Responsibilities include implementing core gameplay mechanics such as dialogue, inventory systems, movement, and battle scenes. 

**Design Team:** 
* Ben Snider 
* Seth Taylor 
* Philensakada Thavrin 

The design team is responsible for ensuring that the project is visually appealing and fun to the player. Responsibilities include creating art and music assets, level design, fine-tuning systems, and UI design 

**Logistics Team:** 
* Elliot Ousley 
* Hau’oli O’Brien 

The Logistics team is responsible for ensuring that the team meets its goals and communicates effectively within the team, to clients, and to management. Responsibilities include writing documentation, creating schedules, leading meetings with clients and management, and delegating tasks. 

#### Development Schedule 

**Development team:**
* Week 3: Polish existing movement system and create save system 
* Week 4: Implement dialogue system 
* Week 5: Implement placing blocks in ui 
* Week 6: Implement code block functionality 
* Week 7: Create battle system 
* Week 8: Polish and test code block system 
* Week 9: Implement battle system stretch goals 
* Week 10: Final Testing
  
**Design Team:** 
* Week 3: Create tile map and two NPC sprites 
* Week 4: Design UI for dialogue and inventory systems 
* Week 5: Design UI for code block puzzles and make prototypes for levels 
* Week 6: Create levels and environments and design code block puzzles 
* Week 7: Create or find appropriate music and sound effects 
* Week 8: Create UI and sprites for battle system 
* Week 9: Create sprites for NPC Dialogue 
* Week 10: Final Testing 

**Logistics Team:**
* Every Week:  write documentation, set up meetings, communicate with project managers, keep up to date with team progress, and step in to assist sub-teams when time allows. 

#### Major Risks 

**Scope Creep:** 
Scope management is an important part of game development. The scale of the project must be controlled to prevent wasted work and unreachable goals. If the scope of the project gets too large, major parts of the project may be missing essential features that affect the player experience. 

**Inexperience:** 
While all members of the team have experience with programming, they do not have experience with GDScript or the Godot engine. Because of this, learning and project development must be done at the same time, which could lead to mistakes. 

**Playtesting and Bug fixing:** 
To ensure that players have a positive experience with this project, it is essential that members test to ensure that the game is interesting, not too difficult, and free of bugs. 

#### External Feedback 

Our project team will ask others outside of the team to test the game and give feedback at least once every two weeks. This outside feedback will allow us to polish puzzles, combat encounters, and other gameplay mechanics to provide the best player experience possible. 

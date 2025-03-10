## Team 11 - Codequest
Seth Taylor, Elliot Ousley, Nathen dela Torre, Carlos Vasquez, Ben Snider, and Hau’oli O’Brien

# Final Living Document

# 1. Project Problem and Solution 

## Abstract:
It's a common issue for new programmers to struggle with staying motivated learning programming. Often, learning can feel like a chore, and access to educational resources can be hindered by paywalls.
CodeQuest aims to make learning engaging by integrating coding concepets into an RPG-style game, where players earn incentives for solving problems that teach a programming mindset. 
Our solution leverages a well-structured architecture with a game loop, UI integration, and a challenge validation system, ensuring an engaging and educational experience.
Testing will include user engagement analysis, success rates of coding challenges, and gameplay balancing metrics to validate the effectiveness of our approach. 

## Goal:  

For someone with no knowledge on the subject, learning programming can seem like an incredibly daunting task. This project seeks to gamify the process of learning to make it accessible to people who may feel intimidated by other options. 

## Current practice: 

Current beginner friendly code learning tools like Codecademy throw their users directly into programming, which can seem overwhelming to their users. W3Schools provides large blocks of text and quizzes, which can turn away new users. Most solutions to this problem charge monthly subscription fees, which can range from fairly reasonable, in the case of Codecademy Pro at around 40 dollars a month, to completely unaffordable, in the case of HackerRank’s 200-450 dollar a month fee. These high prices can turn people away from learning new skills. 

## Novelty:  

With this project, we seek to gamify the process of learning code in a way that puts fun as the priority. By turning programming into a game mechanic, rather than the complete focus of the game, it makes the process of learning basic code concepts much more approachable. With this approach of incorporating education into the gameplay experience, players can learn in a much easier way. 

## Effects: 

This project will make programming more accessible to people who feel intimidated by wordy, expensive, or complicated code learning platforms. By engaging with this project, these people will gain some confidence, which can allow them to seek out further skills. Programming is a skill that everyone should have, and we should therefore make it as accessible as possible. 

# 2. Software architecture 

### Major Components
* User Interface - provides players with interactive elements such as menus, inventory, settings, and dialogue, ensuring an accessible and user-friendly experience.  

* Game Scene - acts as the primary environment where gameplay takes place, allowing players to navigate, interact with objects, and engage in various challenges.  

* Dialogue System - facilitates communication between players and non-player characters (NPCs) using Area2D nodes to trigger conversations.  

* Code Puzzle System - enables coding challenges, validates player input, and provides real-time feedback.  

* Save System - ensures that player progress and game configurations are stored and retrieved efficiently using user files and configuration settings. 

## Event-Driven Architecture

Godot utilizes an event-driven architecture where interactions between game components occur through signals and event handlers. This approach enhances modularity and decouples components, enabling more scalable and maintainable development.

### Core Elements of Our Event-Driven System

### 1. Event Producers (Emitters)

These are nodes that generate events in response to player actions or game state changes.

* UI Components (Buttons, Menus): Emit signals when interacted with.
  
* Player Interactions: Emit signals when interacting with in-game objects.
  
* Dialogue Triggers: Emit signals when a player enters an Area2D node.
  
* Item Pickups: Emit signals when a player collects an item.
  
* Code Puzzle Interactions: Emit signals when a player interacts with a coding puzzle object.
  
* Game State Changes: Emit signals when the game state changes, such as level completion or player progression.


### 2. Event Consumers (Listeners)

These are nodes that listen for emitted signals and perform corresponding actions:

* UI Handlers: Update UI elements when triggered.
  
* Dialogue System: Starts conversations when the player interacts with an NPC.
  
* Inventory System: Updates inventory when an item is collected.
  
* Game Progression Manager: Saves progress and updates the game state.
  
* Code Puzzle System: Processes code inputs and checks for correctness.
  
* Save NPC: Listens for player interaction to trigger the save functionality.
  

### 3. Event Channels (Signal Transmission)

* Godot uses signals to pass information between nodes asynchronously:
  
* Node-Based Signaling: Signals emitted from a node are connected to specific functions in other nodes via scripts.
  
* Global Event Bus (Singletons): Some global signals handle cross-scene communication for game state changes, like transitioning between levels or updating UI elements.
  
* Queued Signals: Some signals are queued to ensure processing in a specific order.


### Advantages of Our Event-Driven Approach

* Loose Coupling: Components don’t need direct references to each other, improving modularity.
  
* Asynchronous Processing: Enhances performance and responsiveness by allowing independent event handling.
  
* Scalability: Makes it easy to add new features without modifying existing systems.
  
* Flexibility: Supports both simple interactions (button clicks) and complex systems (code puzzles and dialogues).

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

* Cross-Platform Support: Offers extensive support for multiple platforms, including PC, mobile, and consoles.

* Asset Store: Provides a vast library of assets and plugins that can accelerate development.

Cons: 

* Performance Overhead: Unity can be resource-intensive, especially for smaller-scale projects.

* Complex Licensing: Some features are locked behind paid licenses.


#### Unreal Engine 

Pros: 

* High-Quality Graphics: Unreal Engine includes advanced rendering capabilities suitable for AAA-quality visuals.
  
* Visual Coding: Unreal allows for games to be developed using a visual code format, which may be easier

* Strong Built-in Tools: Includes physics engines, animation tools, and AI systems.

Cons: 

* Heavy on Resources: Requires powerful hardware for development and testing.

* Steeper Learning Curve: More complex than Unity, making it harder for beginners.

* Best for 3D: While capable of 2D, it is optimized for 3D game development.


Instead of GDScript, the game could be developed using C++ or C+ 


#### C++ 

Pros: 

* Familiarity: Most of the team has used C++ to develop projects in previous classes
  
* Performance: Provides high execution speed and efficiency.

Cons: 

* Lack of support: While Godot allows C++ to be used to develop games, the support for it is fairly weak, as C# and GDScript are preferred 

* Lack of Documentation: Many parts of the Godot Documentation do not have anything listed for C++ 

* Complexity: More difficult to debug and maintain compared to GDScript or C#.

  
#### C# 

Pros: 

* Supported: While it doesn’t have as much support as GDScript, C# is fairly well supported within the documentation and in-editor. 

* Good Performance: Faster than GDScript while being easier to use than C++.
  
* Strong Typing: Reduces the likelihood of runtime errors.

Cons: 

* Newer Addition: C# support in Godot is still evolving, with fewer resources available compared to GDScript.

* Larger Executable Size: Can result in slightly larger game builds compared to GDScript.
* 

### Component Parts 

Godot abstracts components as nodes and scenes, where scenes are a collection of nodes. Currently, our game uses the following scenes: 

* Main Scene - The primary game environment where players interact with the world.

* Player Scene - Controls the player character and its related functions. 

* Main Menu Scene - Provides navigation to start the game, load saves, or access settings.

* Options Scene - Allows players to adjust game settings, including controls and audio. 

* NPC Scene - Manages non-player characters and their behaviors.  


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

**Assets:**
Visuals are a large part of games, so a lot of image files are used in game development. In having so many images, there is a risk that some may be inconsistent, missing, or broken. This issue has a medium likelihood of occurring, and a high impact on the project, as missing assets are very noticeable, and must be fixed as soon as possible. This risk can be minimized by having a clear file structure with consistent file names.

**Platform compatibility:**
We plan to release our game as an executable and a web application. This can cause issues, as games made in Godot can act differently on different platforms. This can lead to unforseen bugs that may not be caught in testing. This issue has a high likelihood of occurring, and has a high impact on the project. This can be minimized by building and testing often.

**Finding the fun:**
While having good art assets and complicated systems can help with a user’s experience,
players will not play games that are not fun, no matter how technically impressive or visually appealing it is.
As such, we must identify what parts of our game are interesting and enjoyable, and develop those with more attention.
This issue has a medium likelihood of occurring, but will not affect project completion. It will, however, 
affect the final product if fun mechanics are not identified. This issue can be minimized by running frequent
playtesting to get feedback on what others find fun. 

**Optimization:**
As the project is developed and systems interact, the performance of the game may be impacted, which could make it unusable to people with less powerful computers. This issue has a fairly high likelihood of occurring, as we are new to game development, and has a medium impact. This risk can be minimized through frequent checks on performance, keeping art assets small, and optimizing code when possible.

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
| Week 10 | Write tests for major components and fix bugs | Write tests for major component and fix bugs |

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

We plan to use unit testing to test components like travel gates, NPCs, the player, and code block puzzles. We will test this by using Godot's built-in testing features to create scripts that test these components. By doing so, we hope to catch bugs early in the development process.

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

# 7. Reflections:

### Carlos:
Working on CodeQuest has been a real learning experience for me, both in teamwork and the technical side of game development. At the beginning, our team struggled with communicating and sharing updates. We had trouble finding a good way to communicate, and that made it hard to know what everyone was working on. Eventually, we set up a text group and used Microsoft Teams to share files and meeting notes, and that helped us get on track.

I also had a hard time getting used to Godot. Learning how to work with nodes, scenes, and GDScript was challenging at first. I spent a lot of time reading documentation and trying out small projects just to understand how everything worked together. Even though it was frustrating at times, I learned a lot and grew more confident as I got the hang of it.

Another challenge we faced was with merging branches in Git. At first, we ran into a lot of trouble because we accidentally pushed all of the cache files into the repository. This made merging branches a real headache. Eventually, I took the time to clean out the cache files and set up a proper .gitignore file to keep them out of the repository. This change made our work much smoother and helped us avoid similar issues in the future.

Working on this project taught me a lot about working in a larger team on a bigger project. I learned how important it is to coordinate our efforts, stay organized, and support each other when problems come up. Managing a project like this showed me that clear communication and planning are key to making sure everyone is on the same page.

Overall, these challenges taught me to be patient, to keep learning, and to value teamwork. I'm happy with how our team improved over time, and I'm proud of what we achieved with CodeQuest.

### Elliot:

#### 1. Communication:
Throughout our project, we had some difficulties with communication. Eventually, we settled on a text group for communication and a Microsoft Team for files, announcements, meeting notes, and updates. Not having an effective method of communication made the first part of the project difficult, since we had to find each other in class to talk about important updates.

#### 2. Coordination:
Through this project, I learned the importance of coordination and keeping track of everything that must be done. There was a week where I forgot to sign up for a meeting, in which we had to schedule a last-minute meeting at a time when almost no team members were available. I took this mistake to heart, creating to-do lists and writing everything down, even if I believed I would remember it later.

#### 3. Story
We started this game with only game mechanics in mind. This created some issues once we had game mechanics implemented, because we had no planned story or level designs to create. If we were to do this project again, I would create a story early in the development process so that we would be able to take it into account for dialogue and level design.

### Hau'oli:
Throughout this project, I learned a lot about not only how to work on large-scale projects like this but also how to collaborate effectively within a team. Coordinating tasks, ensuring deadlines are met, and maintaining clear communication were crucial challenges, and I saw firsthand how important it is to keep everyone aligned. This became especially evident through CodeQuest, where we had to consistently discuss our progress, problem-solve together, and make sure everyone was on track. Strong communication was key to approaching obstacles and finding solutions efficiently.

On the technical side, I gained hands-on experience with Godot, which deepened my understanding of game development, particularly in the RPG genre. Before this project, I had little exposure to RPGs—I hadn't played them or taken much interest in them—but working on CodeQuest sparked my curiosity. As we built the game, I developed a better grasp of what makes an RPG engaging, from game mechanics and progression systems to player interaction and storytelling. Now that the project is wrapping up, I feel much more confident about where to start when developing an RPG and the essential elements needed to make it successful. This experience has not only expanded my technical skills but also reshaped my perspective on game design and collaboration.  

### Seth:
This class was definatly more dificult than I originally expected. This was the first real video game I worked on and it was a huge learing experience both in working in a bigger team and learning how to develope a game. I think that the hardest part was the lack of initial communication but after we were able to surpass that things got much easier. If I was going to do something like this again I would push harder to use a language and engine that I had more expeieince with as godot was really hard for me to understand. Overall I'm glad that I was able to get this experience even thought it was quite dificult at times.

### Nathen:
This project was a significant learning experience for a Software Engineer's end-to-end process. We started by setting up a way to communicate through Microsoft Teams and text messages, creating a code repository to allow us to have version controls, learning Godot, and implementing tests to test our code to ensure its reliability automatically. 
Communication during this project had a rough start, but we were able to find a good way to communicate with each other and share our progress. 
The GitHub code repository allowed me to see how a team of Software Engineers works together. Initially, I was still getting the hang of it and had many merge conflicts. But after a bit of communication, there was a lot more coordination of the pushes to the repo. 
Godot and game development in general were new to me, so there was definitely a high learning curve at the beginning. But after watching tutorials and looking at the Godot documentation, I was able to get a better understanding of the game engine. 
Before this class, I had done minimal unit testing implementation. However, through the lectures and homework, I was able to understand how to implement a CI/CD pipeline with Github's action to be able to automatically conduct a unit test. 

### Ben:


# 1. Use Cases (Functional Requirements)

Each team member must come up with and describe at least one use case of your product, following this template:

- **Actors**
- **Triggers**
- **Preconditions**
- **Postconditions (success scenario)**
- **List of steps (success scenario)**
- **Extensions/variations of the success scenario**
- **Exceptions: failure conditions and scenarios**

(At the end of this step you will have at least one use case per team member.)

### 1. Seth

**Use Case:** Player Battles an Enemy

- **Actors**
  - Player: The primary character is controlled by the user.
  - Enemy: An NPC (non-player character) that the player encounters.

- **Triggers**
  - The player enters an area with enemies or initiates combat with an enemy by interacting with it.

- **Preconditions**
  - The enemy must be alive and within the player's range for combat initiation.

- **Postconditions (Success Scenario)**
  - The player defeats the enemy, gaining exp or loot.
  - The enemy's health reaches zero, and it is removed from the active area.

- **List of Steps (Success Scenario)**
  1. The player selects or encounters an enemy to initiate combat.
  2. The battle system starts.
  3. The player chooses an action, such as attacking, defending, using an item, or fleeing.
  4. The system calculates the outcome of the player’s action based on stats, abilities, or random chance.
  5. The enemy performs its action (if not defeated).
  6. Steps 3–5 repeat until the player or the enemy is defeated.
  7. If the player wins, they are rewarded with exp or loot.

- **Extensions/Variations of the Success Scenario**
  - Critical Hits: Certain actions have a chance of inflicting extra damage.
  - Status Effects: Actions can cause effects like poisoning, freezing, or paralysis.

- **Exceptions: Failure Conditions and Scenarios**
  - Player Runs Out of Health: If the player’s health reaches zero, they lose the battle and might restart at a checkpoint.
  - Failed Escape Attempt: If the player tries to flee but the escape fails, the enemy attacks again.

### 2. Nathen

### 3. Carlos

**Use Case:** Saving and loading game progress so players can resume their game

- **Triggers:**
  - Player clicks save or load game.

- **Preconditions:**
  - The player must be in an active session to save the game.
  - The player must have a saved game state in order to load a game.
  - Must have a storage system in place to save game states.

- **PostConditions:**
  - The game must be successfully saved after clicking save game.
  - The player must be able to resume playing their game after it is loaded.

- **List of Steps:**

  - **Saving game:**
    1. Player pauses the game and selects save game.
    2. System collects current game state.
    3. The system serializes the collected data into a file.
    4. Save file is stored in a directory.
    5. Confirmation message to the player.

  - **Loading game:**
    1. The player clicks load game.
    2. System displays save files.
    3. Player chooses file to load.
    4. The system reads and deserializes the save file.
    5. The game state is restored.

- **Extensions:**
  - Auto-Save Feature: The game periodically saves progress without player intervention.
  - Multiple Save Slots: Players can maintain and select from multiple save files.
  - Cloud Saves: Game progress is synchronized across devices using cloud storage.

- **Exceptions:**
  - **Save Error:**
    - **Condition:** Insufficient storage space or lack of permissions.
    - **Response:** Display an error message ("Save Failed: Insufficient Storage").
  
  - **Load Error:**
    - **Condition:** Missing or corrupted save files.
    - **Response:** Display an error message ("Load Failed: File Not Found or Corrupted").

### 4. Ben

### 5. Hau’oli

**Use case:** Solving a mini learning challenge to “unlock” more parts of the game, or advance to a new level.

- **Triggers:** The player reaches a certain point in the game (i.e., a locked door) and will need to complete a challenge to advance to the next level or portion of the game. Depending on overall game, trigger could also be losing a battle, need to solve challenge to revive.

- **Preconditions:**
  - The player must have access to the game/coding challenge interface.
  - The challenge is generated and displayed to the users with all proper instructions needed for them to solve and advance.
  - The player must have completed any prior challenges or quests such as gathering clues or tips (these can be collected before the challenge to help them solve the challenge to advance).

- **Postconditions (Success Scenario):**
  - The challenge is solved correctly and the player advances to a new level.
  - The player receives in-game rewards as part of doing the challenge correctly and advancing.

- **List of Steps (Success Scenario):**
  1. The player finds themself at a checkpoint which triggers the challenge to come up (challenge interface).
  2. The challenge is presented to the user, requiring the player to solve in order to continue.
  3. The player completes the challenge successfully and submits their answer/solution.
  4. The system checks for the right solution.
  5. If correct, the player advances to the next level and receives rewards.

- **Extensions:**
  - The player completes the challenge but with multiple attempts, which reduces the amount of rewards they can receive.

- **Exceptions:**
  - Maximum 3 attempts at solving the challenge or else players will have to go back and collect hints then re-attempt the challenge.

### 6. Elliot

**Use Case 6:** NPC Dialogue

- **Actors:**
  - Player – The program’s user.
  - Non-Player Character – An in-game character that gives the player hints through the game’s dialogue system.

- **Triggers:**
  - The player interacts with a friendly Non-Player Character.

- **Preconditions:**
  - The player is in an area with friendly Non-Player Characters present.
  - The Non-Player Character has written dialogue.

- **Postconditions (Success Scenario):**
  - The player receives information, hints, or objectives from talking to the Non-Player Character.

- **List of Steps (Success Scenario):**
  1. The player approaches a Non-Player Character and presses the interact button.
  2. The dialogue system provides the player with a list of 0-3 dialogue options.
  3. The player selects a dialogue option.
  4. The Non-Player Character responds with pre-programmed dialogue.
  5. The Non-Player Character ends the dialogue, or provides more dialogue options for larger dialogue trees, returning to step 2.

- **Extensions/Variations of the Success Scenario:**
  - Multiple dialogue paths – The player may be presented with more than one dialogue choice, with more branching off of that.
  - Challenges within dialogue – A Non-Player Character may challenge a player with a coding challenge or combat.

- **Exceptions: Failure Conditions and Scenarios:**
  - Missing Prerequisites – The player has not achieved a certain goal or obtained a certain item that would open up dialogue trees.

### 7. Philensakada

# 2. Non-functional Requirements

1. The game should be responsive, taking no less than 2 seconds to switch between scenes.
2. The game should be able to save the user’s progress so that they do not lose progress when quitting.
3. The game should allow users to customize their experience with a settings menu.

# 3. External Requirements

In addition to the requirements stated above, the course staff imposes the following requirements on your product:

- The product must be robust against errors that can reasonably be expected to occur, such as invalid user input.
- The product must be installable by a user, or if the product is a web-based service, the server must have a public URL that others can use to access it. If the product is a stand-alone application, you are expected to provide a reasonable means for others to easily download, install, and run it.
- The software (all parts, including clients and servers) should be buildable from source by others. If your project is a web-based server, you will need to provide instructions for someone else setting up a new server. Your system should be well-documented to enable new developers to make enhancements.
- The scope of the project must match the resources (number of team members) assigned.

Make sure that these requirements, if applicable to your product, are specialized to your project and included in your document—do not copy and paste these requirements verbatim. You may leave this as a separate section or fold its items into the other requirements sections.

# 4. Team Process Description

### Development Process
Describe your quarter-long development process.

### Software Toolset
Specify and justify the software toolset you will use:
- **Godot** will be used to develop this project. Godot is a free, open-source, easy-to-pick-up engine that is primarily used for 2-dimensional games, like this project.
- **GitHub** will be used for version control. It is the standard for developing games on Godot and allows for teams to work together effectively.

### Define and justify each team member’s role: why does your team need this role filled, and why is a specific team member suited for this role?

#### Development Team:
- Carlos Vasquez
- Nathen dela Torre

The development team is responsible for the most essential game mechanics that make the project work. Responsibilities include implementing core gameplay mechanics such as dialogue, inventory systems, movement, and battle scenes.

#### Design Team:
- Ben Snider
- Seth Taylor
- Philensakada Thavrin

The design team is responsible for ensuring that the project is visually appealing and fun to the player. Responsibilities include creating art and music assets, level design, fine-tuning systems, and UI design.

#### Logistics Team:
- Elliot Ousley
- Hau’oli O’Brien

The Logistics team is responsible for ensuring that the team meets its goals and communicates effectively within the team, to clients, and to management. Responsibilities include writing documentation, creating schedules, leading meetings with clients and management, and delegating tasks.

### Provide a schedule for each member (or sub-group) with a measurable, concrete milestone for each week. "Feature 90% done" is not measurable, but "use case 1 works, without any error handling" is.

#### Development Schedule

Milestones accomplished:
- Seth Taylor: Identified Use case 1 and created a plan as to how to implement it.
- Elliot Ousley: Identified Use case 6 and created a plan as to how to implement it.
- Nathen dela Torre:
- Carlos Vasquez: Identified Use case 3 and created a plan as to how to implement it.
- Ben Snider:
- Hau’oli O’Brien: Identified Use case 5 and created a plan as to how to implement it.
- Philensakada Thavrin:

#### Major Risks

- **Scope Creep** – Scope management is an important part of game development. The scale of the project must be controlled to prevent wasted work and unreachable goals. If the scope of the project gets too large, major parts of the project may be missing essential features that affect the player experience.
  
- **Inexperience** – While all members of the team have experience with programming, they do not have experience with GDScript or the Godot engine. Because of this, learning and project development must be done at the same time, which could lead to mistakes.

- **Playtesting and Bugfixing** – To ensure that players have a positive experience with this project, it is essential that members test to ensure that the game is interesting, not too difficult, and free of bugs.

#### External Feedback

Our project team will ask others outside of the team to test the game and give feedback at least once every two weeks. This outside feedback will allow us to polish puzzles, combat encounters, and other gameplay mechanics to provide the best player experience possible.
```

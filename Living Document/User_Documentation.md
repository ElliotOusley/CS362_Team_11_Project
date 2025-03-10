# User Documentation


## 1. High-Level Description

**Project Name: CodeQuest**  
CodeQuest is a 2D puzzle/RPG hybrid created in Godot. It’s designed to help players learn programming concepts by solving coding puzzles in a fun, interactive environment. Players explore a story-driven world, solve short coding challenges, and unlock new areas as they progress.  

### Why Would a User Want To Use It?
- **Engaging Gameplay**: Combines RPG elements (dialogue, item usage, progression) with coding puzzles.  
- **Educational**: Reinforces coding concepts in a hands-on manner.  
- **Accessible**: Designed for learners at various skill levels, offering multiple hints and attempts.  



## 2. How to Install the Software

**Prerequisites**  
   - **Godot 4.x** if running from source.  
   - If you’re using the compiled release version for Windows, you’ll just need to download and extract the `.zip` from our GitHub Releases page.  

**Installation Steps (From Source)**  
   - **Step 1**: Clone the repository  
     ```bash
     git clone https://github.com/ElliotOusley/CS362_Team_11_Project
     ```
   - **Step 2**: Open Godot Engine and select `Import` to load the project.godot file.

**Installation Steps (Binary Download)**
   - **Step 1**: Navigate to the [Releases](https://github.com/ElliotOusley/CS362_Team_11_Project/releases) section of the repository.  
   - **Step 2**: Download the latest stable build for your OS.
   - **Step 3**: Extract the files into a folder of your choice.


 **Installation Steps (Itch.io Page)**
   - **Step 1**: Navigate to our [itch.io page](https://elliot-ousley.itch.io/codequest)
   - **Step 2**: Scroll down to the downloads section and select the Windows version
   - **Step 3**: Extract the file into a folder of your choice



## 3. How to Run the Software

- **From Godot**  
  - Open the project in Godot.  
  - Click the "Play" button at the top right or press **F5**.  

- **From Downloaded Executable**  
  - Double-click the `CodeQuest.exe` (Windows) or run the equivalent script on Mac/Linux.  
  - The game should launch in a new window.
 
  - **VS Code Integration**
  - **Step 1**: Set up GitHub Desktop by downloading here: [GitHub Desktop download](https://github.com/apps/desktop)
   - **Step 2**: Clone the CS362_Team_11_Project Repo using the link.
   - **Step 3**: Navigate to VS Code. If you need the download, find it here: https://code.visualstudio.com/
   - **Step 4**: Install the Godot Tools extension in VS Code [Here](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools)
   - **Step 5**: Run seamlessly using normal launch methodology.



## 4. How to Use the Software

1. **Starting a New Game**  
   - Upon launch, you’ll see a main menu with options: **Start Game**, **Load Game**, **Options**, **Exit**.  
   - Choose **Start Game** to begin.
   - Load game will load a previous game that was paused or abandoned from a previous usage.
   - When clicking options, users have the ability to control sound effects, brightness, font size.

2. **Movement & Interaction**  
   - Move your character using arrow keys or WASD.  
   - Interact with NPCs or objects by pressing `E`.  

3. **Dialogue & Quests**  
   - Talk to NPCs to receive quests and coding puzzles.  
   - Dialogue options may branch, leading to different hints or tasks.  

4. **Coding Challenges**  
   - Approach a puzzle challenge or puzzle NPC to begin a challenge.  
   - Use the coding clocks to build a solution to the programming puzzle.  
   - Submit to check correctness; if wrong, you will lose some in-game health.
   - Players have 3 lives or attempts to answer the question correctly before they have to start the process over again. 

5. **Saving & Loading**  
   - Access the **Pause** menu (`Esc` key) to **Save** or **Load** your progress.  
   - The game automatically creates a save file in your user directory (platform-dependent)
   - Users can return to a saved game by clicking "load game" from main menu options.

6. **Missing Features (Work in Progress)**  
   - **Battle System**: We decided to remove real-time combat due to time constraints; we may add simpler puzzle-combat mechanics in the future.  
   - **Additional Puzzles**: Some puzzle areas are placeholders with “Coming Soon!” text.
   - **Leadership Board**: In lieu of removing the combat battle system, we may decide to implement a leadership board to show rankings based on coding block challenges completed.



## 5. How to Report a Bug

We use **GitHub Issues** for bug reporting: [Issues Page](https://github.com/ElliotOusley/CS362_Team_11_Project/issues)

**Guidelines to follow:**
- **Title**: Use a short description of the bug.  
- **Steps to Reproduce**: List them clearly so we can recreate the issue.  
- **Expected vs. Actual Results**: State what you expected to happen and what actually happened.  
- **Environment Details**: Include your operating system, Godot version, or binary version.
- **Be Specific**: Recall everything that happened leading up to discovering a bug so we can figure out exactly how it was triggered. 

We follow the [Mozilla Bug Writing Guidelines](https://developer.mozilla.org/en-US/docs/Mozilla/QA/Bug_Writing_Guidelines). Key points:

1. **Clear Summary**: A concise, 1-line summary of the issue.  
2. **Precise Steps**: How to make it happen every time, if possible.  
3. **Expected vs Actual Results**: Distinguish between what should happen and what did.  
4. **Additional Info**: Screenshots, logs, or crash dumps help us fix the bug faster.



## 6. Known Bugs

Please refer to our [GitHub Issues](https://github.com/ElliotOusley/CS362_Team_11_Project/issues) for a current list of bugs and their status.




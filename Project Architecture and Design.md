# 1. Software architecture 

### Major Components
* User Interface – An overlay on top of the game scene that allows players to interact with game systems like inventory, options, the main menu, and dialogue 
* Game Scene – Where gameplay takes place. Includes scenes like main, the player, NPCs, and tilemaps.
* Data Storage Layer - Layer which will handle save states and settings.

### Component Interfacing

* User Interface nodes allow the player to use systems like the inventory and settings.  

* The dialogue system interacts with area2D nodes between the player and non-player characters

* The code puzzle system interacts with area2D nodes between the player and code puzzle giving objects

* The save NPC interacts with the dialogue system and the player to let the player save their progress

### Data Storage

The system interfaces with the user’s files to save game data. Save data that does not relate to game progression like the settings found in the options menu will be saved using a ConfigFile node.  

### Alternatives
Instead of Godot, the game could be developed in Unity or Unreal Engine 

#### Unity 

Pros: 

* Industry Standard: Unity is used by many major game companies and has a large following behind it, meaning that resources are easier to find 

Cons: 
* Steeper Learning cureve and licensing fess for larger projects

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

# 2. Software design 

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

# 3. Coding guideline 

For our work in GDScript, we will use the GDScript style guide, provided in the [Godot Documentation]( https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html )

We chose these guidelines because they are the most used in Godot development, and make scripts very easy to read, especially on smaller monitors or screen sizes.  

Additionally, Godot’s script editor automatically uses parts of this style guide. For example, adding in a function via node automatically provides the double white space noted in the style guide. As another example, the Godot editor displays a transparent vertical line at the 80 and 100 character mark. 

# 4. Process description 

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

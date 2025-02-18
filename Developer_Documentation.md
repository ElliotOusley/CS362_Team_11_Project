# Developer Documentation

This documentation is for contributors who wish to understand, build, test, or extend the CodeQuest project.

---

## 1. How to Obtain the Source Code

* Clone the repository:
  
  ```bash
  git clone https://github.com/ElliotOusley/CS362_Team_11_Project
  cd codeQuest/codeQuest
  ```
**You can also clone the repo using GitHub Desktop to clone and edit locally while also having the option to pull and push commits**
---

## 2. Directory Structure

The repository is organized as follows:

```bash
CodeQuest/
  ├─ Audio/                           # Sound effects and background music
  ├─ Dialougue/                       # Dialogue scripts and related files
  ├─ Scenes/                          # Scene files for different game components
  │   ├─ CodeBlocks/                  # Scenes related to coding puzzle elements
  │   ├─ Objects/                     # In-game objects and interactive elements
  │   └─ TestCodeChallenge/           # Test scenarios for code challenges
  ├─ Scripts/                         # Game scripts written in GDScript or C#
  │   ├─ HUD Scripts/                 # Scripts for heads-up display and UI components
  │   ├─ NPC Scripts/                 # Non-player character behavior and interactions
  │   └─ Player Scripts/              # Player-related scripts and mechanics
  ├─ Sprites/                         # Images, sprites, sound files, and other media assets
  │   ├─ Ambience/                    # Environmental visual effects
  │   ├─ Atlases/                     # Texture atlases for optimized rendering
  │   ├─ BackGrounds/                 # Background images for different levels
  │   ├─ Character/                   # Character sprites and animations
  │   ├─ CodeBlockSprites/            # Sprites related to coding block elements
  │   ├─ Objects/                     # Miscellaneous in-game objects
  │   ├─ Tilesets/                    # Tiles for level design and environment creation
  │   └─ UI/                          # User interface elements and icons
  ├─ addons/dialougue_manager/        # Addon for managing in-game dialogues
  │   ├─ assets/                      # Additional resources for dialogue manager
  │   ├─ compiler/                    # Dialogue compilation logic
  │   ├─ components/                  # UI and logic components for dialogues
  │   ├─ example_balloon/             # Example dialogue balloon implementation
  │   ├─ utilities/                   # Helper utilities for dialogue processing
  │   └─ views/                       # UI views related to dialogues
  ├─ inventory/                       # Inventory system and related scripts
  │   └─ items/                       # Item definitions and assets for inventory
  ├─ tests/                           # Automated test scripts (unit and integration tests)
  │   ├─ unit/                        # Unit test scripts for individual features
  │   ├─ integration/                 # Integration test scripts for module interactions
  ├─ project.godot                    # Main Godot project file
  └─ README.md                        # Overview and high-level project documentation
```

### Key Folders:

* `Scenes/` - Holds pre-built scene files for various game components.
* `Scripts/` - Contains all game logic and mechanics.
* `Sprites/` - Stores all game art, sound, and music assets.
* `addons/dialougue_manager/` - Handles in-game dialogue interactions.
* `inventory/` - Stores inventory-related data and item handling.

---

## 3. How to Build the Software

### Using Godot Editor

#### Open the Project:

1. Launch the Godot editor.
2. Click on **Import** and select the `project.godot` file.
3. Edit/Test from there according to project directory.

 - **VS Code Integration**
 - **Step 1**: Set up GitHub Desktop by downloading here: [GitHub Desktop download](https://github.com/apps/desktop)
 - **Step 2**: Clone the CS362_Team_11_Project Repo using the link.
 - **Step 3**: Navigate to VS Code. If you need the download, find it here: https://code.visualstudio.com/
 - **Step 4**: Install the Godot Tools extension in VS Code [Here](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools)
 - **Step 5**: Run seamlessly using normal launch methodology. By using the Godot extension, VS Code can run the Godot project as if it were actually being ran in Godot. 



#### Build/Export the Project:

1. Navigate to **Project > Export** in the Godot menu.
2. Set up export presets for your target platforms (e.g., Windows, Linux, macOS).
3. Click **Export** to build the project.

### Using Custom Build Scripts

* If you have additional CI/CD or build scripts, refer to the instructions in `docs/build_instructions.md`.

---

## 4. How to Test the Software

### Automated Testing

#### Unit Tests:

* Located in the `tests/` folder.
* Run tests using Godot's built-in testing framework.
* Example: Use **Project > Tools > Execute Tests** (if available) or run from the command line.

#### Integration Tests:

* Found in `tests/integration/`, these tests simulate interactions between modules (e.g., player and puzzle systems).
* Open and run these scenes in the Godot editor to verify integration.

### Manual/End-to-End Testing

#### Playtesting:

1. Launch the main scene (`Main.tscn`) in the editor.
2. Walk through key user flows (e.g., interacting with NPCs, solving puzzles, saving/loading progress).

---

## 5. How to Add New Tests

### Naming Conventions:

* Unit test files should follow the pattern: `test_<feature>.gd` (e.g., `test_inventory.gd`).
* Integration test files can follow: `integration_<feature>.gd`.

### Test Harness:

* Use Godot’s built-in testing frameworks.
* Each test file should extend the appropriate test class (e.g., `extends WAT.Test` or `extends SceneTreeTest`).

### Adding Tests:

1. Create your test file in the appropriate directory (`tests/` for unit tests, `tests/integration/` for integration tests).
2. Write tests that simulate the specific feature or interaction.
3. Ensure your tests are descriptive and include assertions for expected outcomes.

---

## 6. How to Build a Release

### Pre-Release Steps

#### Update Version Number:

* In the `project.godot` file or a version file (if maintained separately), increment the version number.
* Update the version in `README.md` and any other relevant documentation.

#### Sanity Checks:

* Manually verify that all major functionalities work (main menu, gameplay, saving/loading, puzzle interactions).
* Run automated tests to ensure no regressions.

### Exporting the Release

#### Export Process:

1. Open **Project > Export** in Godot.
2. Select the export preset for your target platform.
3. Export the project to generate the executable (e.g., `CodeQuest_Windows.zip`).

#### Post-Export Steps

##### Tag the Release:

```bash
git tag v1.0.0-beta
git push origin v1.0.0-beta
```

##### Publish the Release:

1. Navigate to the GitHub repository.
2. Create a new **Release** and upload the exported builds.
3. Document release notes detailing new features, bug fixes, and any known issues.

---

## Additional Notes

### Continuous Integration (CI):

* Ensure that all contributions pass the CI tests.
* Refer to `docs/ci_instructions.md` for more information on CI setup.

### Contribution Guidelines:

* Follow our coding style as per the GDScript style guide.
* Each commit should be tested, commented, and code-reviewed before merging.

### Bug Reporting & Issues:

* Report bugs on **GitHub Issues**.
* Follow our guidelines for reporting bugs to help improve the project.

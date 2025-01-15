# Beaver Builders (Group 11)

## Team Members and Roles
**Elliot Ousley:** Project Manager: 
Responsible for overall project coordination, task delegation, and ensuring the team meets deadlines. 

**Nathen dela Torre:** Gameplay Developer: 
Implements key game mechanics such as movement, inventory systems, and battle scenes using Godot. 

**Carlos Vasquez:** Backend Systems Developer: 
Focuses on implementing underlying game logic, data handling, and ensuring smooth integration of features like saving/loading game states. 

**Ben Snider:** Audio and Music Designer: 
Composes background music, sound effects, and ensures audio integration aligns with gameplay and player experience. 

**Hau’oli O’Brien:** QA Tester and Documentation Specialist:
Ensures the game is thoroughly tested, tracks bugs, and documents processes for future use. 

**Seth Taylor:** Level Designer: 
Designs and builds engaging levels and environments, ensuring a seamless blend of challenge, exploration, and visual appeal. 

**Philensakada Thavrin:** UI/UX Designer:
Create interfaces and ensures a smooth user experience by focusing on accessibility and visual clarity. 


## Educational Game for Learning Coding

### Abstract  
A game that teaches programming concepts through puzzles and interactive challenges. This 2D puzzle game involves finding words to input into a premade program to make it work.  

### Pros  
- Godot already provides simple scripts for player movement.  
- Godot has plugins that allow integration with GitHub.  
- Controlled player experience allows for simpler level design.  
- Puzzles with limited solutions are easier to test.  
- More engaging to work on than traditional apps like workout applications or task trackers.  

### Cons  
- Difficult to account for all word combinations a player could use.  
- Adding new mechanics could lead to scope creep since every programming concept could be considered a new feature.  

### Examples  
- The player encounters a gap and must use a **for loop** to create a bridge.  
- The player builds an **if statement** to make a key work in a door.  

### Goal  
Make learning programming more accessible and less intimidating by gamifying the process, allowing beginners to learn basic coding concepts in an engaging way.  

### Current Practice  
- Tools like Codecademy and W3Schools focus on text-heavy instructions or quizzes, which can overwhelm beginners.  
- Subscription fees for many platforms can be a barrier (e.g., Codecademy Pro at $40/month or HackerRank at $200–$450/month).  

### Novelty  
- Gamifies programming concepts by turning them into game mechanics rather than the sole focus of the game.  
- Prioritizes fun and accessibility for beginners.  

### Effects  
- Reduces intimidation and lowers barriers for learning programming.  
- Builds confidence for users to pursue further programming education.  

### Technical Approach  
- **Engine**: Godot (open-source, supports GDscript, C#, and C++).  
- **Art Assets**: Created using Aseprite (pixel art program).  

### Risks  
- **Conflict Management**: GitHub conflicts when multiple team members edit the same scene can be mitigated by dividing work into separate scenes.  
- **Learning Curve**: Learning Godot during development may cause delays but can be minimized by using available documentation and tutorials.  

---

## Top-Down RPG-Style Game

### Abstract  
A 2D game combining exploration, strategic battles, and resource management. Players navigate a world map, engage in turn-based combat in separate battle scenes, and manage their inventory to progress through the story.  

### Pros  
- Easy-to-implement small-scale RPG battle systems in Godot.  
- GitHub integration simplifies team collaboration.  
- Simplified art assets for world map environments.  
- Straightforward gameplay loop with few features to implement.  
- Modular design allows for easy content generation.  

### Cons  
- Dialogue systems could be challenging and tedious to populate.  
- Inventory implementation may be complex.  
- Scope creep could lead to an overwhelming number of art assets or features.  
- Battle system complexity increases with multiple enemies or player characters.  

### Goal  
- Develop a top-down 2D RPG with a focus on exploration, combat, and inventory management.  
- Create a modular gameplay loop for easy expansion and content addition.  
- Ensure a great user experience with simple yet effective mechanics and art.  

### Current Practice  
- Similar games like *Undertale* and *Pokémon* use predefined mechanics and environments.  
- Most 2D RPGs struggle with balancing depth and scope, leading to bloated cycles.  

### Novelty  
- Efficient use of Godot plugins for GitHub integration.  
- Simplified mechanics and art for quicker iterations.  
- Predefined battle options for strategic depth without scope bloat.  

### Effects  
- Provides a nostalgic, accessible RPG experience.  
- Creates a framework for potential expansion into larger projects.  

### Technical Approach  
- **Game Engine**: Godot for ease of use and plugin support.  
- **Version Control**: GitHub for collaboration and tracking.  

### Major Features  
- World map movement with collision detection.  
- Turn-based battle system with predefined player and enemy actions.  
- Inventory management for items and equipment.  
- Modular design for easy addition of new content.  

### Stretch Goals  
- Dialogue system for NPC interactions and storytelling.  
- Dungeons or battle scenarios for replayability.  

### Risks  
- Dialogue system implementation could be time-consuming.  
- Inventory management may become complex.  
- Scope creep may lead to an overwhelming number of features or art assets.  

---

## Personal AI Therapist

### Abstract  
A mental health tool using AI (GPT-3 backend) to provide real-time, empathetic support for users managing stress, anxiety, and related concerns.  

### Goal  
Develop an AI-powered system offering evidence-based coping strategies, emotional support, and active listening to make mental health tools more accessible.  

### Current Use  
- Apps like *Calm* or *Headspace* focus on meditation and breathing exercises.  
- AI-driven tools like *Woebot* provide text-based interactions.  

### Novelty  
- Highly personalized AI model trained on user-specific preferences and behaviors.  

### Effects  
- Bridges the gap between users and mental health resources.  
- Encourages resilience and reduces anxiety.  

### Major Features  
- Real-time chat functionality with empathetic AI responses.  
- Personalized strategies based on user input.  
- Multimodal interaction (text, voice, visual cues).  
- Secure, encrypted data storage for privacy.  

### Stretch Goals  
- Journaling with progress tracking.  
- Peer/mentor interaction (live person support, requiring account login).  

### Risks  
- Ensuring AI does not provide harmful advice, which could negatively affect users.  

--- 


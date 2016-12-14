build: 187_9-9_07.zip

[INSTRUCTIONS]
there are three batch files in the project directory that show off different aspects
of the cui game package.

c) there is the game aspect, demonstrated by "run_game.bat",
b) the editor aspect, demonstrated by "run_editor.bat",
a) and the engine aspect, demonstrated by "run_demo.bat".

NOTE: "run_demo.bat" copies resources into your c-drive.
NOTE: also included are 2 playable levels, city1 and city2.
      use the batch files "run_city1.bat" and "run_city2.bat"
      to view them.
NOTE: be sure to read th dev-diary! it documents some important moments in our
      development.
NOTE: the pictures you requested are in "dev-diary\pics\best\"
NOTE: for an annotated tour of the gallery go to "dev-diary\forum\"
NOTE: particle systems are known to crash our game on lab computers. if this happens,
      try it on a different machine or avoid crashing into walls. the collision system
      does work.

please consider all three in arriving at a verdict of our game. we worked really
hard to put these parts together. the resulting architecture is VERY SCALABLE and
easy to work with. our only regret is that we did not have sufficient time to
complete the 3rd aspect - the game aspect.

[ENGINE FEATURES]
- NPC waypoint scripting.
- bubble + box collision detection.
- game physics.
- particle systems.
- frustum culling.
- transparent sprites.
- pivotal object hierarchy.
- edge/face tesselation.
- texture mapping.
- six render modes.
- 3ds mesh support.
- comes with Visual Basic map editor.

[SPECS]
- coded in C++.
- uses OpenGL's glut library.
- supports Autodesk 3d Studio model files (*.3ds).
- supports Microsoft 1, 4, 8, 24-bit non RLE-compressed bitmaps (*.bmp).
- textures & sprites must be of dimensions W x H where W and H are both
  powers of 2 within the range 64 and 256.
- plays wavs, mods, mp3s.

[CONTROLS]
please try them in this order:
1) enter :: start engine
2) down arrow :: brake (hold it down to shift gears)
3) page up/down :: shift
4) up arrow :: pedal down
5) left/right arrow :: steer
6) tab :: honk.
7) tilde :: change camera angle
8) 'q' :: change render mode
9) 'w' :: toggle ambience
NOTE: the brakes MUST be held down to shift gears.

[GEARS] (page up/down)
1) park
2) reverse
3) neutral
4) drive

[CAMERA ANGLES] (tilde)
1) dynamic map view
2) dynamic car view
3) chase view
4) sky view

[RENDER MODES] ('q')
1) tex-mapped
2) tex-mapped + lighting
3) lighting
4) flat
5) wireframe
6) wireframe + double-sided

[MISC]
1) enable "#define MOD_TEST" to run the test module.
2) enable "#define CHECK_LEAK" to check for memory leaks.
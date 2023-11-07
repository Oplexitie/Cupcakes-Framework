# Cupcakes Framework

<p align="center">
<img src=".github/cupcake_logo.png" alt="Cupcakes Framework logo">
</p>

## Description

A Five Nights at Freddy's ( or FNAF ) framework made for Godot 3, with a [Godot 4 version also available](https://github.com/Oplexitie/Cupcakes-Framework/tree/main).

This framework only contains the very basic nescessities to build your FNAF inspired game.
As such I will not be adding any features that are :
  - A - Very easy to make on your own
  - B - Not necessary for a FNAF like game

Also, there's the [CF-Example-Project](https://github.com/Oplexitie/CF-Example-Project/tree/main) that was made using this framework that can be used as a reference.

## Features

- Office
	- A simple scrolling system where the speed is based on how close your mouse is to the screens edge.
 	- A more advanced system with the ability to scroll up and down (harder than it sounds with the shader)
	- An equirectangular perspective shader ( like the one seen in [Five Nights at Candy's Remastered](https://gamejolt.com/games/five-nights-at-candy-s-remastered/426659) )
- Camera System
	- A simple camera system that can be easily expanded to include more rooms
  - A flip up and down camera animation that won't break when spammed !
  - Camera movement ( like in FNAF 1 )
  - Support for smaller cameras while still supporting camera movement ( thanks to Godot's image region system )
  - Support for animated images on the camera ( via the AnimationPlayer node )
- Character AI ( no Jumpscares )
  - AI system faithful to the original FNAF games
  - AI difficutly based on a scale from 0 to 20 ( basically Custom Night )
  - Custom character states for alternate poses on Cameras
 
 ## Other info

If you encounter any bugs with an **unmodified version of the framework**, please post the issue on Github with a video attached.
If you want to contribute to the project, do a pull request on Github and I'll take a look at it.

The Cupcakes Framework is licensed under the MIT license.
Meaning that you can do whatever you want as long as credit me, and include the MIT liscence contained within this repository with your software/source.
Reminder, this is my understanding of the MIT license. I'm not a lawyer, do your own research.

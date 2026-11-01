# HaxeGalaxy
A simple galaxy simulation using the Haxe language

**Status:** historical Haxe/Flash graphics experiment, preserved as a source-code
museum piece. It does not run in current browsers because its output targets Flash.

The original source is `Main.hx`; `MyHaxeProject.hxproj` records the FlashDevelop
project, and `MyHaxeProject.swf` is the historical compiled artifact. Rebuilding would
require a compatible historical toolchain. No modern browser port or verified
current build is included.

The interesting thread is the camera/projection and movement experiment described
below—an early counterpart to the newer [FTL](https://github.com/peterthelander/ftl)
browser project.

## Original project notes

by Peter Thelander

This is just a small shockwave flash program I've written. It's like a mini-galaxy simulator.
It shows an example of point-of-view and movement code, and you can now use the usual game control keys W,A,S,D to move around (also Q,E for roll). The text in the upper left is the projection matrix, representing the eye position and orientation.
Right now it's just a little toy program for playing around with the 3-d framework concepts in flash. The goal later is to develop it into a bit more of a game, possibly with enemy ships to dogfight (easier said than done).

This was developed using the Flashdevelop IDE, combined with Haxe to generate the swf. Thank you to the authors of those excellent pieces of software!

By the way, notice the black hole that seems to form at the centre of the galaxy: that happened by accident, for a completely different reason than in the real galaxy - this one is nothing to do with gravity, it's just rounding errors :-)

Like it? Send me feedback at peter dot thelander at gmail dot com, it will help keep me motivated to develop this further.

UPDATE: Unfortunately Shockwave Flash is no longer supported in browsers, so you can't run this in them. Still, keeping this repo around as a museum piece.

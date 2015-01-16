# Star Ship Simulation

## Intro

This is a learning project based loosely on the book "The Complete STAR SHIP: A Simulation Project" by Roger Garrett (ISBN 0-918398-10-X, dilithium Press, 30 N.W. 23rd Place, Portland, Oregon 97210)

This file is a project BLOG. A stream of consciousness perhaps.

## The Blog

This is where I put my musings ...

### 2014-12-04 We begin

Project start! I've finally started the project. Working on the project structure and starting the documentation.

### 2014-12-07 Pearl Harbor Day!

I've been studying the Apple docs and playing around with some code. Fun stuff.

### 2014-12-10

A day off yesterday, it was my birthday. Not that that meant I should work on this but it was a busy day.

I decided that SimController should be a class instead of a protocol. It was an easy change.

### 2014-12-28

Finally getting back to this after th holiday festivities/craziness.

Yesterday I finished work on the Views and View Controllers, getting the structure working with the custom Sim Control. None of this has anything to do with the actual simulation yet but it is ncessary so that whn I do start building the simulation I will be able to peek into it.

I've been skimming the book again and will start by building the Common Data structure. I think the variable names will be in "regular" form and the two-letter names that the book has will be available through get/setValueFromUndefinedKey translations.  Not sure how that will work. I think I'll prototype it in the Playground first.

### 2014-12-29

Rearng'd the Common files. Separated out the bigger classes into separate files.

### 2014-12-30 
#### 00:48

Add more to the common data class. It's getting big ...

Starting to build some test cases. The Spatial classs cry out for testing. 
I did have to add some of the Sim classes to the test suite to get them to build. 
I suppose I will have to add most into the tst suite eventually.

#### 17:35

Completed LocationCode and Location. Added tests for same, fixed bugs and refined the tests.

LocationCode no longer defines the actual craft/device, the detail is held in Location. LocationCode defines the class of craft/device (i.e. ShuttleCraft, FederationCraft, TurboElevator, etc.)
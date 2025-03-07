
# Games as Pedagogical Tools

I'm interested in using games to share the intuitions certain models and tools computational researchers develop as they do their research. Part of this requires getting my hands dirty with game-development libraries and frameworks. Right now I'm gonna list out some things I've come across in setting up the Python game development library PyGame (link to pygame)


System: Mac OSX High Sierra
8 GB RAM
Intel Core i7 2.2 GHz

##First steps

Since I already had Anaconda installed, and a Python 3.5 environment set up, I thought it'd be plug-and-play. However, according to the PyGame developers, they suggest having a Python version > 3.6.1. 

To get around this I created a new Anaconda 3.6 environment:

conda create -n py36 python=3.6 

Afterwards I installed PyGame and all my requisite scientific computing libraries. 

When I went through the listed tutorial (spanners tutorial) I kept getting the following error:

	from pygame.base import *
	ImportError: No module named base

While I think the source of the problem can vary, for me this was because I was `python` to call my code instead of `python3`. 



### Loading sounds

I had an issue loading sound files into the game. After making sure to have called

pygame.init()
pygame.display.set_mode()

pygame.mixer.Sound(filename)

I would get an error saying that filename couldn't be loaded. This was because I was trying to load an .mp3 file instead of a .wav file.




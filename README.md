# shockski
the shockpots are broken again?
digital shock compression analysis

pov emma's attempt at trying to visually track shock compression to find shock load

## theory
inspired by digital image correlation (dic) methods commonly used in materials science research. dic uses speckled samples and high speed video cameras to record the movement of the speckles over time to obtain various gradients regarding sample deformation.

<img width="500" height="200" alt="image" src="https://github.com/user-attachments/assets/7c7992fc-5208-4458-97d5-cce0f9f5b206" />

since can visually observe the movement of shocks, we should technically be able to extract compressive acceleration to find our shock loads.

## workflow
disclaimer: should and must uncomment save lines and also change file names for input references
1. use video editing software to place green and red dots to track points of interest (ends of shock) while making the rest of the video black and white
    - adobe after effects: [video tutorial link](https://youtu.be/tqWWhChc8RA?si=d--2B2rBpk3ecMVZ)
        - bigger box: search area
        - smaller box: feature to be tracked
        - dot: center of marker
    - note: must use high contrast colors. currently hard programmed for red and green dots (in respective scripts) but can adjust search parameters for different colors
2. use reddottrack.m and greendottrack.m to extract coordinates of dots in every frame.
    - ensure to look at output graphs and compare with adobe after effects as a visual check
    - sometimes can have problems tracking dots that move too far between frames; if you run into this issue, try increasing the search radius
4. use distancecalc.m to extract distance between red and green dots in every frame and plot over time using fps.
5. use chattedforce.m to theoretically get shock force at every time
   - complete bullshit all from chat do not trust
pro tip: have a running doc of what all the saved files are from/mean

## current sources of error (unresolved)
- width of dots as a distance error tolerance
- camera distortion

## recording procedure
some things to note:
- use high contrast tape with a black dot in the center at the end of the shocks:
    - adobe after effects has a tough time tracking the bare end of the shock since all the rungs of the shock look the same; adding this feature significantly increases its accuracy and less need for manual adjustments
    - adobe after effects also uses luminance to track; rgb is an option, but it is more time consuming. thus, try to use neon or brightly colored tape
- try your best to keep everything in frame:
    - after effects bugs out when the feature being tracked goes out of frame; keeping everything in frame will save a lot of time (frame-by-frame manual adjustments)

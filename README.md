
WU Fall 2021 | CSMA 302 | Lab #2.5
---
# Advanced Materials Shaders
For this assignment you will make 6 materials in unity, and they should switch with the number keys. 

Feel free to replace the model with something else, or use the samples.

The shaders should be “unlit” because we are going to implement the lighting models ourselves, manually. 

1. Blend mode : A material that uses a non-standard blend mode. You could do additive, and turn off backface culling, and turn off ZWrite. 
2. Clip : a shader that does some clipping of the model to cutout. This should also disable backface culling so that you can see through the holes.
3. Displacement : This shader should do some vertex animation in the vertex shader.
4. Displacement with reflection: do a vertex displacement, but also compute the proper normal vector to do accurate reflections in the fragment shader
5. Hologram shader: This should create a cool-looking hologram effect using several techniques:
     - vertex displacement
     - additive blending
     - world space brightness stripes
     - diffuse map
     - overall color tint
6. Create your own shader: Get creative, use some of the effects we have worked on previously. It should have three features and you should be able to explain what they do in the comments. 


*ALL SHADERS MUST* : 
 - have an accurate reflection pass (that mirrors the vertex shader distortion, or clipping you do in the fragment shader)
 - support a diffuse map
 - have some sort of lighting (`dot(n, l)` or `dot(n, v)`)


*User interface:* the number keys should cycle through the materials 0-6. I shouldn't have to drag materials into the scene. Modify `materialSwitcher.cs` to handle 6 materials.


 
## Due Date

**The assignment is due on Sunday September 26th before midnight.**

## Resources


Blending : https://docs.unity3d.com/Manual/SL-Blend.html
Shaderlab : https://docs.unity3d.com/2017.2/Documentation/Manual/SL-Shader.html
Examples :  https://docs.unity3d.com/2017.2/Documentation/Manual/SL-VertexFragmentShaderExamples.html
Shaderlab Commands: https://docs.unity3d.com/Manual/shader-shaderlab-commands.html

## Grading

10 points each for each shader 1,2,3,4

20 points each for shaders 5 and 6

10 points for project organization ( top-level folders), and do the number keys change through 10 materials? 

10 points for code organization (indentation, comments, descriptive variable names, creating functions for each effect)

you are free to copy-paste shader code that you find on the internet for your effects, just be sure that you include a link to the site it is from. But the entire effect cannot be copy-pasted, just helper functions like HSVtoRGB or something like that. you have to do something else to the output besides 



## Submitting 
(this is also in the syllabus, but consider this an updated version)

1. Disregard what the Syllabus said about Moodle, just submit your work to a branch on github on this repo (branch should be your firstname-lastname)
When you are finished, "Tag" the commit in git as "Complete". You can still work on it after that if you want, I will just grade the latest commit.

2. The project has to run and all the shaders you are using should compile. If it doesn't I'm not going to try to fix it to grade it, I will just let you know that your project is busted and you have to resubmit.  Every time this happens I'll take off 5%. You have 24 hours from when I return it to get it back in, working. 

3. Late projects will lose 10% every 24 hours they are late, after 72 hours the work gets an F. 

4. Obviously plagarism will not be tolerated, there are a small number of students so I can read all your code. Because it is on git it's obvious if you copied some else's. If you copy code without citing the source in a comment, this will be considered plagarism. 







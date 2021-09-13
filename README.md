
WU Fall 2021 | CSMA 302 | Lab #2
---
# Basic Materials Shaders
For this assignment you will make 10 materials in unity, and they should switch with the number keys. 

Feel free to replace the model with something else, or use the samples.

The shaders should be “unlit” because we are going to implement the lighting models ourselves, manually. 

l - light vector
n - normal vector
v - view direction

1. Basic diffuse color 
2. Basic normal shading `dot(n, v)`
3. Basic diffuse Lambert shading  `dot(n, l)`
4. Normal map material (using tangent space normals) 
5. Phong shading `dot(n, l) * _color + _ambient + specular`
6. matcap (from class)
7. brdf (from class)
8. Reflection of environment map (use .exr in the texture folder) 
9. basic texture map (use occlusion texture as color)
10. color based on normal or world space coordinate (get creative)

*User interface:* the number keys should cycle through the materials 0-9. I shouldn't have to drag materials into the scene. Modify `materialSwitcher.cs` to handle 10 materials.

*note*: you don't have to use the gutenberg model, look around for your favorite, or even find a model online what has a normal map if you want. 

## Due Date

**The assignment is due on Sunday September 19th before midnight.**

## Resources

linear algebra / theory: 

 - https://acko.net/tv/webglmath/

Lighitng models: 

 - https://en.wikipedia.org/wiki/Lambertian_reflectance

 - https://en.wikipedia.org/wiki/Phong_reflection_model
 
Unity shaders: 

 - https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

 - https://catlikecoding.com/unity/tutorials/rendering/
 - 
 - https://catlikecoding.com/unity/tutorials/rendering/part-2/


## Grading

8 points per effect implemented (up to 10)

10 points for project organization ( top-level folders),  short README describing the effects and how the UI works.

10 points for code organization (indentation, comments, descriptive variable names, creating functions for each effect)

you are free to copy-paste shader code that you find on the internet for your effects, just be sure that you include a link to the site it is from. But the entire effect cannot be copy-pasted, just helper functions like HSVtoRGB or something like that. you have to do something else to the output besides 



## Submitting 
(this is also in the syllabus, but consider this an updated version)

1. Disregard what the Syllabus said about Moodle, just submit your work to a branch on github on this repo (branch should be your firstname-lastname)
When you are finished, "Tag" the commit in git as "Complete". You can still work on it after that if you want, I will just grade the latest commit.

2. The project has to run and all the shaders you are using should compile. If it doesn't I'm not going to try to fix it to grade it, I will just let you know that your project is busted and you have to resubmit.  Every time this happens I'll take off 5%. You have 24 hours from when I return it to get it back in, working. 

3. Late projects will lose 10% every 24 hours they are late, after 72 hours the work gets an F. 

4. Obviously plagarism will not be tolerated, there are a small number of students so I can read all your code. Because it is on git it's obvious if you copied some else's. If you copy code without citing the source in a comment, this will be considered plagarism. 








WU Fall 2021 | CSMA 302 | Lab #2
---
# Basic Materials Shaders

Use keys 0-9 to switch between shaders when project is in play mode. Change the Y position of the directional light when switching between shaders.

## Key 0: Diffuse
The diffuse shader gives the entire model one color. It makes model look like a 2D image.

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

## Key 2: Lambert
This shader carries the same charateristics as the normal shader, but it incorporates the directional light in the scene. When the directional light is pointing to the model, the chosen color of the model is seen. When the directional light is pointing away from the model, the color of the model will be black.

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

 - https://catlikecoding.com/unity/tutorials/rendering/part-2/


## Grading

8 points per effect implemented (up to 10)

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

## Key 4: Phong
The phong shader allows a reflection of the directional light to be seen.

## Key 5: Mat Cap
Mat cap uses a normal mapping texture and a mat cap texture. The normal mapping texture caputres the details on the model, and the mat cap texture allows the model to have a shiny coating along with the normal mapping texture.

## Key 6: BRDF
The BRDF shader is most similar to the functionality of the lambert shader. They differ due to the way the color is shown on the model. In this shader an image of gradient of red, white and blue is being projected onto the model. The position of a single point on the image will be determined based on the direction of the light.

## Key 7: Chrome
The chrome shader uses the cube mapping technique. The shininess of the model can be altered based on the chosen color in the inspector.

## Key 8: Toon
This shader incorporates many of the characteristics of the previous shaders: color, ambient lighting, highlights, shininess, normal texture mapping, and a toon threshold. The toon shader gives more of a cartoonish effect. Whne the directionl light is pointing straight at the model, the color of the model more clear. As the directional light points away, the highlight and ambient color can be seen.

## Key 9: Color Rotate
The color rotate shader is a color based shader on the normal space. The underlying model color is blue. The red and green values will automatically rotate around the model. Depending on the position of the red and green values, the colors range from super dark colors to super bright colors.

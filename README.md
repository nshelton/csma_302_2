WU Fall 2021 | CSMA 302 | Lab #2
---
# Basic Materials Shaders

Use keys 0-9 to switch between shaders when project is in play mode. Change the Y position of the directional light when switching between shaders.

# Materials Shaders Part 1
## Key 0: Diffuse
The diffuse shader gives the entire model one color. It makes model look like a 2D image.

## Key 2: Lambert
This shader carries the same charateristics as the normal shader, but it incorporates the directional light in the scene. When the directional light is pointing to the model, the chosen color of the model is seen. When the directional light is pointing away from the model, the color of the model will be black.

## Key 3: Normal Map
The normal map shader caputres the details on the model based on the normal mapping texture.

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


# Materials Shaders Part 2
## Key 0: Blend
The blend shader gives the model some type of additive effect based on the brightness value.

## Key 1: Clip
This shader clips the model into horizontal strips. It can be distorted based on the following parameters: distortion, frequency, speed and distortion offest. It addition to this, values of the parameters are reflected in the model's shadow.

## Key 2: Displace
Displce is like the clip shader; however, there is no clipping involved. In this shader, the model can be distorted based on two parameters, distortion and frequency. This material can be compared to some type of balloon effect.

## Key 3: Displace Reflection
Displace reflection is just like the displace shader. It differs from the displace shader becasue an environment mapping is involved and the speed of the frequency can be altered.

## Key 4: Hologram
The hologram shader clips the model into several horizontal stips. While the scene is play mode, the model has some sort of glitch effect. This effect will slightly offset the strips from the top to the bottom of the model.

## Key 5: Strip Movement
Strip movement alters the size of the clipping effect. The effect makes the model seem as if it is moving in an upwards direction. As this is happend, the brightness of the chosen color adjust from 0 to 1.
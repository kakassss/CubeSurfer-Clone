Toony Colors Pro, version 2.3
2017/05/08
� 2017 - Jean Moreno
=============================

USAGE
-----
Select one of the following shader in your Material:
- Toony Colors Pro 2/Desktop
- Toony Colors Pro 2/Mobile
- Toony Colors Pro 2/Standard PBS
- Toony Colors Pro 2/Standard PBS (Specular)
Then select the features you want to enable (bump, specular, rim...), and the correct shader will automatically
be selected for you.
Use the (?) buttons to see help for specific features, or read the documentation for more information.

PLEASE LEAVE A REVIEW OR RATE THE PACKAGE IF YOU FIND IT USEFUL!
Enjoy! :)


CONTACT
-------
Questions, suggestions, help needed?
Contact me at:
jean.moreno.public+unity@gmail.com

I'd be happy to see Toony Colors Pro 2 used in your project, so feel free to drop me a line about that! :)


UPDATE NOTES
------------
2.3.31
- disabled debug mode in Shader Generator (was mistakenly left enabled in the previous update)

2.3.3
- Shader Generator: updated template to use Unity 5's surface shader model by default
 * this will improve compatibility with built-in features (e.g. Light Probe Proxy Volumes)
 * visuals should stay the same as they were, but you can use Unity 4 model if that's not the case
 * please send me a bug report if you notice something wrong
- Shader Generator: major update to the Texture Blending feature:
 * now based on vertex colors or texture map
 * can blend up to 5 textures using RGBA + black color
 * height-based blending for more realistic transition between textures (also added to Terrain template)
- Shader Generator: added Triplanar mapping option
- Shader Generator: added "Ramp Control" and "Ramp Style" features:
 * separated ramp controls per light type, or main/secondary lights
 * "RGB Slider" option, allows a different threshold per color channel (good for skin subsurface approximation)
 * shaders using the "Separated Ramps" option will switch to these new options
- Shader Generator: added Point and Spot light built-in falloff textures bypass:
 * will remove the usage of Unity's built-in falloff textures
 * ramp settings will be based on a linear falloff, based on the light's settings
 * you can define a custom falloff texture when combining this with the new Ramp Control feature
- Shader Generator: added Alpha To Coverage transparency option
- Shader Generator: added custom Light Wrapping factor option
- Shader Generator: added Specular workflow option (Standard PBS Template)
- Shader Generator: added ignore main texture and/or color alpha options for Alpha Blending & Testing
- Shader Generator: Subsurface Scattering is always using the Light's color now
- Shader Generator: added Gradient Ramp option for Dissolve
- Shader Generator: Dissolve doesn't clip by itself now, you need to enable Alpha Testing (Cutout) to get the old behavior
- Shader Generator: added UV1 option for Masks' independent UVs (to use secondary UVs from the mesh)
- Shader Generator: added height-based blending for Terrain template
- Shader Generator UI: reorganized sections with labels
- Scripts: TCP2_GetPosOnWater doesn't update the custom time value anymore, use TCP2_ShaderUpdateUnityTime instead
- Shaders: new default color values for highlight/shadows, should look more like the Default material
- Material Inspectors UI improvements
- updated documentation and reorganized sections to match Shader Generator
- fixed harmless console errors related to material inspector (hopefully!)

2.3.22
- removed harmless shader warnings in Unity 5.6

2.3.21
- fixed packed shaders file that was corrupted (unpacked shaders weren't compiling)

2.3.2
- added "Curved World" compatible Water shader template
- added direct editing of ramp textures gradient (when generated with the Ramp Generator)
- updated material inspector UI for ramp textures

2.3.11
- added script "TCP2_CameraDepth" to force rendering of the depth texture for a Camera (needed for some water shaders)
- added a warning in the material about the need for the depth texture for relevant water shaders
- fixed generated shaders include path if "Toony Colors Pro" folder has been moved

2.3.1
- PBS Shaders: Unity 5.6 compatibility
- PBS Shader Template: Unity 5.6 compatibility

2.3
- added "Water Template" for Shader Generator: make your own stylized water shader
- added "PBS Template" for Shader Generator: make your own enhanced PBS stylized shader
- added Scene "Demo TCP2 ShaderGenerator" with examples of user-generated shaders
- Shader Generator: new button to easily load included shader templates
- Shader Generator: added "Occlusion Map" feature
- Shader Generator: added "No Shadow Color" feature for secondary lights
- Shader Generator: replaced "Disable Wrapped Lighting" with "Enable Wrapped Lighting" (so that it is disabled by default)
- fix: "Standard PBS" shaders should reflect Unity 5.5's Standard shader better
- fix: Shader Generator should be much faster at loading shader list
- fix: "Backface Lighting" should work correctly now
- fix: Screen space UV offset for Sketch effects is more accurate and now correct in Scene view
- renamed texture files that were using an old prefix (from TG_ to TCP2_)
- dropped support for Unity 5.3 and lower (older versions still available to download)

2.2.6
- added "Dissolve Map" feature: simple dissolution effect based on a grayscale map and a dissolve value
- added "Depth Pass" option for "Outline behind model": this should help with sorting issues when using that option
- added "Backface Lighting" option when disabling backface culling (experimental)
- added "View Dependent" option for "Directional Ambient" feature
- added "Subsurface Light Color" option for "Subsurface Scattering" feature
- added "Separate Color" option for the "Color Mask" feature
- updated Shader Generator and Material Inspector:
 * templates now entirely handle the generated shaders' inspector UI
 * slight interface update for better clarity
- fixed "Curved World" template (was broken in previous version)

2.2.51
- Unity 5.5 compatibility
- added "HSV Controls" feature (hue/saturation/value)
- updated masks with new template system

2.2.5
- added "Diffuse Tint" option in Shader Generator
- added "Separated Ramp" option in Shader Generator
- added "Vertex Colors" option for all Masks
- major update to the Shader Generator:
 * now the whole UI is embedded into the templates (will make it easier to create different templates)
 * uses a more robust condition parser
 * the old template is still available, with the old behavior, in case the new system doesn't properly work
- fixed compilation issue on PBS shaders when UNITY_STANDARD_SIMPLE was used (it is now ignored)
- bug fixes in Terrain template

2.2.45
- added "Normal Map Blending" option for "Vertex Texture Blending" feature
- updated the "Sketch" effects in the Shader Generator:
 * the screen-space texture will be offset based on the object's position, removing the 'shower door' artefact
 * go back to the old behavior by enabling the 'Disable Obj-Space Offset' option
 * removed 'Scale with Model' option, now integrated with the new object-space offset
 * the UVs aren't multiplied with the resolution anymore, giving consistent texture scale across resolutions
- updated "Subsurface Scattering" in the Shader Generator:
 * separated Ambient Color and Color
 * additive mode is now the default behavior for more consistency, use "Multiplicative" option for previous behavior
 * fixed shadows affecting subsurface with directional lights

2.2.44
- fixed corrupted packed shaders (Unity 5.4)

2.2.43
- fixed "Use Reflection Probes" option in Desktop shader (Unity 5.4)

2.2.42
- allow Emission Color to be enabled without Emission Map in Shader Generator
- added "HDR Color" option for Emission Color in Shader Generator (useful for effects like bloom)
- renamed internal variable _IllumColor to _EmissionColor in templates
- dropped support for Unity 5.0.0 and lower (older versions still available to download)

2.2.41
- updated PBS shaders to match Standard shaders in Unity 5.4
- added "Dithered Shadows" option in Shader Generator for alpha-blended shaders
- fixed initial blending values for Alpha Blending option in Shader Generator
- minor fix to Shader Generator templates

2.2.4
- added "Subsurface Scattering" option in Shader Generator
- fixed inspectors issue with Mac retina displays

2.2.31
- added "Bump Scale" option in Shader Generator
- fixed issues when updating shaders with custom output path enabled
- removed Unity5.4 templates and added differences in the main Unity5 template

2.2.3
- added Ramp Generator utility
- added option to explicitly set shader model target in Shader Generator
- added Shader Generator template for Terrain shaders (experimental)
- removed explicit "#pragma target 2.0" in PBS shaders for lower LOD, allowing it to default to shader model target 2.5 in Unity 5.4
- renamed "Self-Illumination" feature to "Emission" in Shader Generator
- custom output path fix for already existing shaders

2.2.2
- added option to save generated shaders in custom directory

2.2.1
- added Unity 5.4 compatible templates for the Shader Generator (fix for reflection probes sampling)
- fixed seamless tiling on some sketch textures

2.2
- added "Standard PBS" version of the shaders, based on Unity Standard shaders (Unity 5.3+ only)
- added "TCP2 Demo PBS" scene to show the PBS shaders
- moved "Outline Only" shaders to their own category
- updated documentation

2.14.1
- fixed attenuation factor with "Light-based Mask" for Rim Lighting (point/spot lights, shadows)

2.14
- added "Light-based Mask" option for Rim Lighting in Shader Generator

2.13
- added option to disable wrapped diffuse lighting
- added "Colors Multipliers" option to Shader Generator
- bug fixes and improvements

2.12.2
- disabled custom lightmapping support in Unity5+, turns out it doesn't work anymore with surface shaders

2.12.1
- removed double lighting multiplication in Unity 5 template for Shader Generator
- Smoothed Normal Utility now copies blend shape data in Unity 5.3+

2.12
- added support for "Curved World" by Davit Naskidashvili in the Shader Generator (requires the "Curved World" package from the Asset Store)
- refactored outline shaders code with TCP2_Outline_Include.cginc
- fixed Blended Outline Only shaders queue (from opaque to transparent)
- fixed Outline Only material inspector glitch with slider properties in Unity 5+

2.11.2
- Mobile shader now compiles to shader model 2 as it was supposed to
- added menu options to unpack all mobile and desktop variant shaders

2.11.1
- improved detection of manually modified generated shaders
- fixed issue with Shader Generator and Texture Ramp
- fixed issue with Shader Generator and Cartoon Specular

2.11
- fixed issue with Shader Generator and TCP2 Lightmap
- added script to convert materials from TCP1 to TCP2 (in the tools menu)

2.10
- fixed issue with Smoothed Normals Utility and built-in meshes
- Smoothed Normals Utility no longer requires mesh to be read/write enabled

2.091
- fixed generated Shader userData not always saved when using Shader Generator

2.09
- added option to render outline behind the model (Shader Generator)
- fixed shader model 2 outlines with Shader Generator (Unity 4.5)

2.08
- fixed Parallax offset for diffuse texture (Shader Generator)
- fixed warnings on package import (Unity 5)
- TCP2 shaders now work correctly with Substance materials (Unity 5)

2.07
- fixed MatCap calculations (was incorrect with rotated meshes) in Mobile shaders and Shader Generator template

2.06
- fixed MatCap issue with scaled skinned meshes (added option to turn fix on/off in inspector)
- fixed Pixel MatCap breaking generated shaders if normal map was disabled

2.05
- added Pixel Matcap option in Shader Generator, allows MatCap to work with normal maps

2.04
- fixed path issues on Mac

2.03
- fixed glitched outlines in DX11

2.02
- fixed issue with vertex function in generated shaders
- removed debug information showing in material inspector

2.01
- updated Mobile shaders to target shader model 3: should fix compilation issues with some combinations, will break compatibility with super old desktop GPU (roughly pre-2004)

2.0
- everything redone from scratch!
- lots of new features and optimizations added to the shaders
- Unified Inspector: select one shader and then let the inspector choose the correct optimized shader for you
- Shader Generator: generate your own stylized shader choosing from a lot of features
- Smooth Normals Utility: generate encoded smoothed normals to fix hard-edge outlines
- new Documentation in HTML format with examples and tips

1.71
- updated "JMO Assets" menu

1.7
- added alpha output to shader files (RenderTextures should now work for real)
- Constant Outline shaders now take the object's uniform scale into account

1.6
- fixed alpha output to 0 in lighting model, would cause problems with Render Textures previously
- fixed Warnings in Unity 4+ versions
- fixed shader Warnings for D3D11 and D3D11_9X compilers
- re-enabled ZWrite by default for outlines, would cause them to not show over skyboxes previously

1.5
- fixed the specular lighting algorithm, would cause glitches with small light ranges

1.4
- changed name to "Toony Colors"
- fixed Bump Maps Substance compatibility (WARNING: you may have to re-set the Normal Maps in your materials)

1.3
- added Rim Outline shaders

1.2
- added JMO Assets menu (Window -> JMO Assets), to check for updates or get support

1.1
- Rim lighting is much faster! (excepted on Rim+Bumped shaders)

1.01
- Included Demo Scene

1.0
- Initial Release
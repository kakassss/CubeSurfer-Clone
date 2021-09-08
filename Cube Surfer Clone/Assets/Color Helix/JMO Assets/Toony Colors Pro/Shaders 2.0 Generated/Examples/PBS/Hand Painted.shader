// Toony Colors Pro+Mobile 2
// (c) 2014-2017 Jean Moreno


Shader "Toony Colors Pro 2/Examples/PBS/Hand Painted"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
		
		_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

		_Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
		_GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
		[Enum(Metallic Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0

		[Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
		_MetallicGlossMap("Metallic", 2D) = "white" {}

		// [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		// [ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0

		_BumpScale("Scale", Float) = 1.0
		_BumpMap("Normal Map", 2D) = "bump" {}

		_Parallax ("Height Scale", Range (0.005, 0.08)) = 0.02
		_ParallaxMap ("Height Map", 2D) = "black" {}

		_OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
		_OcclusionMap("Occlusion", 2D) = "white" {}

		_EmissionColor("Color", Color) = (0,0,0)
		_EmissionMap("Emission", 2D) = "white" {}
		
		_DetailMask("Detail Mask", 2D) = "white" {}

		_DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {}
		_DetailNormalMapScale("Scale", Float) = 1.0
		_DetailNormalMap("Normal Map", 2D) = "bump" {}

		[Enum(UV0,0,UV1,1)] _UVSec ("UV Set for secondary textures", Float) = 0

		// Blending state
		[HideInInspector] _Mode("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend("__src", Float) = 1.0
		[HideInInspector] _DstBlend("__dst", Float) = 0.0
		[HideInInspector] _ZWrite("__zw", Float) = 1.0

		//TOONY COLORS PRO 2 ----------------------------------------------------------------
		_HColor("Highlight Color", Color) = (0.785,0.785,0.785,1.0)
		_SColor("Shadow Color", Color) = (0.195,0.195,0.195,1.0)
		
		
	[Header(Ramp Shading)]
		_RampThreshold("Threshold", Range(0,1)) = 0.5
		_RampSmooth("Main Light Smoothing", Range(0,1)) = 0.2
		_RampSmoothAdd("Other Lights Smoothing", Range(0,1)) = 0.75
		
	[Header(Threshold Texture)]
		[NoScaleOffset] _ThresholdTex ("Texture (Alpha)", 2D) = "black" {}
		_ThresholdStrength ("Strength", Range(0,1)) = 1
		_ThresholdScale ("Scale", Float) = 4
		
	[Header(Stylized Specular)]
		_SpecSmooth("Specular Smoothing", Range(0,1)) = 1.0
		_SpecBlend("Specular Blend", Range(0,1)) = 1.0
		
		
	[Header(Stylized Fresnel)]
		[PowerSlider(3)] _RimStrength("Strength", Range(0, 2)) = 0.5
		_RimMin("Min", Range(0, 1)) = 0.6
		_RimMax("Max", Range(0, 1)) = 0.85
		
		//Avoid compile error if the properties are ending with a drawer
		[HideInInspector] __dummy__ ("__unused__", Float) = 0
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" "PerformanceChecks"="False" }

		// ------------------------------------------------------------------
		//  Base forward pass (directional light, emission, lightmaps, ...)
		Pass
		{
			Name "FORWARD" 
			Tags { "LightMode" = "ForwardBase" }

			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]

			CGPROGRAM
			#pragma target 3.0

			// -------------------------------------
			
			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
			#pragma shader_feature _PARALLAXMAP

			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog

			#pragma vertex vertBase
			#pragma fragment fragBase

			ENDCG
		}
		
		// ------------------------------------------------------------------
		//  Additive forward pass (one light per pass)
		Pass
		{
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Fog { Color (0,0,0,0) } // in additive pass fog should be black
			ZWrite Off
			ZTest LEqual

			CGPROGRAM
			#pragma target 3.0
			
			// -------------------------------------
			
			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _PARALLAXMAP
			
			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog
			
			//Hack to replace #define and differentiate between Base and Add passes
			#pragma multi_compile FORWARD_ADD
			
			#pragma vertex vertAdd
			#pragma fragment fragAdd

			ENDCG
		}
		
		// ------------------------------------------------------------------
		//  Shadow & Meta

		UsePass "Hidden/Toony Colors Pro 2/PBS Shadow Meta/SHADOW_CASTER"
		UsePass "Hidden/Toony Colors Pro 2/PBS Shadow Meta/META"
	}
	
	CGINCLUDE

		#define UNITY_SETUP_BRDF_INPUT MetallicSetup

		//================================================================================================================================
		// TCP2_PBS_Main.cginc START

		//-------------------------------------------------------------------------------------
		//TCP2 Params

		fixed4 _HColor;
		fixed4 _SColor;
		sampler2D _Ramp;
		fixed _RampThreshold;
		fixed _RampSmooth;
		fixed _RampSmoothAdd;
		fixed _SpecSmooth;
		fixed _SpecBlend;
		fixed _RimStrength;
		fixed _RimMin;
		fixed _RimMax;
		sampler2D _ThresholdTex;
		fixed _ThresholdScale;
		fixed _ThresholdStrength;

		//Note: includes all PBS-related cginc files from Unity
		#include "UnityStandardCore.cginc"

		//================================================================================================================================
		// TCP2_PBS_BRDF.cginc START

		//-------------------------------------------------------------------------------------
		// TCP2 Tools

		inline half WrapRampNL(half nl, fixed threshold, fixed smoothness)
		{
			nl = smoothstep(threshold - smoothness*0.5, threshold + smoothness*0.5, nl);
			return nl;
		}
		
		inline half StylizedSpecular(half specularTerm, fixed specSmoothness)
		{
			return smoothstep(specSmoothness*0.5, 0.5 + specSmoothness*0.5, specularTerm);
		}
		
		inline half3 StylizedFresnel(half nv, half roughness, UnityLight light, half3 normal, fixed rimMin, fixed rimMax, fixed rimStrength)
		{
			half rim = 1-nv;
			rim = smoothstep(rimMin, rimMax, rim) * rimStrength * saturate(1.33-roughness);
			return rim * saturate(dot(normal, light.dir)) * light.color;
		}
		

		//-------------------------------------------------------------------------------------
		// TCP2 Data

		struct TCP2Data
		{
		};

		//Common base/add fragment operations executed at the start of frag()
		inline void TCP2_FragBegin(half2 texcoords, inout TCP2Data tcp2data)
		{
		}
		
		//Common base/add fragment operations executed just before the BRDF function
		inline void TCP2_FragBeforeBRDF(inout FragmentCommonData s, inout TCP2Data tcp2data)
		{
		}

		//-------------------------------------------------------------------------------------

		// Note: BRDF entry points use oneMinusRoughness (aka "smoothness") and oneMinusReflectivity for optimization
		// purposes, mostly for DX9 SM2.0 level. Most of the math is being done on these (1-x) values, and that saves
		// a few precious ALU slots.

		// Main Physically Based BRDF
		// Derived from Disney work and based on Torrance-Sparrow micro-facet model
		//
		//   BRDF = kD / pi + kS * (D * V * F) / 4
		//   I = BRDF * NdotL
		//
		// * NDF (depending on UNITY_BRDF_GGX):
		//  a) Normalized BlinnPhong
		//  b) GGX
		// * Smith for Visiblity term
		// * Schlick approximation for Fresnel
		half4 TCP2_BRDF_PBS(half3 diffColor, half3 specColor, half oneMinusReflectivity, half smoothness, half3 normal, half3 viewDir, UnityLight light, UnityIndirect gi,
			/* TCP2 */ half atten
			,half2 texcoords
			)
		{
			half perceptualRoughness = SmoothnessToPerceptualRoughness (smoothness);
			half3 halfDir = Unity_SafeNormalize (light.dir + viewDir);

	// NdotV should not be negative for visible pixels, but it can happen due to perspective projection and normal mapping
	// In this case normal should be modified to become valid (i.e facing camera) and not cause weird artifacts.
	// but this operation adds few ALU and users may not want it. Alternative is to simply take the abs of NdotV (less correct but works too).
	// Following define allow to control this. Set it to 0 if ALU is critical on your platform.
	// This correction is interesting for GGX with SmithJoint visibility function because artifacts are more visible in this case due to highlight edge of rough surface
	// Edit: Disable this code by default for now as it is not compatible with two sided lighting used in SpeedTree.
	#define TCP2_HANDLE_CORRECTLY_NEGATIVE_NDOTV 0 

	#if TCP2_HANDLE_CORRECTLY_NEGATIVE_NDOTV
			// The amount we shift the normal toward the view vector is defined by the dot product.
			half shiftAmount = dot(normal, viewDir);
			normal = shiftAmount < 0.0f ? normal + viewDir * (-shiftAmount + 1e-5f) : normal;
			// A re-normalization should be applied here but as the shift is small we don't do it to save ALU.
			//normal = normalize(normal);

			half nv = saturate(dot(normal, viewDir)); // TODO: this saturate should no be necessary here
	#else
			half nv = abs(dot(normal, viewDir));	// This abs allow to limit artifact
	#endif

			half nl = saturate(dot(normal, light.dir));

			half texThreshold = tex2D(_ThresholdTex, texcoords.xy * _ThresholdScale).a - 0.5;
			nl += texThreshold * _ThresholdStrength;

		#if FORWARD_ADD
			#define RAMP_SMOOTH _RampSmoothAdd
		#else
			#define RAMP_SMOOTH _RampSmooth
		#endif
			//TCP2 Ramp N.L
			nl = WrapRampNL(nl, _RampThreshold, RAMP_SMOOTH);

			half nh = saturate(dot(normal, halfDir));

			half lv = saturate(dot(light.dir, viewDir));
			half lh = saturate(dot(light.dir, halfDir));

			// Diffuse term
			half diffuseTerm = DisneyDiffuse(nv, nl, lh, perceptualRoughness) * nl;

			// Specular term
			// HACK: theoretically we should divide diffuseTerm by Pi and not multiply specularTerm!
			// BUT 1) that will make shader look significantly darker than Legacy ones
			// and 2) on engine side "Non-important" lights have to be divided by Pi too in cases when they are injected into ambient SH
			half roughness = PerceptualRoughnessToRoughness(perceptualRoughness);
	#if UNITY_BRDF_GGX
			half V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
			half D = GGXTerm (nh, roughness);
	#else
			// Legacy
			half V = SmithBeckmannVisibilityTerm (nl, nv, roughness);
			half D = NDFBlinnPhongNormalizedTerm (nh, PerceptualRoughnessToSpecPower(perceptualRoughness));
	#endif
			half specularTerm = V*D * UNITY_PI; // Torrance-Sparrow model, Fresnel is applied later
	//TCP2 Stylized Specular
			half r = sqrt(roughness)*0.85;
			r += 1e-4h;
			specularTerm = lerp(specularTerm, StylizedSpecular(specularTerm, _SpecSmooth) * (1/r), _SpecBlend);
	#ifdef UNITY_COLORSPACE_GAMMA
			specularTerm = sqrt(max(1e-4h, specularTerm));
	#endif
			// specularTerm * nl can be NaN on Metal in some cases, use max() to make sure it's a sane value
			specularTerm = max(0, specularTerm * nl);

			// surfaceReduction = Int D(NdotH) * NdotH * Id(NdotL>0) dH = 1/(roughness^2+1)
			half surfaceReduction;
	#ifdef UNITY_COLORSPACE_GAMMA
			surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;		// 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
	#else
			surfaceReduction = 1.0 / (roughness*roughness + 1.0);			// fade \in [0.5;1]
	#endif

			// To provide true Lambert lighting, we need to be able to kill specular completely.
			specularTerm *= any(specColor) ? 1.0 : 0.0;
	
	//TCP2 Colored Highlight/Shadows
			_SColor = lerp(_HColor, _SColor, _SColor.a);	//Shadows intensity through alpha

	//light attenuation already included in light.color for point lights
	#if !FORWARD_ADD
			diffuseTerm *= atten;
	#endif
	half3 diffuseTermRGB = lerp(_SColor.rgb, _HColor.rgb, diffuseTerm);
			half3 diffuseTCP2 = diffColor * (gi.diffuse + light.color * diffuseTermRGB);
			//original: diffColor * (gi.diffuse + light.color * diffuseTerm)
	
	//light attenuation already included in light.color for point lights
	#if !FORWARD_ADD
			//TCP2: atten contribution to specular since it was removed from light calculation
			specularTerm *= atten;
	#endif

			half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
			half3 color =	diffuseTCP2
							+ specularTerm * light.color * FresnelTerm (specColor, lh)
							+ surfaceReduction * gi.specular
							* FresnelLerp (specColor, grazingTerm, nv);

	//TCP2 Enhanced Rim/Fresnel
	color += StylizedFresnel(nv, roughness, light, normal, _RimMin, _RimMax, _RimStrength);
			return half4(color, 1);
		}

		// TCP2_PBS_BRDF.cginc END
		//================================================================================================================================

		#include "UnityStandardConfig.cginc"

		// ------------------------------------------------------------------
		// TCP2 custom vertex input
		// Wrapper for Unity Standard's structs, so that we can extend it if needed

		struct TCP2_VertexInput
		{
			VertexInput base;
		};

		struct TCP2_VOFwdBase
		{
			VertexOutputForwardBase base;
		};

		struct TCP2_VOFwdAdd
		{
			VertexOutputForwardAdd base;
		};

		//================================================================================================================================
		// TCP2_PBS_Core.cginc START

		// ------------------------------------------------------------------
		//  Base forward pass (directional light, emission, lightmaps, ...)
		
		//Vertex
		TCP2_VOFwdBase vertForwardBase_TCP2(TCP2_VertexInput v)
		{
			//Unity Standard
			VertexOutputForwardBase unity_o = vertForwardBase(v.base);
			TCP2_VOFwdBase o = UNITY_INITIALIZE_OUTPUT(TCP2_VOFwdBase, o);
			o.base = unity_o;
			return o;
		}
		
		//Fragment
		half4 fragForwardBaseInternal_TCP2(TCP2_VOFwdBase tcp2i
		)
		{
			VertexOutputForwardBase i = tcp2i.base;
			
			//TCP2 custom
			TCP2Data tcp2data;
			UNITY_INITIALIZE_OUTPUT(TCP2Data, tcp2data);
			TCP2_FragBegin(i.tex, tcp2data);

			FRAGMENT_SETUP(s)
		#if UNITY_OPTIMIZE_TEXCUBELOD
				s.reflUVW = i.reflUVW;
		#endif

		#if UNITY_VERSION >= 550
			UnityLight mainLight = MainLight();
		#else
			UnityLight mainLight = MainLight(s.normalWorld);
		#endif
			
		#if UNITY_VERSION >= 560
			UNITY_LIGHT_ATTENUATION(shadowAtten, i, s.posWorld);
		#else
			half shadowAtten = SHADOW_ATTENUATION(i);
		#endif

			half occlusion = Occlusion(i.tex.xy);
			UnityGI gi = FragmentGI(s, occlusion, i.ambientOrLightmapUV, 1, mainLight);	//TCP2: replaced atten with 1, atten is done in BRDF now

			//TCP2 entry point
			TCP2_FragBeforeBRDF(s, tcp2data);

		#if UNITY_VERSION >= 550
			#define SMOOTHNESS s.smoothness
		#else
			#define SMOOTHNESS s.oneMinusRoughness
		#endif
			half4 c = TCP2_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, SMOOTHNESS, s.normalWorld, -s.eyeVec, gi.light, gi.indirect, /* TCP2 */ shadowAtten
				,i.tex
				);
			c.rgb += UNITY_BRDF_GI(s.diffColor, s.specColor, s.oneMinusReflectivity, SMOOTHNESS, s.normalWorld, -s.eyeVec, occlusion, gi);
			
			c.rgb += Emission(i.tex.xy);

			UNITY_APPLY_FOG(i.fogCoord, c.rgb);
			return OutputForward(c, s.alpha);
		}

		// ------------------------------------------------------------------
		//  Additive forward pass (one light per pass)

		//Vertex
		TCP2_VOFwdAdd vertForwardAdd_TCP2(TCP2_VertexInput v)
		{
			VertexOutputForwardAdd unity_o = vertForwardAdd(v.base);
			TCP2_VOFwdAdd o = UNITY_INITIALIZE_OUTPUT(TCP2_VOFwdAdd, o);
			o.base = unity_o;
			return o;
		}

		//Fragment
		half4 fragForwardAddInternal_TCP2(TCP2_VOFwdAdd tcp2i
		)
		{
			VertexOutputForwardAdd i = tcp2i.base;
			
			//TCP2 entry point
			TCP2Data tcp2data;
			UNITY_INITIALIZE_OUTPUT(TCP2Data, tcp2data);
			TCP2_FragBegin(i.tex, tcp2data);

			FRAGMENT_SETUP_FWDADD(s)

		#if UNITY_VERSION >= 560
			UNITY_LIGHT_ATTENUATION(lightAtten, i, s.posWorld)
			UnityLight light = AdditiveLight(IN_LIGHTDIR_FWDADD(i), lightAtten);
		#elif UNITY_VERSION >= 550
			half lightAtten = LIGHT_ATTENUATION(i);	// extract light atten to pass it to BRDF
			UnityLight light = AdditiveLight(IN_LIGHTDIR_FWDADD(i), lightAtten);
		#else
			half lightAtten = LIGHT_ATTENUATION(i);	// extract light atten to pass it to BRDF
			UnityLight light = AdditiveLight(s.normalWorld, IN_LIGHTDIR_FWDADD(i), lightAtten);
		#endif

			UnityIndirect noIndirect = ZeroIndirect();

			//TCP2 entry point
			TCP2_FragBeforeBRDF(s, tcp2data);

		#if UNITY_VERSION >= 550
			#define SMOOTHNESS s.smoothness
		#else
			#define SMOOTHNESS s.oneMinusRoughness
		#endif

			half4 c = TCP2_BRDF_PBS(s.diffColor, s.specColor, s.oneMinusReflectivity, SMOOTHNESS, s.normalWorld, -s.eyeVec, light, noIndirect, /* TCP2 */ lightAtten
				,i.tex
				);

			UNITY_APPLY_FOG_COLOR(i.fogCoord, c.rgb, half4(0, 0, 0, 0)); // fog towards black in additive pass
			return OutputForward(c, s.alpha);
		}

		half4 fragForwardAdd_TCP2(VertexOutputForwardAdd i) : SV_Target		// backward compatibility (this used to be the fragment entry function)
		{
			return fragForwardAddInternal(i);
		}

		// TCP2_PBS_Core.cginc END
		//================================================================================================================================

		TCP2_VOFwdBase vertBase(TCP2_VertexInput v) { return vertForwardBase_TCP2(v); }
		TCP2_VOFwdAdd vertAdd(TCP2_VertexInput v) { return vertForwardAdd_TCP2(v); }
		half4 fragBase(TCP2_VOFwdBase i) : SV_Target{ return fragForwardBaseInternal_TCP2(i); }
		half4 fragAdd(TCP2_VOFwdAdd i) : SV_Target{ return fragForwardAddInternal_TCP2(i); }

		// TCP2_PBS_Main.cginc END
		//================================================================================================================================

	ENDCG

	//FallBack "VertexLit"
	CustomEditor "TCP2_MaterialInspector_PBS_SG"
}


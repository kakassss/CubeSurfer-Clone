// Toony Colors Pro+Mobile 2
// (c) 2014-2017 Jean Moreno

Shader "Toony Colors Pro 2/Examples/Default/Sketch"
{
	Properties
	{
	[TCP2HeaderHelp(BASE, Base Properties)]
		//TOONY COLORS
		_Color ("Color", Color) = (1,1,1,1)
		_HColor ("Highlight Color", Color) = (0.785,0.785,0.785,1.0)
		_SColor ("Shadow Color", Color) = (0.195,0.195,0.195,1.0)
		
		//DIFFUSE
		_MainTex ("Main Texture", 2D) = "white" {}
	[TCP2Separator]
		
		//TOONY COLORS RAMP
		[TCP2Header(RAMP SETTINGS)]
		
		_RampThreshold ("Ramp Threshold", Range(0,1)) = 0.5
		_RampSmooth ("Ramp Smoothing", Range(0.001,1)) = 0.1
	[TCP2Separator]
	
	[TCP2HeaderHelp(SPECULAR, Specular)]
		//SPECULAR
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range(0.0,2)) = 0.1
	[TCP2Separator]
	
	[TCP2HeaderHelp(SKETCH, Sketch)]
		//SKETCH
		_SketchTex ("Sketch (Alpha)", 2D) = "white" {}
		_SketchSpeed ("Sketch Anim Speed", Range(1.1, 10)) = 6
	[TCP2Separator]
	
	[TCP2HeaderHelp(OUTLINE, Outline)]
		//OUTLINE
		_OutlineColor ("Outline Color", Color) = (0.2, 0.2, 0.2, 1.0)
		_Outline ("Outline Width", Float) = 1
		
		//Outline Textured
		[Toggle(TCP2_OUTLINE_TEXTURED)] _EnableTexturedOutline ("Color from Texture", Float) = 0
		[TCP2KeywordFilter(TCP2_OUTLINE_TEXTURED)] _TexLod ("Texture LOD", Range(0,10)) = 5
		
		//Constant-size outline
		[Toggle(TCP2_OUTLINE_CONST_SIZE)] _EnableConstSizeOutline ("Constant Size Outline", Float) = 0
		
		//ZSmooth
		[Toggle(TCP2_ZSMOOTH_ON)] _EnableZSmooth ("Correct Z Artefacts", Float) = 0
		//Z Correction & Offset
		[TCP2KeywordFilter(TCP2_ZSMOOTH_ON)] _ZSmooth ("Z Correction", Range(-3.0,3.0)) = -0.5
		[TCP2KeywordFilter(TCP2_ZSMOOTH_ON)] _Offset1 ("Z Offset 1", Float) = 0
		[TCP2KeywordFilter(TCP2_ZSMOOTH_ON)] _Offset2 ("Z Offset 2", Float) = 0
		
		//This property will be ignored and will draw the custom normals GUI instead
		[TCP2OutlineNormalsGUI] __outline_gui_dummy__ ("unused", Float) = 0
	[TCP2Separator]
		
		//Avoid compile error if the properties are ending with a drawer
		[HideInInspector] __dummy__ ("unused", Float) = 0
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		
		#pragma surface surf ToonyColorsCustom vertex:vert exclude_path:deferred exclude_path:prepass
		#pragma target 3.0
		
		//================================================================
		// VARIABLES
		
		fixed4 _Color;
		sampler2D _MainTex;
		fixed _SketchSpeed;
		fixed _Shininess;
		fixed4 _Random;
		
		struct Input
		{
			half2 uv_MainTex;
			half4 sketchUv;
		};
		
		//================================================================
		// CUSTOM LIGHTING
		
		//Lighting-related variables
		fixed4 _HColor;
		fixed4 _SColor;
		half _RampThreshold;
		half _RampSmooth;
		sampler2D _SketchTex;
		float4 _SketchTex_ST;
		
		//Custom SurfaceOutput
		struct SurfaceOutputCustom
		{
			half atten;
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			half Specular;
			fixed Gloss;
			fixed Alpha;
			half2 ScreenUVs;
		};
		
		inline half4 LightingToonyColorsCustom (inout SurfaceOutputCustom s, half3 viewDir, UnityGI gi)
		{
			half3 lightDir = gi.light.dir;
		#if defined(UNITY_PASS_FORWARDBASE)
			half3 lightColor = _LightColor0.rgb;
			half atten = s.atten;
		#else
			half3 lightColor = gi.light.color.rgb;
			half atten = 1;
		#endif
			
			s.Normal = normalize(s.Normal);
			fixed ndl = max(0, dot(s.Normal, lightDir));
			#define NDL ndl
	
			#define		RAMP_THRESHOLD	_RampThreshold
			#define		RAMP_SMOOTH		_RampSmooth
			
			fixed3 ramp = smoothstep(RAMP_THRESHOLD - RAMP_SMOOTH*0.5, RAMP_THRESHOLD + RAMP_SMOOTH*0.5, NDL);
		#if !(POINT) && !(SPOT)
			ramp *= atten;
		#endif
			//Sketch
			fixed sketch = tex2D(_SketchTex, s.ScreenUVs).a;
			sketch = lerp(sketch, 1, ramp);	//Regular sketch overlay
		#if !defined(UNITY_PASS_FORWARDBASE)
			_SColor = fixed4(0,0,0,1);
		#endif
			_SColor = lerp(_HColor, _SColor, _SColor.a);	//Shadows intensity through alpha
			ramp = lerp(_SColor.rgb, _HColor.rgb, ramp);
			//Specular
			half3 h = normalize(lightDir + viewDir);
			float ndh = max(0, dot (s.Normal, h));
			float spec = pow(ndh, s.Specular*128.0) * s.Gloss * 2.0;
			spec *= atten;
			fixed4 c;
			c.rgb = s.Albedo * lightColor.rgb * ramp;
		#if (POINT || SPOT)
			c.rgb *= atten;
		#endif
			c.rgb += lightColor.rgb * _SpecColor.rgb * spec;
			c.a = s.Alpha * _SpecColor.a * spec;
			c.rgb *= sketch;
			
		#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
			c.rgb += s.Albedo * gi.indirect.diffuse;
		#endif
			
			return c;
		}
		
		void LightingToonyColorsCustom_GI(inout SurfaceOutputCustom s, UnityGIInput data, inout UnityGI gi)
		{
			gi = UnityGlobalIllumination(data, 1.0, s.Normal);
			
			gi.light.color = _LightColor0.rgb;	//remove attenuation
			s.atten = data.atten;	//transfer attenuation to lighting function
		}
	
	//Adjust screen UVs relative to object to prevent screen door effect
	inline void ObjSpaceUVOffset(inout float2 screenUV, in float screenRatio)
	{
		// UNITY_MATRIX_P._m11 = Camera FOV
		float4 objPos = float4(-UNITY_MATRIX_T_MV[3].x * screenRatio * UNITY_MATRIX_P._m11, -UNITY_MATRIX_T_MV[3].y * UNITY_MATRIX_P._m11, UNITY_MATRIX_T_MV[3].z, UNITY_MATRIX_T_MV[3].w);
		
		float offsetFactorX = 0.5;
		float offsetFactorY = offsetFactorX * screenRatio;
		offsetFactorX *= _SketchTex_ST.x;
		offsetFactorY *= _SketchTex_ST.y;
		
		if (unity_OrthoParams.w < 1)	//don't scale with orthographic camera
		{
			//adjust uv scale
			screenUV -= float2(offsetFactorX, offsetFactorY);
			screenUV *= objPos.z;	//scale with cam distance
			screenUV += float2(offsetFactorX, offsetFactorY);
			
			// sign(UNITY_MATRIX_P[1].y) is different in Scene and Game views
			screenUV.x -= objPos.x * offsetFactorX * sign(UNITY_MATRIX_P[1].y);
			screenUV.y -= objPos.y * offsetFactorY * sign(UNITY_MATRIX_P[1].y);
		}
		else
		{
			// sign(UNITY_MATRIX_P[1].y) is different in Scene and Game views
			screenUV.x += objPos.x * offsetFactorX * sign(UNITY_MATRIX_P[1].y);
			screenUV.y += objPos.y * offsetFactorY * sign(UNITY_MATRIX_P[1].y);
		}
	}
		
		//================================================================
		// VERTEX FUNCTION
		
		struct appdata_tcp2
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
		};
		
		void vert(inout appdata_tcp2 v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			
			//Sketch
			float4 pos = UnityObjectToClipPos(v.vertex);
			o.sketchUv = ComputeScreenPos(pos);
			o.sketchUv.xy = TRANSFORM_TEX(o.sketchUv, _SketchTex);
		}

		//================================================================
		// SURFACE FUNCTION

		void surf(Input IN, inout SurfaceOutputCustom o)
		{
			fixed4 mainTex = tex2D(_MainTex, IN.uv_MainTex);
			
			o.Albedo = mainTex.rgb * _Color.rgb;
			o.Alpha = mainTex.a * _Color.a;
			
			//Sketch
			float2 screenUV = IN.sketchUv.xy / IN.sketchUv.w;
			float screenRatio = _ScreenParams.y / _ScreenParams.x;
			screenUV.y *= screenRatio;
			ObjSpaceUVOffset(screenUV, screenRatio);
			_Random.x = round(_Time.z * _SketchSpeed) / _SketchSpeed;
			_Random.y = -round(_Time.z * _SketchSpeed) / _SketchSpeed;
			screenUV.xy += frac(_Random.xy);
			o.ScreenUVs = screenUV;
			
			//Specular
			_Shininess *= mainTex.a;
			o.Gloss = 1;
			o.Specular = _Shininess;
		}
		
		ENDCG
		
		//Outlines
		UsePass "Hidden/Toony Colors Pro 2/Outline Only/OUTLINE"
	}
	
	Fallback "Diffuse"
	CustomEditor "TCP2_MaterialInspector_SG"
}

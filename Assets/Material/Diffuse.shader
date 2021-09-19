Shader "Unlit/Diffuse"
{

Properties
{
	_color("color", Color) = (.25, .5, .5, 1)
}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

		struct appdata
		{
			// vertex in model space
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			float4 vertex : SV_POSITION;
		};

		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);

			return o;
		}

		float4 _color;

		fixed4 frag(v2f i) : SV_Target
		{
			//get chosen color in inspector
			fixed4 col = _color;
			return col;
		}

		ENDCG

		}
	}
}
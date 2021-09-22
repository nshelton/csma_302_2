Shader "Unlit/hologram"
{
   Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1, 0, 0, 1)
		_Bias("Bias", Float) = 0
		_frequency ("frequency", Float) = 100
		_speed ("speed", Float) = 100
	}
	SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
		LOD 100
		ZWrite Off
		Blend SrcAlpha One
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				// vertex in model space
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

                // normal in model space
                float3 normal : NORMAL;
                // tangent in model space
                float4 tangent : TANGENT;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
				float4 worldPos : TEXCOORD1;
			};

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Bias;
			float _frequency;
			float _speed;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                clip(sin(i.worldPos.y * _frequency));
				fixed4 col = tex2D(_MainTex, i.uv);
				col = _Color * max(0, cos(i.worldPos.y * _frequency + _Time.x * _speed) + max(0, sin(_Bias * _Time.x)));
				col *= 1 - max(0, cos(i.worldPos.x * _frequency + _Time.x * _speed) + 0.9);
				return col;
			}
			ENDCG
		}
	}
}
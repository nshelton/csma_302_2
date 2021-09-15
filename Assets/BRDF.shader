Shader "Unlit/BRDF"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _BRDF ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            //sampler2D _MainTex;
            sampler2D _BRDF;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                lightDir = _WorldSpaceLightPos0.xyz;
                viewAngle = dot(viewDir, i.normal);
                lightAngle = dot(lightDir, i.normal) / 2 + 0.5;


                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_BRDF, float2(viewAngle, lightAngle));
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}

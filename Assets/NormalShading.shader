Shader "Hidden/Diffuse"
{
    Properties
    {
        _color("color", Color) = (.25, .5, .5, 1)
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal: NORMAL;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                
                // float4 p = mul(UNITY_MATRIX_M, v.vertex)
                // p = mul(UNITY_MATRIX_V, p);
                // p = mul(UNITY_MATRIX_P, p);

                o.normal = v.normal;
                return o;
            }

            float4 _color;

            fixed4 frag (v2f i) : SV_Target
            {
               //sample texture
                float3 lightDir = float3(1,0,0);
                float brightness = dot(i.normal, lightDir);
                fixed4 col = brightness * _color;
                return col;
            }
            ENDCG
        }
    }
}

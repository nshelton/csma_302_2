Shader "Unlit/NormalMap"
{
        Properties
    {
        _color("color", Color) = (0.25, 0.5, 0.5, 1.0)
        _normalMap
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
                //vertex in model space
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

                //normal in model space
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _color;
            sampler2D _normalMap;

            fixed4 frag(v2f i) : SV_Target
            {
                float3 lightDir = i.worldPos - _WorldSpaceCameraPos;
                lightDir = normalize(lightDir);

                float brightness = dot(i.normal, lightDir);
                fixed4 col = brightness * _color;

                float3 nmap = tex2d(_normalMap, i.uv);
                col = fixed4(nmap, 1.0);


                return col;
            }
        ENDCG
        }
    }
}



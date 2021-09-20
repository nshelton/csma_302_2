Shader "Unlit/HGenshin"
{
    Properties
    {
        _color("Color", Color) = (1, 0, 0, 0)
        _MainTex ("Texture", 2D) = "white" {}
        _NormalTex("Normal Tex", 2D) = "white" {}
        _SpecColor("Spec Color", Color) = (1, 0, 0, 0)
        _Shininess ("Shininess", Range (0.01, 1)) = 0.078125

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
            uniform float4 _LightColor0; 

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            sampler2D _MainTex;
            sampler2D _NormalTex;
            float4 _MainTex_ST;
            float4 _color;
            float _DeltaX;
            float _DeltaY;
            float4 _SpecColor;
            float _Shininess;
            uniform sampler2D _LightTextureB0; 

            // Genshin is like a cel shader, but it has an outline around the mesh
            // So edge detection and cel shading? (i think that's how they do it)

            float3 worldNormalFromMap(v2f i)
            {
                float3 binormal = cross(i.normal, i.tangent.xyz) * i.tangent.w;
                // specify rows of the matrix
                float3x3 TBN_matrix = float3x3(i.tangent.xyz, binormal, i.normal);
                TBN_matrix = transpose(TBN_matrix);    // flip the rows to columns
                // get (tangent space) normal from normal map
                float3 normal = UnpackNormal(tex2D(_NormalTex, i.uv));
                // convert tangent space to world space
                return mul(TBN_matrix, normal);
            }

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                o.normal = normalize(o.normal);

                o.tangent.xyz = mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0));
                o.tangent.xyz = normalize(o.tangent.xyz);
                o.tangent.w = v.tangent.w;

                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                o.uv = v.uv;
                return o;
            }

            // Adapted from https://en.wikibooks.org/wiki/GLSL_Programming/Unity/Toon_Shading

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float4 col = tex2D(_MainTex, i.uv);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                lightDir = normalize(lightDir);

                float3 viewDir = _WorldSpaceCameraPos - i.worldPos;
                viewDir = normalize(viewDir);

                float distance = _WorldSpaceLightPos0.xyz.z;
                float attenuation = tex2D(_LightTextureB0, float2(distance, distance)).a;

                float3 normal = worldNormalFromMap(i);

                // Outline
                float thickness = 1;
                if (dot(viewDir, normal) < lerp(0.1 * thickness, 0.4 * thickness, max(0.0, dot(normal, lightDir)))) {
                    col = float4(0,0,0,1);
                }

                // Light toon shadow
                if (dot(i.normal, lightDir) > 0.0
                    && attenuation * pow(max(0.0, dot(reflect(-lightDir, normal), viewDir)), _Shininess) > 0.1) {
                        col = _SpecColor.a * _LightColor0 * _SpecColor
                        + (1.0 - _SpecColor.a) * col;
                        col = float4(0.4, 0.4, 0.4, 0);
                }

                // Dark toon shadow
                if (dot(i.normal, lightDir) > 0.0
                    && attenuation * pow(max(0.0, dot(reflect(-lightDir, normal), viewDir)), _Shininess) > 0.5) {
                        col = _SpecColor.a * _LightColor0 * _SpecColor
                        + (1.0 - _SpecColor.a) * col;
                }

                return col;
            }
            ENDCG
        }
    }
}

Shader "Unlit/environmentreflection"
{
    Properties
    {
        _color("Color", Color) = (1, 0, 0, 0)
        _NormalMap("normal map", 2D) = "white" {}
        _ReflectionTex("Reflection", 2D) = "white" {}
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
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;

            };

            float4 _color;
            sampler2D _NormalMap;
            sampler2D _ReflectionTex;
            float4 _MainTex_ST;
            float4 _LightColor0;
            float4 _SpecColor;
            float _Shininess;

            float3 worldNormalFromMap(v2f i)
            {
                float3 binormal = cross(i.normal, i.tangent.xyz) * i.tangent.w;
                // specify rows of the matrix
                float3x3 TBN_matrix = float3x3(i.tangent.xyz, binormal, i.normal);
                TBN_matrix = transpose(TBN_matrix);    // flip the rows to columns
                // get (tangent space) normal from normal map
                float3 normal = UnpackNormal(tex2D(_NormalMap, i.uv));
                // convert tangent space to world space
                return mul(TBN_matrix, normal);
            }

            float lambert(float3 normal, float3 lightpos){
                float3 normalNorm = normalize(normal);
                float3 normalLight = normalize(lightpos);
                float n = dot(normalNorm, normalLight);
                return max(n, 0.0);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldSpaceNormal = worldNormalFromMap(i);

                float3 viewSpaceNormal = mul(UNITY_MATRIX_V, float4(worldSpaceNormal, 0));
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                lightDir = normalize(lightDir);

                // scale [-1, 1] to [0, 1]
                float2 muv = viewSpaceNormal.xy * 0.5 + 0.5;

                return tex2D(_ReflectionTex, float2(muv.x, muv.y)) * dot(worldNormalFromMap(i), lightDir);
            }
            ENDCG
        }
    }
}

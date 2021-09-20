Shader "Unlit/HEnvironment"
{
    Properties
    {
        _color ("Color", Color) = ( 1, 0, 0, 0)
        _NormalTex ("Normal Map", 2D) = "white" {}
        _EnvCube ("Environment Map", CUBE) = "white" {}
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            float4 _color;
            sampler2D _NormalTex;
            samplerCUBE _EnvCube;
            float4 _MainTex_ST;

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
            struct vertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct vertexOutput {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
            };

            // Adapted from https://en.wikibooks.org/wiki/Cg_Programming/Unity/Reflecting_Surfaces

            vertexOutput vert(vertexInput input) 
            {
                vertexOutput output;
    
                float4x4 modelMatrix = unity_ObjectToWorld;
                float4x4 modelMatrixInverse = unity_WorldToObject; 
    
                output.viewDir = mul(modelMatrix, input.vertex).xyz 
                - _WorldSpaceCameraPos;
                output.normalDir = normalize(
                mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
                output.pos = UnityObjectToClipPos(input.vertex);
                return output;
            }

            float4 frag(vertexOutput input) : COLOR
            {
                float3 reflectedDir = 
                reflect(input.viewDir, normalize(input.normalDir));
                return texCUBE(_EnvCube, reflectedDir);
            }
            ENDCG
        }
        
    }
    Fallback "Diffuse"
}

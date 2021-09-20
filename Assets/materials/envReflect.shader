Shader "Unlit/normalMap"
{
    Properties
    {
        _Cube("Reflection Map", Cube) = "" {}
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

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
            };
    
            v2f vert(appdata v) 
            {
                v2f o;
    
                float4x4 modelMatrix = unity_ObjectToWorld;
                float4x4 modelMatrixInverse = unity_WorldToObject; 
    
                o.viewDir = mul(modelMatrix, v.vertex).xyz - _WorldSpaceCameraPos;
                o.normalDir = normalize(mul(float4(v.normal, 0.0), modelMatrixInverse).xyz);
                o.pos = UnityObjectToClipPos(v.vertex);

                return o;
            }

            samplerCUBE _Cube;

            fixed4 frag(v2f i) : SV_Target
            {
                float3 reflectedDir = reflect(i.viewDir, normalize(i.normalDir));

                return texCUBE(_Cube, reflectedDir);
            }
            ENDCG
        }
    }
}

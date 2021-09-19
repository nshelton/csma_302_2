Shader "Unlit/MatCap"
{

Properties
{
 _color("color", Color) = (.25, .5, .5, 1)
_NormalMap("normal map", 2D) = "blue" {}
_MatcapTexture("matcapTexture", 2D) = "white" {}
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
            float3 worldPos : TEXCOORD1;
        };

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

        float4 _color;
        sampler2D _NormalMap;
        sampler2D _MatcapTexture;

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


        fixed4 frag(v2f i) : SV_Target
        {
            float3 worldSpaceNormal = worldNormalFromMap(i);

            float3 viewSpaceNormal = mul(UNITY_MATRIX_V, float4(worldSpaceNormal, 0));

            // scale [-1, 1] to [0, 1]
            float2 muv = viewSpaceNormal.xy * 0.5 + 0.5;

            return tex2D(_MatcapTexture, float2(muv.x, muv.y));
        }
        
        ENDCG

        }
    }
}
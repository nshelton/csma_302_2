// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/H_BDRF"
{
    Properties
    {

        _color("color", Color) = ( 0.25, 0, 0, 1 )
        _bdrf("bdrf", 2D) = "blue"
        _NormalMap("normal map", 2D) = "blue" {}

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

            v2f vert (appdata v)
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

            sampler2D _bdrf;
            sampler2D _NormalMap;
            float4 _color;

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

            fixed4 frag (v2f i) : SV_Target
            {

                float3 worldNormal = worldNormalFromMap(i);

                float3 lightDir = _WorldSpaceLightPos0.xyz;
                lightDir = normalize(lightDir);

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float viewAngle = dot(viewDir, worldNormal);
                float lightAngle = dot(lightDir, worldNormal) / 2 + 0.5;
                //float lightAngle = dot(lightDir, i.normal);

                // I noticed when the lightAngle wasn't scaled, the colors were less saturated on the model
                // I think lightAngle is scaled because if it wasn't the colors would be dark and innacurate.

                fixed4 col = tex2D(_bdrf, float2(viewAngle, lightAngle));               

                return col;
            }
            ENDCG
        }
    }
}

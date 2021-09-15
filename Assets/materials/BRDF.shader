Shader "Unlit/BRDF"
{
    Properties
    {
        _color("color", Color) = (.25, .5, .5, 1)
        _BRDF("BRDF", 2D) = "white" {}
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
                float4 tangent : TANGENT;

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD1;
                float4 tangent : TANGENT;

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

            sampler2D _BRDF;
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

                float3 lightDir = _WorldSpaceCameraPos - i.worldPos;
                lightDir = normalize(lightDir);

                float3 n = worldNormal;
                float brightness = dot(n, lightDir);

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float viewAngle = dot(viewDir, i.normal);
                //float lightAngle = dot(lightDir, i.normal); //<--- uncomment this to see the difference if lightAngle wasn't scaled.
                float lightAngle = dot(lightDir, i.normal) / 2 + 0.5;

                // I noticed when the lightAngle wasn't scaled, the colors were darker on the model and the edges were highlighted much
                // I think lightAngle is scaled because if it wasn't the edges of the model would just look like shadows rather than a highlight of the edges.

                fixed4 col = tex2D(_BRDF, float2(viewAngle, lightAngle));               

                return brightness * col;
            }
            ENDCG



        }
    }
}

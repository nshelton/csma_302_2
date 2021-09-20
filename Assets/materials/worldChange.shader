Shader "Unlit/brdf_shader"
{
    Properties
    {
        _NormalMap("normal map", 2D) = "blue" {}
        _BRDF ("BRDF Ramp", 2D) = "gray" {}
        _BRDF2 ("BRDF Ramp 2", 2D) = "black" {}
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

            sampler2D _NormalMap;
            sampler2D _BRDF;
            sampler2D _BRDF2;
            float4 _MainTex_ST;


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

            /*
                In-game, you just need to make sure you move the camera preferably in the z direction (towards the statue) in order
                to see it change textures -- you can do so by clicking and dragging your mouse across the z-coordinate :P 
            */

            fixed4 frag (v2f i) : SV_Target
            {
                float3 world_normal = worldNormalFromMap(i);

                float3 light_direction = _WorldSpaceLightPos0.xyz;
                light_direction = normalize(light_direction);

                float3 n = world_normal;

                float3 view_direction = normalize(_WorldSpaceCameraPos - i.worldPos);

                float view_angle = saturate(dot(view_direction, world_normal));

                float light_angle = dot(light_direction, world_normal) / 2 + 0.5;   // [-1, 0, 1] > [-0.5, 0, 0.5] > [0, 1]

                float dist = distance(_WorldSpaceCameraPos, float4(0.0, 0.0, 0.0, 0.1));

                if(dist < 5.0){
                    return tex2D(_BRDF, float2(view_angle, light_angle));
                }else{
                    return tex2D(_BRDF2, float2(view_angle, light_angle));
                }

            }
            ENDCG
        }
    }
}

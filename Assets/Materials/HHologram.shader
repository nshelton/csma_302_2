Shader "Unlit/HHologram"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalTex ("Normal Map", 2D) = "white" {}
        _distortionOffset ("Distortion Offset", Range (0.01, 1)) = 0.078125
        _distortion ("Distortion", Range (0.01, 1)) = 0.078125
        _frequency ("Frequency", Range (0.01, 1)) = 0.078125
        _speed ("Speed", Range (0.01, 1)) = 0.078125
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100
                // additive blending
        Blend One One
        // disable blackface bulling
        //Cull Off
        // don't write to the depth buffer
        ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Packages/jp.keijiro.noiseshader/Shader/SimplexNoise3D.hlsl"

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

            sampler2D _MainTex;
            sampler2D _NormalTex;
            float4 _MainTex_ST;
            float _distortionOffset;
            float _distortion;
            float _frequency;
            float _speed;

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
            float4 distortion(float3 p) {
                // different type of displacement along normal
                //   float4 displacement = _disortion * float4(v.normal, 0) * 
                //       (SimplexNoise(v.vertex.xyz * _frequency + _Time.y) * 0.5 + 0.5);

                return saturate(p.y - _distortionOffset) * _distortion * float4(
                    SimplexNoise(p * _frequency + _Time.y * _speed * _SinTime * 120000),
                    SimplexNoise(p * _frequency + _Time.y * _speed + 131.678),
                    SimplexNoise(p * _frequency + _Time.y * _speed + 272.874),
                    0);
            }
            v2f vert (appdata v)
            {
                v2f o;

                float4 displacement = distortion(v.vertex.xyz);
                o.vertex = UnityObjectToClipPos(v.vertex + displacement);


                o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                o.normal = normalize(o.normal);

                o.tangent.xyz = mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0));
                o.tangent.xyz = normalize(o.tangent.xyz);
                o.tangent.w = v.tangent.w;

                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                o.uv = v.uv;

                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                //clip();
                // sample the texture
                float3 worldNormal = worldNormalFromMap(i);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                lightDir = normalize(lightDir);

                float3 n = worldNormal;
                
                float brightness = 0.3;
                float2 ghostuv = i.uv;
                fixed4 col =  tex2D(_MainTex, i.uv);
                col *= brightness;

                col.b = 1;
                col.g += 0.4;

                col.rgb -= SimplexNoise(i.worldPos.y * 4 + _Time.y * 2)/3;
                //col.rgb /= normalize(SimplexNoise(i.worldPos.y * 6 + _Time.y));
                
                //fixed4 col = float4(1,0,0,1);

                return col;
            }
            ENDCG
        }
    }
}

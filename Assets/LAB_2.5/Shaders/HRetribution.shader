Shader "Unlit/HRetribution"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalTex ("Normal Texture", 2D) = "white" {}
        _FireTex ("Fireee!", 2D) = "white" {}

        _frequency("frequency", Float) = 5
        _speed("speed", Float) = 2
        _intensity("intensity", Float) = 0.15
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        // additive blending
        // Blend One One
        // disable backface culling
        // Cull Off
        // don't write to the depth buffer
        // ZWrite Off
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
                appdata appdata : APPDATA;
            };

            sampler2D _MainTex;
            sampler2D _NormalTex;
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
                o.appdata = v;

                return o;
            }

            float _frequency;
            float _speed;
            float _intensity;

            float4 distortion(float3 p, appdata v) {
                // different type of displacement along normal
                //   float4 displacement = _disortion * float4(v.normal, 0) * 
                //       (SimplexNoise(v.vertex.xyz * _frequency + _Time.y) * 0.5 + 0.5);
                return _intensity * float4(v.normal, 0) * float4(
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1) / 2,
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1),
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1) / 1.2,
                    0);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldNormal = worldNormalFromMap(i);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                lightDir = normalize(lightDir);

                fixed4 col = tex2D(_MainTex, i.uv);
                col *= dot(lightDir, worldNormal) * 2;
                return col;
            }
            ENDCG
        }

        Pass
        {
            Name "Highlights"
            Tags { "RenderType"="Transparent" }
            LOD 100
            // Cull Off
            Blend Off
            // ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
      
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
                appdata appdata : APPDATA;
            };
            
            sampler2D _MainTex;
            sampler2D _NormalTex;
            float4 _MainTex_ST;
            sampler2D _FireTex;



            float3 worldNormalFromMap(v2f i)
            {
                float3 binormal = cross(i.normal, i.tangent.xyz) * i.tangent.w;
                // specify rows of the matrix
                float3x3 TBN_matrix = float3x3(i.tangent.xyz, binormal, i.normal);
                TBN_matrix = transpose(TBN_matrix);    // flip the rows to columns
                // get (tangent space) n    ormal from normal map
                float3 normal = UnpackNormal(tex2D(_NormalTex, i.uv));
                // convert tangent space to world space
                return mul(TBN_matrix, normal);
            }
            
            float _frequency;
            float _speed;
            float _intensity;

            float4 distortion(float3 p, appdata v) {
                // different type of displacement along normal
                //   float4 displacement = _disortion * float4(v.normal, 0) * 
                //       (SimplexNoise(v.vertex.xyz * _frequency + _Time.y) * 0.5 + 0.5);
                return _intensity * float4(
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1) / 2,
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1),
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1) / 1.2,
                    0);
            }

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex + distortion(v.vertex.xyz, v)/4);

                o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                o.normal = normalize(o.normal);

                o.tangent.xyz = mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0));
                o.tangent.xyz = normalize(o.tangent.xyz);
                o.tangent.w = v.tangent.w;

                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                o.uv = v.uv;
                o.appdata = v;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {                
                float3 dist = distortion(float3(i.uv, 1), i.appdata);
                fixed4 col = tex2D(_MainTex, i.uv + dist);
                clip(dist);
                // dist /=
                col.r += dist.x;
                col.g += dist.y;
                col.b += dist.z;
                // col *= 10;
                return col;
            }
            ENDCG
        }

        Pass
        {
            Name "Fire"
            Tags { "RenderType"="Opaque" }
            LOD 100
            Cull Off
            Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
      
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
            sampler2D _FireTex;



            float3 worldNormalFromMap(v2f i)
            {
                float3 binormal = cross(i.normal, i.tangent.xyz) * i.tangent.w;
                // specify rows of the matrix
                float3x3 TBN_matrix = float3x3(i.tangent.xyz, binormal, i.normal);
                TBN_matrix = transpose(TBN_matrix);    // flip the rows to columns
                // get (tangent space) n    ormal from normal map
                float3 normal = UnpackNormal(tex2D(_NormalTex, i.uv));
                // convert tangent space to world space
                return mul(TBN_matrix, normal);
            }
            
            float _frequency;
            float _speed;
            float _intensity;

            float4 distortion(float3 p, appdata v) {
                // different type of displacement along normal
                //   float4 displacement = _disortion * float4(v.normal, 0) * 
                //       (SimplexNoise(v.vertex.xyz * _frequency + _Time.y) * 0.5 + 0.5);
                return _intensity * float4(
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1) / 5,
                    SimplexNoise(p * _frequency * 6 + _speed * _Time.y * 1),
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1) / 1.2,
                    0);
            }

            v2f vert(appdata v)
            {
                v2f o;

                float4 displacement = distortion(v.vertex.xyz, v);
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

            fixed4 frag(v2f i) : SV_Target
            {                
                float3 lightDir = _WorldSpaceLightPos0.xyz;

                fixed4 col = tex2D(_FireTex, i.uv);
                col -= lightDir.x / 3;
                return col;
            }
            ENDCG
        }
        
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            LOD 100
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
      
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
                appdata appdata : APPDATA;
            };
            
            sampler2D _MainTex;
            sampler2D _NormalTex;
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

            float _frequency;
            float _speed;
            float _intensity;

            float4 distortion(float3 p, appdata v) {
                // different type of displacement along normal
                //   float4 displacement = _disortion * float4(v.normal, 0) * 
                //       (SimplexNoise(v.vertex.xyz * _frequency + _Time.y) * 0.5 + 0.5);
                return _intensity * float4(
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1) / 2,
                    SimplexNoise(p * _frequency * 6 + _speed * _Time.y * 1),
                    SimplexNoise(p * _frequency + _speed * _SinTime * 1) / 1.2,
                    0);
            }

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex + distortion(v.vertex.xyz, v)/6);

                o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                o.normal = normalize(o.normal);

                o.tangent.xyz = mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0));
                o.tangent.xyz = normalize(o.tangent.xyz);
                o.tangent.w = v.tangent.w;

                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                o.appdata = v;
                o.uv = v.uv;

                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                //clip(sin(i.worldPos.y * 10));
                fixed4 col =  tex2D(_MainTex, i.uv);

                return col;
            }
            ENDCG
        }
    }
}

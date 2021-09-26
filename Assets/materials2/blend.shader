Shader "Unlit/blend"
{
    Properties
    {
        _NormalMap("normal map", 2D) = "blue" {}
        _DiffuseMap("Diffuse Map", 2D) = "white" {}
        _brightness("brightness", float) = 0
        _color("color", Color) = (1, 0, 0, 1)
        _Width("Width", Float) = 0.6
        _Frequency("Frequency", Float) = 0 //you can change the frequency to see how the object will be drawn using this shader


    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100

        // additive blending
        Blend One One
        // disable blackface bulling
        Cull Off
        // don't write to the depth buffer
        ZWrite Off

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
                float4 obj_vertex : TEXCOORD2;

            };

            sampler2D _DiffuseMap;
            sampler2D _NormalMap;
            float4 _DiffuseMap_ST;
            fixed4 _color;
            float _Width;
            float _brightness;
            float  _Frequency;

            v2f vert (appdata v)
            {
                v2f o;
                o.obj_vertex = mul(unity_ObjectToWorld, v.vertex);

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


             fixed4 frag(v2f i) : SV_Target
            {
                float3 worldNormal = worldNormalFromMap(i);

                float3 lightDir = _WorldSpaceCameraPos - i.worldPos;
                lightDir = normalize(lightDir);

                float3 n = worldNormal;
                float brightness = dot(n, lightDir);

                fixed4 col = tex2D(_DiffuseMap, i.uv);

                col =  _color * max(0, sin(i.obj_vertex.y * _Frequency) + _Width);
                col *=  1 - max(0, sin(i.obj_vertex.x * _Frequency) + _Width);
                col *=  1 - max(0, sin(i.obj_vertex.z * _Frequency) + _Width);


                return col;
            }
            ENDCG
        }
    }
}

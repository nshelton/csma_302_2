Shader "Unlit/HPhong"
{
    Properties
    {
        _color("Color", Color) = (1, 0, 0, 0)
        _NormalTex("Normal Map", 2D) = "white" {}
        _Shininess("Shininess", Float) = 10 //Shininess
        _SpecColor("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
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
            float4 _MainTex_ST;
            uniform float4 _LightColor0; //From UnityCG
            uniform float4 _SpecColor;
            uniform float _Shininess;

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

            float lambert(float3 normal, float3 lightpos) {
                float3 normalN = normalize(normal);
                float3 normalL = normalize(lightpos);
                float res = dot(normalN, normalL);
                return max(res, 0.0);
            }

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                // https://janhalozan.com/2017/08/12/phong-shader/
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 viewDirection = normalize(_WorldSpaceCameraPos - i.worldPos.xyz);
                lightDir = normalize(lightDir);

                float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _color.rgb;
                float3 specularReflection = _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-lightDir, normalize(i.normal)), viewDirection)), _Shininess);
                float3 diffuseReflection = _LightColor0.rgb * _color.rgb * max(0.0, dot(normalize(i.normal), lightDir));

                float3 col = (ambientLighting + diffuseReflection) * tex2D(_NormalTex, i.uv) + specularReflection;
                col *= dot(worldNormalFromMap(i), lightDir);

                return float4(col, 0.0);
            }
            ENDCG
        }
    }
}
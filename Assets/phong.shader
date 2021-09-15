Shader "Unlit/phong"
{
    Properties
    {
        _color("color", Color) = (.25, .5, .5, 1)
        _ambient("ambient", Color) = (.25, .5, .5, 1)
        _highlight("highlight", Color) = (.25, .5, .5, 1)
        _shininess("shininess", float) = 1
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD1;

            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float4 _color;
            float4 _ambient;
            float _shininess;
            float4 _highlight;

            fixed4 frag(v2f i) : SV_Target
            {

                float3 viewDir = _WorldSpaceCameraPos - i.worldPos;
                viewDir = normalize(viewDir);

                float3 n = normalize(i.normal);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                
                float diffuse = dot(n, lightDir);
                fixed4 col = diffuse * _color;

                col += _ambient;

                float3 r = reflect(lightDir, n);
                float specular = max(-dot(r, viewDir), 0);
                specular = pow(specular, _shininess);

                col += specular * _highlight;


                return col;
            }
            ENDCG
        }
    }
}

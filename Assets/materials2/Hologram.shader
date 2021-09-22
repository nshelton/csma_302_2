// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Hologram"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _color("color", Color) = (1, 0, 0, 1)
        _Width("Width", Float) = 0.6
        _Frequency("Frequency", Float) = 1000
        _Speed("Speed", Float) = -500
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
        Zwrite off
        Blend SrcAlpha One
        Cull off

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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 obj_vertex : TEXCOORD1;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _color;
            float _Width;
            float _Frequency;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.obj_vertex = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // hit play in the scene view to see the hologram animated
                col =  _color * max(0, sin(i.obj_vertex.y * _Frequency + _Time.x * _Speed) + _Width);
                col *=  1 - max(0, sin(i.obj_vertex.x * _Frequency + _Time.x * _Speed) + _Width);
                col *=  1 - max(0, sin(i.obj_vertex.z * _Frequency + _Time.x * _Speed) + _Width);

                return col;
            }
            ENDCG
        }
    }
}

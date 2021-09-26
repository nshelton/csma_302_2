// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/HologramCustom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _color("color", Color) = (1, 0, 0, 1)
        _Width("Width", Float) = 0.1
        //these properties will animate the hologram to appear for a small amount of time and then disappear from the top down
        _Frequency("Frequency", Float) = 10
        _Speed("Speed", Float) = 15
        _distortionFrequency("distortionFrequency", Float) = 1000
        _distortionAmount("distortionAmount", Float) = 0.001
        _brightness("brightness", float) = 50

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
            float _distortionFrequency;
            float _distortionAmount;
            float _brightness;

            v2f vert (appdata v)
            {
                v2f o;
                o.obj_vertex = mul(unity_ObjectToWorld, v.vertex);
                
                //added noise in the x, y, and z direction of the hologram to make more static 
                float4 displacement = float4 (
                    _distortionAmount * sin(_distortionFrequency * v.vertex.x + _Time.x * _Speed),
                     0, 0, 0);

                displacement += float4 (
                    _distortionAmount/2 * sin(_distortionFrequency*2 * v.vertex.x + _Time.x * _Speed),
                     0, 0, 0);

                displacement += float4 (
                    _distortionAmount/2 * sin(_distortionFrequency*4 * v.vertex.y + _Time.y * _Speed),
                     0, 0, 0);

                displacement += float4 (
                    0, _distortionAmount/2 * sin(_distortionFrequency*4 * v.vertex.y + _Time.y * _Speed), 0, 0);

                displacement += float4 (
                    0, 0, _distortionAmount * sin(_distortionFrequency*6 * v.vertex.z + _Time.z * _Speed), 0);

                displacement += float4 (
                    0, 0, 0, _distortionAmount * sin(_distortionFrequency*6 * v.vertex.z + _Time.z * _Speed));


                o.vertex = UnityObjectToClipPos(v.vertex + displacement);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // hit play in the scene view to see the hologram animated
                col =  _brightness/100 * _color * max(0, cos(i.obj_vertex.y * _Frequency + _Time.x * _Speed) + _Width);
                //added a brightness to the hologram to gauge how intense the lighting is on the hologram. Can be changed in the inspector.

                //col *=  1 - max(0, cos(i.obj_vertex.x * _Frequency + _Time.x * _Speed) + _Width);
                //col *=  1 - max(0, cos(i.obj_vertex.z * _Frequency + _Time.x * _Speed) + _Width);

                return col;
            }
            ENDCG
        }
    }
}

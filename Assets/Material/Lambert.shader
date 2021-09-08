Shader "Unlit/Lambert"
{
    Properties
    {
        _color("color", Color) = (.25, .5, .5, 1)
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

    v2f vert(appdata v)
    {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.normal = mul(unity_ObjectToWorld, float4(v.normal, 0));
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        return o;
    }

    float4 _color;

    fixed4 frag(v2f i) : SV_Target
    {
        float3 lightDir = _WorldSpaceCameraPos - i.worldPos;
        lightDir = normalize(lightDir);
        float3 n = normalize(i.normal);

        lightDir = _WorldSpaceLightPos0.xyz;

        float brightness = dot(n, lightDir);
        fixed4 col = brightness * _color;

        return col;
    }
    ENDCG
}
    }
}
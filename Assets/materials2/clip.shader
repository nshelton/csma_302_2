Shader "Unlit/clip"
{
    Properties
    {
        _NormalMap("normal map", 2D) = "blue" {}
        _DiffuseMap("Diffuse Map", 2D) = "white" {}
        _disortion("ditortion", float) = 0
        _frequency ("frequency", float) = 100
        _speed("speed", float) = 0
        _distortionOffset("distortionOffset", float) = 0
        _Color("Color", Color) = (1, 0, 0, 1)
            
    }
    SubShader
    {
        Tags { "RenderType"= "Transparent" "Queue" = "Transparent" }
        LOD 100
            Cull Off
            Blend One One
            ZTest Always
            ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Packages/jp.keijiro.noiseshader/Shader/SimplexNoise3D.hlsl"
            #include "clipInclude.cginc"
            
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
            #include "clipInclude.cginc"
                
            ENDCG
            }
        }
}

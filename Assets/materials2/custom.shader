Shader "Unlit/holo2"
{
    Properties
    {
        _NormalMap("normal map", 2D) = "blue" {}
        _DiffuseMap("Diffuse Map", 2D) = "white" {}
        _disortion("ditortion", float) = 0
        _frequency ("frequency", float) = 100
        _brightness ("brightness", float) = 1
        _speed("speed", float) = 0
        _distortionOffset("distortionOffset", float) = 0
        _Color("Color", Color) = (1, 0, 0, 1)
        /*
            To see plane clipping, change the x parameter (Inspector) in the "Plane Point" to somewhere between 3 - 4 (clips left to right) assuming Normal isn't changed
            You could also change the y parameter (Inspector) in the "Plane Normal" to somewhere between -1 - -5 (clips top to bottom) assuming Point isn't changed
            Feel free to play around with the combinations :P
        */
        _PlanePoint ("Plane Point (World Space)", Vector) = (0,0,0,0)
        _PlaneNormal ("Plane Normal (World Space)", Vector) = (1,0,0,0)
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
            #include "customInclude.cginc"
            
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
            #include "customInclude.cginc"
                
            ENDCG
            }
        }
    }
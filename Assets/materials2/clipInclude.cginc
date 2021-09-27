
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

float  _disortion;
float  _frequency;
float  _speed;
float _distortionOffset;
float4 _Color;


float4 distortion(float3 p) {

    return  saturate(p.y - _distortionOffset) * _disortion * float4(
        SimplexNoise(p * _frequency + _Time.y * _speed),
        SimplexNoise(p * _frequency + _Time.y * _speed + 131.678),
        SimplexNoise(p * _frequency + _Time.y * _speed + 272.874),
        0);
}

v2f vert(appdata v)
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

sampler2D _NormalMap;
sampler2D _DiffuseMap;

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
    clip(sin(i.worldPos.y * _frequency));

    float3 worldNormal = worldNormalFromMap(i);

    float3 lightDir = _WorldSpaceCameraPos - i.worldPos;
    lightDir = normalize(lightDir);

    float3 n = worldNormal;

    float brightness = dot(n, lightDir);
    fixed4 col = brightness * tex2D(_DiffuseMap, i.uv);
    
    return col * _Color;
}

// 边界Voronoi
Shader "Custom/BorderVoroniShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Row("Row", Range(1, 5)) = 3
        _Col("Col", Range(1, 5)) = 3
        _Center("Center", Range(0, 1)) = 0.04
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Row;
            float _Col;
            fixed _Center;
            static float PI = 3.1415926535897932384626433832795;

            struct a2v
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float2 random2(float2 uv)
            {
                return frac(sin(float2(dot(uv, float2(127.1, 311.7)), dot(uv, float2(269.5, 183.3)))) * 43758.5453);
            }

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float2 uv = i.uv * float2(_Row, _Col);
                float2 ipos = floor(uv);
                float2 fpos = frac(uv);

                float minDist = 10;
                float2 minNeighbor;
                float2 minVec;

                for(int y = -1; y <= 1; y++)
                {
                    for(int x = -1; x <= 1; x++)
                    {
                        float2 neighbor = float2(x, y);
                        float2 pt = random2(ipos + neighbor);
                        pt = 0.5 + 0.5 * sin(2 * PI * pt + _Time.w);
                        float2 vec = pt + neighbor - fpos;
                        float dist = length(vec);
                        if(dist < minDist)
                        {
                            minDist = dist;
                            minNeighbor = neighbor;
                            minVec = vec;
                        }
                    }
                }

                minDist = 10;
                for(int y = -2; y <= 2; y++)
                {
                    for(int x = -2; x <= 2; x++)
                    {
                        float2 neighbor = minNeighbor + float2(x, y);
                        float2 pt = random2(ipos + neighbor);
                        pt = 0.5 + 0.5 * sin(2 * PI * pt + _Time.w);
                        float2 vec = pt + neighbor - fpos;
                        if(dot(vec - minVec, vec - minVec) > 0.0001)
                        {
                            minDist = min(minDist, dot(0.5 * (vec + minVec), normalize(vec - minVec)));
                        }
                    }
                }

                float c = minDist * (0.5 + 0.5 * sin(64.0 * minDist));
                c = lerp(1.0, c, smoothstep(0.01, 0.02, minDist));
                c += step(length(minVec), _Center);

                return fixed4(c, c, c, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}

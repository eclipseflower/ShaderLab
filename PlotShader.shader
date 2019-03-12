// 画函数图
Shader "Custom/PlotShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_MainTex("Tex", 2D) = "white" {}
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

			struct a2v
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f i;
				i.vertex = UnityObjectToClipPos(v.vertex);
				i.texcoord = v.texcoord;

				return i;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				float y = pow(i.texcoord.x, 2);
				fixed plot = smoothstep(y - 0.02, y, i.texcoord.y) - smoothstep(y, y + 0.02, i.texcoord.y);
				fixed4 bkColor = fixed4(y, y, y, 1.0);
				return plot * _Color + (1 - plot) * bkColor;
			}
			ENDCG
		}
    }
    FallBack "Diffuse"
}

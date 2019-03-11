// 正弦波Shader

Shader "Custom/SineShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			fixed4 _Color;

			static float a[2] = { 0.8f, 0.2f };
			static float k[2] = { 1.0f, 8.0f };
			static float w[2] = { 1.0f, 8.0f };
			static float p[2] = { 0.0f, 1.0f };

			float SumOfRadialSineWaves(float x, float z)
			{
				float d = sqrt(x * x + z * z);
				float sum = 0.0f;
				for (int i = 0; i < 2; ++i)
					sum += a[i] * sin(k[i] * d - _Time.y * w[i] + p[i]);
				return sum;
			}

			float SumOfDirectionalSineWaves(float x, float z)
			{
				float d = x + z;
				float sum = 0.0f;
				for (int i = 0; i < 2; ++i)
					sum += a[i] * sin(k[i] * d - _Time.y * w[i] + p[i]);
				return sum;
			}

			fixed4 GetColorFromHeight(float y)
			{
				if (abs(y) <= 0.2f)
					return fixed4(0.0f, 0.0f, 0.0f, 1.0f);
				else if (abs(y) <= 0.5f)
					return fixed4(0.0f, 0.0f, 1.0f, 1.0f);
				else if (abs(y) <= 0.8f)
					return fixed4(0.0f, 1.0f, 0.0f, 1.0f);
				else if (abs(y) <= 1.0f)
					return fixed4(1.0f, 0.0f, 0.0f, 1.0f);
				else
					return fixed4(1.0f, 1.0f, 0.0f, 1.0f);
			}

			struct a2v
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(a2v v)
			{
				v2f i;
				v.vertex.y = SumOfDirectionalSineWaves(v.vertex.x, v.vertex.z);
				i.vertex = UnityObjectToClipPos(v.vertex);
				i.color = GetColorFromHeight(v.vertex.y);

				return i;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				return i.color;
			}

			ENDCG
		}
    }
    FallBack "Diffuse"
}

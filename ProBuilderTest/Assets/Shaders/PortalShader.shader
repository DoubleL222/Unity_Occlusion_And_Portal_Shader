Shader "Custom/PortalShader" {
	Properties {
		_CircleColor ("Circle Color", Color) = (1,1,1,1)
		_GridColor("Grid Color", Color) = (1,1,1,1)
		_CircleTexture ("CircleTexture (RGB)", 2D) = "white" {}
		_GridTex ("Grid Texture (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_PortalCentre ("Portal Centre", Vector) = (0,0,0,0)
		_CircleSize ("Circle Size", Range(0,100)) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:blend
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _GridTex;
		sampler2D _CircleTexture;

		struct Input {
			float2 uv_GridTex;
			float2 uv_CircleTexture;
			float3 worldPos;

		};

		half _Glossiness;
		half _Metallic;
		half _CircleSize;
		fixed4 _CircleColor;
		fixed4 _GridColor;
		fixed4 _PortalCentre;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			float scaleFactor = 15;
			float dist = distance(IN.worldPos, _PortalCentre);
			float sine = sin(IN.worldPos.x*(scaleFactor /_CircleSize) + _Time.y);
			float cosine = cos(IN.worldPos.y*(scaleFactor / _CircleSize) + _Time.y);
			float circleBorder = (_CircleSize + (sine / (scaleFactor / _CircleSize)) + (cosine / (scaleFactor / _CircleSize)));
			if(dist > circleBorder)
			{
				fixed4 c = tex2D(_GridTex, IN.uv_GridTex) * _GridColor;
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}
			else 
			{
				float transparentSize = 0.2;
				float distToBorder = circleBorder - dist;
				float transparentBorder = _CircleSize * transparentSize;

				fixed4 c = tex2D(_CircleTexture, IN.uv_CircleTexture) * _CircleColor;
				fixed4 cg = tex2D(_GridTex, IN.uv_GridTex) * _GridColor;
				o.Albedo = c.rgb;

				if (distToBorder <= transparentBorder)
				{
					float ratio = distToBorder / transparentBorder;
					float alpha = max(ratio, 0.1f);
					o.Alpha = ratio;
					//o.Albedo = 0.5*c.rgb + 0.5*cg.rgb;
					o.Albedo = lerp(c.rgb, cg.rgb, cg.a * (1-ratio));
				}
				else 
				{
					o.Alpha = c.a;

					//o.Albedo = lerp(tex2D(_CircleTexture, IN.uv_CircleTexture) * _CircleColor, tex2D(_GridTex, IN.uv_GridTex) * _GridColor, c.a);
				}
			}

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

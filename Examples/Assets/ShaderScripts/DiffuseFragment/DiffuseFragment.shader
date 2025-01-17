﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DiffuseFragment"
{
    Properties
    {
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
    }

	SubShader{
		Pass{
			Tags {"LightMode" = "ForwardBase"}

		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag

		#include "Lighting.cginc"

		fixed4 _Diffuse;

		struct a2v{
			float4 vertex: POSITION;
			float3 normal: NORMAL;
		};

		struct v2f{
			float4 pos: SV_POSITION;
			fixed3 normal: NORMAL;
		};

		v2f vert(a2v v){
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.normal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
			return o;
		}

		fixed4 frag(v2f i): SV_Target{
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
			
			fixed3 worldNormal = i.normal;
			fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

			fixed3 halfLambert = dot(worldNormal, worldLightDir) * 0.5 + 0.5;

			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;

			fixed3 color = ambient +  diffuse;

			return fixed4(color, 1.0);
		}

		ENDCG
		}
	}
    
}

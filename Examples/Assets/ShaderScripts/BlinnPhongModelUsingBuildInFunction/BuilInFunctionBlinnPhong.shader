﻿Shader "Custom/BuildInFunctionBlinnPhong"
{
    Properties
    {
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
    }

	SubShader{
		Pass{
			Tags {"LightMode" = "ForwardBase"}

		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag

		#include "Lighting.cginc"

		fixed4 _Diffuse;
		fixed4 _Specular;
		float _Gloss;

		struct a2v{
			float4 vertex: POSITION;
			float3 normal: NORMAL;
		};

		struct v2f{
			float4 pos: SV_POSITION;
			float3 worldNormal: TEXCOORD0;
			float4 worldPos: TEXCOORD1;
		};



		v2f vert(a2v v){
			v2f o;

			o.pos = UnityObjectToClipPos(v.vertex);
			o.worldNormal = UnityObjectToWorldNormal(v.normal);
			o.worldPos = mul(unity_ObjectToWorld, v.vertex);
			return o;

		}

		fixed4 frag(v2f i): SV_Target{
			
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
			
			float3 worldNormal = normalize(i.worldNormal);
			float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb  * saturate(dot(worldNormal, worldLightDir));

			float3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));

			float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

			//Phong Model
			//fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

			//Blinn-Phong Model
			fixed3 halfDir = normalize(worldLightDir + viewDir);
			fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);

			fixed3 color = ambient + diffuse + specular;

			return fixed4(color, 1.0);
		}

		ENDCG
		}
	}
    
}

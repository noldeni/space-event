//@author: Martin Zrcek, Michal Máša, Andrej Boleslavky: CIANT Prague
//@help: renders particleStateTex field
//@tags:
//@credits: CIANT, dottore - ParticlesGPU_Shader_Library

// --------------------------------------------------------------------------------------------------
// PARAMETERS:
// --------------------------------------------------------------------------------------------------

#define posMODULE 1000

//transformations
float4x4 tW: WORLD;        //the models world matrix
float4x4 tV: VIEW;         //view matrix as set via Renderer (EX9)
float4x4 tP: PROJECTION;
float4x4 tWVP: WORLDVIEWPROJECTION;
float4x4 tVP: VIEWPROJECTION ;
texture particleStateTex <string uiname="ParticleStateTexture";>;
float particleSize <string uiname="ParticleSize";>;
float alfaMultiple <string uiname="AlfaMultiple";>;
float4 colorMultiple: COLOR;
texture Tex <string uiname="TextureForQuads";>;
float2 texSubdiv <String uiname="Number of image subdivision inside texture"; float uimin=0.0;> = 1.0;  
float viewportHeight <string uiname="viewportHeight";>;
float posPRESISION <String uiname="Presison cube for particles"; float uimin=0.0;> = 50.0;  
//bool zBufferEnable = true;
bool rotationEnable = false;
texture TexColor <string uiname="ColorForQuads";>;

	//	particles position texture
sampler particleStateSamp = sampler_state 
{
    Texture   = (particleStateTex);
    MipFilter = none;
    MinFilter = none;
    MagFilter = none;
};
	//	texture for every quad
sampler spriteTextureSamp = sampler_state
{
    Texture   = (Tex);
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};
texture timeTex <string uiname="TimeToSwapSubdivision";>;
sampler timeSamp = sampler_state
{
    Texture   = (timeTex);
    MipFilter = NONE;
    MinFilter = NONE;
    MagFilter = NONE;
};
	//	color for quads
sampler spriteTextureSampColor = sampler_state
{
    Texture   = (TexColor);
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

struct vs2ps
{
    float4 Pos  : POSITION;
    float2 TexCd : TEXCOORD0;
    //float3 ColorMult : TEXCOORD1;
    //float FrameTime : TEXCOORD1;
	float Time:COLOR0;
	float2 Rotation:COLOR1;
	float3 ColorMult:COLOR2;
    float Size : PSIZE0;
};

// --------------------------------------------------------------------------------------------------
// VERTEXSHADERS
// --------------------------------------------------------------------------------------------------
vs2ps VS(
    float4 Pos  : POSITION,
    float4 TexCdParticlePos : TEXCOORD0,
    float4 TexCdOnQuad : TEXCOORD1)
{
    vs2ps Out = (vs2ps)0;

    //get the position info from the Position-velocity texture:
    float3 particlePosition;
    particlePosition = tex2Dlod(particleStateSamp, TexCdParticlePos);
	float3 particleVelocity = (particlePosition/1000);
    particlePosition = fmod(particlePosition, posMODULE);
    particlePosition = abs(particlePosition);
    
	// decode from (0..1000) to (-500..500)/posPRESISION
	particlePosition = particlePosition - 500.0;
	//particlePosition.y+=480;
	particlePosition = particlePosition/posPRESISION;
    // now apply the position taken from the texture
    Pos.xyz += particlePosition;
	float3 Pos2 = Pos;
	Pos2+=particleVelocity;	// position on previous frame
    
    //transform position
  	Pos = mul(Pos, tWVP);
    Out.Pos = Pos;

    //transform texturecoordinates
    //Out.TexCd = mul(TexCdOnQuad, tTex);
	Out.TexCd = TexCdOnQuad;
	//Out.TexCdPos = TexCdParticlePos;
	//Out.TexCdTime = TexCdParticlePos;
	
	
    float3 colorMult = tex2Dlod(spriteTextureSampColor, TexCdParticlePos);
	Out.ColorMult = colorMult;
	
	// Rotation
	if (rotationEnable) {
		Pos2 = mul(Pos2, tWVP);
		float2 particleDirection = normalize(Pos.xyz - Pos2.xyz);
		particleDirection.x = acos(particleDirection.x);
		if(particleDirection.y<0) particleDirection.x *= -1;
		Out.Rotation = particleDirection;
	}

	// get the size of a particle in prespective
	Out.Size = particleSize / Out.Pos.w * viewportHeight/2;
	//Out.Size = particleSize * tP / (Out.Pos.w) * 300;
	//Out.Size = particleSize;
	Out.Time = tex2Dlod(timeSamp, TexCdParticlePos).a;
    return Out;
}

// --------------------------------------------------------------------------------------------------
// PIXELSHADERS:
// --------------------------------------------------------------------------------------------------

float4 PS(vs2ps In): COLOR
{
	float2 textureCoordinate = In.TexCd;
	if (rotationEnable) {
		float c = -cos(In.Rotation.x);
		float s = sin(In.Rotation.x); 
		float2x2 rotationMatrix = float2x2(c, -s, s, c); 
		textureCoordinate -= 0.5; 
		textureCoordinate = mul(textureCoordinate, rotationMatrix); 
		textureCoordinate += 0.5;
	}
	
	float4 col;
	if (texSubdiv.x==1.0 && texSubdiv.y==1.0)
    	col = tex2D(spriteTextureSamp, textureCoordinate);
	else {
		// get the right part of picture
		float time = In.Time;
		float partsNumber = (texSubdiv.x * texSubdiv.y);	// how many pictures are in texture
		int frameIndex = (int) (time*partsNumber);
		int2 frameMove = int2(frameIndex%texSubdiv.x,frameIndex/texSubdiv.y);
    	col = tex2D(spriteTextureSamp, (In.TexCd + frameMove)/texSubdiv);
	}
	
	col.xyz *= In.ColorMult;
	
    col.xyz *= colorMultiple.xyz;
    col.a *= alfaMultiple;
    return col;
}

// --------------------------------------------------------------------------------------------------
// TECHNIQUES:
// --------------------------------------------------------------------------------------------------

technique ZBufferEnable
{
    pass P0
    {
    	ZEnable = true;
        FillMode = POINT;
        PointScaleEnable = true;
        PointSpriteEnable = true;
    	AlphaRef = 1.000;
    	AlphaFunc = GREATEREQUAL;
        //AlphaBlendEnable = false;
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader  = compile ps_3_0 PS();
    }
}
technique ZBufferDisable
{
    pass P0
    {
    	ZEnable = false;
        FillMode = POINT;
        PointScaleEnable = true;
        PointSpriteEnable = true;
        //AlphaBlendEnable = false;
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader  = compile ps_3_0 PS();
    }
}

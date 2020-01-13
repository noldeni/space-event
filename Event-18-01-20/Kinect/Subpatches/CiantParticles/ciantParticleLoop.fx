//@author: Martin Zrcek, Michal Máša, Andrej Boleslavky: CIANT Prague
//@help: Creates a movement cycle initialTex shaders. Input and output fields are textures.
//@tags:
//@credits: CIANT, dottore - ParticlesGPU_Shader_Library

// --------------------------------------------------------------------------------------------------
// PARAMETERS:
// --------------------------------------------------------------------------------------------------

#define posMODULE 1000
static float4x4 scaleToRender =  float4x4 (2,0,0,0, 0,2,0,0, 0,0,1,0, 0,0,0,1);
float resetTime<string uiname="ParticleRecreationTime";>;

float PARAM[16];
/*		PARAMeters meaning:
0) air continuity
1) gravity
2) fuzzy amount
3) fuzzy range -1
4) attract amount
5) attract range
6) torque amont
7) torque2 amount
8) random spread
9) gravity X
10) gravity Y
11) gravity Z
12) add X velocity
13) add Y velocity
14) add Z velocity
15) ground*/

// particleStateTex 
// stores information between frames. It is the input and output of shader
// the copy of this texture is drawn by ParticleDraw
texture particleLastStateTex <string uiname="ParticleStateTexture";>;
sampler Samp = sampler_state    
{
    Texture   = (particleLastStateTex);          
    MipFilter = NONE;         
    MinFilter = NONE;
    MagFilter = NONE;
};
// this gives us particle's initial position, after particle reborn
texture initialTex <string uiname="InitialPositionTexture";>;
sampler SampInitialPos = sampler_state
{
    Texture   = (initialTex);
    MipFilter = NONE;
    MinFilter = NONE;
    MagFilter = NONE;
};
texture initialVelocityTex <string uiname="InitialVelocityTexture";>;
sampler SampInitialVel = sampler_state
{
    Texture   = (initialVelocityTex);
    MipFilter = NONE;
    MinFilter = NONE;
    MagFilter = NONE;
};
texture resetTex <string uiname="TimeToLiveTexture";>;
sampler SampReset = sampler_state
{
    Texture   = (resetTex);
    MipFilter = NONE;
    MinFilter = NONE;
    MagFilter = NONE;
};

	//	a dimension for a bounding box, wich defines a precision in computation.
float posPRESISION <String uiname="Presison cube for particles"; float uimin=0.0;> = 50.0; 
	//	few sprites on many vertex positions means only some of them are chosen. RndVertS randomizes the choice.
float rndVertS <String uiname="Randomize vertices source"; float uimin=0.0;> = 1.0;

bool reset<string uiname="Reset";>;

struct vs2ps
{
    float4 Pos  : POSITION;
    float2 TexCd : TEXCOORD0;
};

// --------------------------------------------------------------------------------------------------
// VERTEXSHADERS
// --------------------------------------------------------------------------------------------------
vs2ps VS(
    float4 PosO  : POSITION,
    float4 TexCd : TEXCOORD0)
{
    vs2ps Out;	//create output struct
    Out.Pos = mul(PosO, scaleToRender);
    Out.TexCd = 1.0*TexCd;
    return Out;
}

// --------------------------------------------------------------------------------------------------
// PIXELSHADERS:
// --------------------------------------------------------------------------------------------------
float4 getInitialState (float2 texCd) {
	float4 col = tex2D(SampInitialPos, rndVertS*texCd);
	col.xyz*=posPRESISION; 	// spread to whole position scale
		// we have +- only 1000 steps, *100 means (0..10) in 0.01 precision
	col.xyz+=500;	// position from (-500..500) to (0..1000)
	//col.y-=PARAM[15];
	float4 vel = tex2D(SampInitialVel, rndVertS*texCd);
	
    vel = round((vel-0.5)*PARAM[8]);	// vel (0..1)to(-.5...5) and spread
    vel.x+=PARAM[12];					// \
    vel.y+=PARAM[13];					//  add initial velocity
    vel.z+=PARAM[14];					// /
	vel=round(vel);						// only whole numbers (partial affect position)

	col = col + 1000.0f*abs(vel);		// encode to 1 value
    if(vel.x<0) col.x*=-1;
    if(vel.y<0) col.y*=-1;				//  if speed was negative, keep it so
    if(vel.z<0) col.z*=-1;
	return col;
}
// get position from target position texture, here the same as InitialPosition
float4 getTargetState (float2 texCd) {
	float4 col = tex2D(SampInitialPos, rndVertS*texCd);	//get color from InitialPositionTexture
	col.xyz*=posPRESISION; 					//spread initial to whole position scale
	col.xyz+=500;
	//col.y-=PARAM[15];
	return col;
}
bool resetParticle(float2 texCd) {
	float time = tex2D(SampReset, texCd).a;
	// reseting is not perfect. It means:
	// If a particle is somewhere in the area under 0.a, reset it
	if (reset || (time<=0.1-min(0.085,0.038*resetTime))) return true;
	else return false;
}

float4 PS(vs2ps In): COLOR
{
	float4 col, pos, vel;
	
	// If no "Time To Live" or triggered Reset, reset it. 
	// Otherwise, take position from the last frame.
	if(resetParticle(In.TexCd)) col = getInitialState(In.TexCd);
	else col = tex2D(Samp, In.TexCd);
		
    // decode from 1 value
    pos = fmod(col, 1000);		// pos (0..1000)
    pos = abs(pos);
    vel = floor(col/1000);		// vel (1000+)to(0+), can be negative
    	
// series of possible forces
    	// AIR RESISTANCE
    vel*= PARAM[0];
    	// GRAVITY     !velocity rounds to integer numbers!
    vel.x += PARAM[9];
    vel.y += PARAM[1] + PARAM[10];
    vel.z += PARAM[11];
    	// FUZZYYY
    if (PARAM[2]!=0 && PARAM[3]!=0) {
    	vel.xyz+=PARAM[2]*sin(PARAM[3]*pos.yzx);
    }
    	// ATTRACTOR, WHIRLWIND
    float4 stred = getTargetState(In.TexCd)-pos;
    if (PARAM[4]!=0.0) {
    	if (PARAM[5]>0.0) 
    		vel.xyz+= PARAM[4]*normalize(stred)*log(length(stred)/PARAM[5]);
    	else vel.xyz+= PARAM[4]*normalize(stred);
    }
	// 6 = rotation
    if (PARAM[6]!=0.0) vel.xyz+= PARAM[6]*cross(normalize(stred), float3(0,1,0));
    // 7 = spherical rotation
	if (PARAM[7]!=0.0) vel.xyz+=( PARAM[7]*cross(cross(normalize(stred), normalize(vel)),normalize(stred)) );
    //if (fmod(pos.z,0.0001)>0.00005) vel.xyz+=1; 	//pseudorandomizace aby nedochazelo k posunu kuli zaokrouhlovani
    	
    	// POSITION MODULE
    pos = fmod(pos, 1000.0);	// if position>1000, reset
    
    	//MOVE
    pos+=vel/1000;
	// 15 = ground limit
	PARAM[15]+=500.0;	// 500 is the middle of bbox 0 .. 1000
    if (pos.y<PARAM[15]) pos.y=PARAM[15];
	/*if (pos.x>999) pos.x %= 999;
	if (pos.y>999) pos.y %= 999;
	if (pos.z>999) pos.z %= 999;*/
// end of possible forces

    //encode to 1 value
    vel = round(vel);
    col = pos + 1000.0f*abs(vel);
    if(vel.x<0) col.x*=-1;
    if(vel.y<0) col.y*=-1;
    if(vel.z<0) col.z*=-1;
    col.w = 1;				// w multiplies xyz of texture :(alpha)
	// we return a value of position multiplied by posPRESISION 
	// later we will have to divide it!
    return col;
}

// --------------------------------------------------------------------------------------------------
// TECHNIQUES:
// --------------------------------------------------------------------------------------------------

technique TSimpleShader
{
    pass P0
    {
        //Wrap0 = U;  // useful when mesh is round like a sphere
        VertexShader = compile vs_3_0 VS();
        PixelShader  = compile ps_3_0 PS();
    }
}


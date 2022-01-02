SWEP.PrintName			= "Term Project, Melon and Monitor Thrower" 
SWEP.Author			= "(Lynden Hill)" 
SWEP.Instructions		= "THROW SOME MELONS AND MONITORS!"


SWEP.Spawnable = true
SWEP.AdminOnly = true





SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.ShootSound = Sound( "Metal.SawbladeStick" )







function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 0.01 )	

	
	self:ThrowChair( "models/props_junk/watermelon01.mdl" )
end
 


function SWEP:SecondaryAttack()
	
	self:SetNextSecondaryFire( CurTime() + 0.01 )

	self:ThrowChair( "models/props_lab/monitor02.mdl" )
end


function SWEP:ThrowChair( model_file )
	local owner = self:GetOwner()

	
	if ( not owner:IsValid() ) then return end

	
	self:EmitSound( self.ShootSound )
 

	if ( CLIENT ) then return end

	
	local ent = ents.Create( "prop_physics" )

	
	if ( not ent:IsValid() ) then return end

	
	ent:SetModel( model_file )

	
	local aimvec = owner:GetAimVector()
	local pos = aimvec * 16 
	pos:Add( owner:EyePos() ) 

	
	ent:SetPos( pos )

	
	ent:SetAngles( owner:EyeAngles() )
	ent:Spawn()
 
	
	
	
	local phys = ent:GetPhysicsObject()
	if ( not phys:IsValid() ) then ent:Remove() return end
 

	aimvec:Mul( 400 )
	aimvec:Add( VectorRand( -25, 25 ) ) 
	phys:ApplyForceCenter( aimvec )
 

	cleanup.Add( owner, "props", ent )
 
	undo.Create( "Thrown_Chair" )
		undo.AddEntity( ent )
		undo.SetPlayer( owner )
	undo.Finish()
end
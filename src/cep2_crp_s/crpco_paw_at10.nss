#include "x0_i0_position"
#include "crp_inc_paw"

//location lJumpTo = GetSpellTargetLocation();

//const float ANIM_DEFAULT_SPEED_5 = 2.5f;
//const float ANIM_DEFAULT_DURATION_5 = 2.3f;

void Jump(object oPC);

//MAIN CODE

float fDir = GetFacing(OBJECT_SELF);

void AddnAnimWrapper(int iAnimIndex, float fAnimSpeed, float fAnimDuration)
{
    DelayCommand(0.1, ClearAllActions());
    DelayCommand(0.15, ActionPlayAnimation(iAnimIndex, fAnimSpeed, fAnimDuration));
    return;
}

void main()
{
    if(GetIsEncumbered(OBJECT_SELF))
    {
        DisplayText("You are too encumbered to jump");
        return;
    }
    location lPawStart = GetLocalLocation(OBJECT_SELF, "PAW_LOC");
    location lCurrent = GetLocation(OBJECT_SELF);
    float fDif = GetDistanceBetweenLocations(lPawStart, lCurrent);
    if(fDif < 0.0f || fDif > 0.9f)
    {
        DisplayText("Position has changed: That action is no longer valid");
        return;
    }
    float fPawFacing = GetLocalFloat(OBJECT_SELF, "PAW_FACING");
    if((fPawFacing + 3.0f < fDir) || (fPawFacing - 3.0f > fDir))
    {
        DisplayText("Facing has changed: That action is no longer valid");
        return;
    }
    DelayCommand(0.3, Jump(OBJECT_SELF));
}

void Jump(object oPC)
{

    //int iAnimIndex = ANIMATION_LOOPING_CUSTOM5;
    //float fAnimSpeed = ANIM_DEFAULT_SPEED_5;
    //float fAnimDuration = ANIM_DEFAULT_DURATION_5;
    float fAppearanceModifier = GetAppearanceModifierFromABAScaling(oPC);
    float fJumpLength = JUMP_ANIM_DISTANCE_SCALAR * fAppearanceModifier;
    float fAngleOpposite = GetOppositeDirection(fDir);

    location lJumpTo = GenerateNewLocation(oPC,
                                           fJumpLength,
                                           fDir,
                                           fDir);

    location lRunning = GenerateNewLocation(oPC,
                                              DISTANCE_TINY,
                                              fAngleOpposite,
                                              fDir);

    vector vCurrent = GetPositionFromLocation(GetLocation(oPC));
    vector vToJump = GetPositionFromLocation(lJumpTo);
    vector vRunning = GetPositionFromLocation(lRunning);

    if (!LineOfSightVector(vCurrent, vToJump))  // Can't jump where you can't see
    {
        PlayVoiceChat(VOICE_CHAT_CANTDO, oPC);
        SendMessageToPC(oPC, "Jump would carry character into a wall or other invalid area.");
        return;
    }
    if(!LineOfSightVector(vCurrent, vRunning)) // Need distance to run
    {
        PlayVoiceChat(VOICE_CHAT_CANTDO, oPC);
        SendMessageToPC(oPC, "Need space behind character to gather speed for a jump!");
        return;
    }

    float fDis = GetDistanceBetween(OBJECT_SELF, GetNearestObject(OBJECT_TYPE_CREATURE));
    if(fDis != 0.0f && fDis < 2.0)
        PlayVoiceChat(VOICE_CHAT_MOVEOVER);

    effect effTouchupInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);

    SetFootstepType(FOOTSTEP_TYPE_NONE, oPC);

    DelayCommand(0.3, SetCommandable(FALSE, oPC));
    crp_PlayAnimation(ANIMATION_JUMP);
    //ActionPlayAnimation(iAnimIndex, fAnimSpeed, fAnimDuration);
    DelayCommand(2.63, SetCommandable(TRUE, oPC));
    DelayCommand(2.65, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, effTouchupInvis, oPC, 0.90));
    DelayCommand(2.70, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(2.80, ActionJumpToLocation(lJumpTo));
//    DelayCommand(2.78, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(3.25, SetFootstepType(FOOTSTEP_TYPE_DEFAULT, oPC));
}

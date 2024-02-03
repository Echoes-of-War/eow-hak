#include "x0_i0_position"

float GetAppearanceModifierFromABAScaling(object oPC);

object oUser = GetLastUsedBy();
float fAppearanceModifier = GetAppearanceModifierFromABAScaling(oUser);
const float LADDER_ANIM_DISTANCE_SCALAR = 2.475;

void MoveEdgeSquatters(location lClimb, location lGetBack)
{
    int nNth = 1;
    object oSquatter = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lClimb, nNth);
    while(GetDistanceBetweenLocations(lClimb, GetLocation(oSquatter)) < 0.5f &&
          GetIsObjectValid(oSquatter))
    {
        nNth++;
        AssignCommand(oSquatter, ClearAllActions());
        AssignCommand(oSquatter, ActionJumpToLocation(lGetBack));
        FloatingTextStringOnCreature("Someone is climbing up the ladder.", oSquatter, FALSE);
        oSquatter = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lClimb, nNth);
    }
}

float GetAppearanceModifierFromABAScaling(object oPC)
{
    int iRacialType = GetRacialType(oPC);

    if (GetGender(oPC) == GENDER_MALE)
    {
        if(iRacialType == IP_CONST_RACIALTYPE_HUMAN)
            return 1.0;
        else if(iRacialType == IP_CONST_RACIALTYPE_HALFLING)
            return 0.75;
        else if(iRacialType == IP_CONST_RACIALTYPE_ELF)
            return 0.935;
        else if(iRacialType == IP_CONST_RACIALTYPE_DWARF)
            return 0.78;
        else if(iRacialType == IP_CONST_RACIALTYPE_GNOME)
            return 0.73;
        else return 1.03;
    }
    else
    {
        if(iRacialType == IP_CONST_RACIALTYPE_HUMAN)
            return 0.988;
        else if(iRacialType == IP_CONST_RACIALTYPE_HALFLING)
            return 0.732;
        else if(iRacialType == IP_CONST_RACIALTYPE_ELF)
            return 0.923;
        else if(iRacialType == IP_CONST_RACIALTYPE_DWARF)
            return 0.748;
        else if(iRacialType == IP_CONST_RACIALTYPE_GNOME)
            return 0.73;
        else return 0.997;
    }
}

void main()
{
    object oDoor = OBJECT_SELF;

    // Allow for traps and locks
    if (GetIsTrapped(OBJECT_SELF)) {return;}

    object oClimber = GetLocalObject(oDoor, "CLIMBER");
    if (GetIsObjectValid(oClimber) && oClimber != oUser)
    //Someone is climbing the rope and its not you!
    {
        ActionDoCommand(FloatingTextStringOnCreature("Someone is already climbing the ladder, wait until they are done.", oUser, FALSE));
        return;
    }
    else
    {
        SetLocalObject(oDoor, "CLIMBER", oUser);
    }

    AssignCommand(oUser, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser)));
    AssignCommand(oUser, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oUser)));

    effect effTouchupInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    float fDis = LADDER_ANIM_DISTANCE_SCALAR * fAppearanceModifier;

    string sDes = GetLocalString(oDoor, "DESTINATION");
    object oDes = GetObjectByTag(sDes);
    if(GetIsObjectValid(oDes)) // the door is there
    {
        // Destination must be a non-secret or revealed door - go through

        SetLocked(oDes, FALSE);
        AssignCommand(oDes, ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN));
        //AssignCommand(oUser, JumpToObject(oDes));

        float fDir = GetFacing(oDes);
        float fAngle = GetOppositeDirection(fDir);
        location lClimb = GenerateNewLocation(oDes, fDis, fAngle, fDir);
        location lGetBack = GenerateNewLocation(oDes, fDis + 0.5, fAngle, fDir);
        MoveEdgeSquatters(lClimb, lGetBack);

        SetCutsceneMode(oUser, TRUE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, effTouchupInvis, oUser);
        AssignCommand(oDes, ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN));
        AssignCommand(oUser, ActionJumpToLocation(lClimb));
        AssignCommand(oUser, ActionDoCommand(DelayCommand(1.0, RemoveEffect(oUser, effTouchupInvis))));
        DelayCommand(0.3, AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM6, 2.0, 4.2)));
        //DelayCommand(0.35, AssignCommand(oUser, ActionDoCommand(DelayCommand(1.0, SetCommandable(TRUE, oUser)))));
        DelayCommand(0.35, AssignCommand(oUser, ActionDoCommand(DelayCommand(1.0, SetCutsceneMode(oUser, FALSE)))));
        DelayCommand(0.35, AssignCommand(oUser, ActionDoCommand(DelayCommand(1.0, DeleteLocalObject(oDoor, "CLIMBER")))));
        //DelayCommand(0.50, SetCommandable(FALSE, oUser));

        SetLocalInt(oDes, "OPEN", 1);
        int nReset = GetLocalInt(oDes, "RESET");
        if(nReset >= 1)
        {
            float fDoorReset = IntToFloat(nReset);
            DelayCommand(fDoorReset, AssignCommand(oDes, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
            DelayCommand(fDoorReset + 2.0f, DestroyObject(oDes));
        }
    }
    else
    {
        // Destination is a concealed secret door
        object oMarker = GetObjectByTag("SC"+sDes);
        location lLoc = GetLocation(oMarker);
        string sTag = GetLocalString(oMarker, "TAG");
        string sDestination = GetLocalString(oMarker, "DESTINATION");
        string sResRef = GetLocalString(oMarker, "RESREF");
        int nReset = GetLocalInt(oMarker, "RESET");

        // Make the door
        oDes = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lLoc, FALSE, sTag);
        SetLocalString(oDes, "DESTINATION", sDestination);
        SetLocalInt(oDes, "RESET", nReset);
        // OK - NOW go through the door
        SetLocked(oDes, FALSE);

        //AssignCommand(oUser, JumpToObject(oDes));
        //new code
        float fDir = GetFacing(oDes);
        float fAngle = GetOppositeDirection(fDir);
        location lClimb = GenerateNewLocation(oDes, fDis, fAngle, fDir);
        location lGetBack = GenerateNewLocation(oDes, fDis + 0.5, fAngle, fDir);
        MoveEdgeSquatters(lClimb, lGetBack);

        SetCutsceneMode(oUser, TRUE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, effTouchupInvis, oUser);
        AssignCommand(oDes, ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN));
        AssignCommand(oUser, ActionJumpToLocation(lClimb));
        AssignCommand(oUser, ActionDoCommand(DelayCommand(1.0, RemoveEffect(oUser, effTouchupInvis))));
        DelayCommand(0.3, AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM6, 2.0, 4.2)));
        //DelayCommand(0.35, AssignCommand(oUser, ActionDoCommand(DelayCommand(1.0, SetCommandable(TRUE, oUser)))));
        DelayCommand(0.35, AssignCommand(oUser, ActionDoCommand(DelayCommand(1.0, SetCutsceneMode(oUser, FALSE)))));
        DelayCommand(0.35, AssignCommand(oUser, ActionDoCommand(DelayCommand(1.0, DeleteLocalObject(oDoor, "CLIMBER")))));
        //DelayCommand(0.50, SetCommandable(FALSE, oUser));
        //end new code

        SetLocalInt(oDes, "OPEN", 1);
        if(nReset >= 1)
        {
            float fDoorReset = IntToFloat(nReset);
            //SendMessageToPC(oUser, FloatToString(fDoorReset));
            DelayCommand(fDoorReset, AssignCommand(oDes, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
            DelayCommand(fDoorReset + 2.0f, DestroyObject(oDes));
        }
    }
//DelayCommand(6.0, DeleteLocalObject(oDoor, "CLIMBER"));
}

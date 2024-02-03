#include "crp_inc_paw"

void main()
{
    ClearPAWVariables();

    location lPawLoc = GetSpellTargetLocation();
    object oTarget = GetSpellTargetObject();
    object oPit = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, GetSpellTargetLocation());
    int nType = GetObjectType(oTarget);
    int nJump = (nType == 0 && GetIsJumpProbable());
    int nSpikes = GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "crpi_ironspikes"));
    int nRope = GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "crpi_rope"));
    int nGrapRope = GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "crpi_graprope"));
    int nMallet = GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "crpi_spk_mallet"));
    int nOpen = ((nType == OBJECT_TYPE_DOOR || OBJECT_TYPE_PLACEABLE) && GetIsOpen(oTarget));
    int nHiddenCompartment = (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE &&
                              GetLocalInt(oTarget, "DOOR") != 1);

    // Check for line of sight to target
    //(exclude doors because they report incorrectly)
    vector vPC = GetPosition(OBJECT_SELF);
    vector vTarget;

    if(nType != OBJECT_TYPE_DOOR)
    {
        if(nType == 0)
            vTarget = GetPositionFromLocation(lPawLoc);
        else
            vTarget = GetPosition(oTarget);

        if(!LineOfSightVector(vPC, vTarget))
        {
            DisplayText("No line of sight");
            return;
        }
    }

    if(GetTag(oPit) == "PIT" &&
       GetDistanceBetweenLocations(GetLocation(oPit), GetSpellTargetLocation()) < 2.0f)
    {
        SetLocalObject(OBJECT_SELF, "PAW_PIT", oPit);
        if(GetLocalInt(oPit, "ROPE") == 1)
            SetLocalInt(OBJECT_SELF, "PIT_OPTIONS", 1);
        else if(nGrapRope)
            SetLocalInt(OBJECT_SELF, "PIT_OPTIONS", 3);
        else if(nRope && nSpikes && nMallet)
            SetLocalInt(OBJECT_SELF, "PIT_OPTIONS", 2);
        else
            SetLocalInt(OBJECT_SELF, "PIT_OPTIONS", 999);
        ActionStartConversation(OBJECT_SELF, "crpco_paw", TRUE, FALSE);
        return;
    }

    SetLocalObject(OBJECT_SELF, "PAW_TARGET", oTarget);
    SetLocalInt(OBJECT_SELF, "PAW_TARGET_TYPE", nType);
    SetLocalInt(OBJECT_SELF, "PAW_JUMP", nJump);
    SetLocalInt(OBJECT_SELF, "PAW_SPIKES", nSpikes);
    SetLocalInt(OBJECT_SELF, "PAW_ROPE", nRope);
    SetLocalInt(OBJECT_SELF, "PAW_MALLET", nMallet);
    SetLocalInt(OBJECT_SELF, "PAW_OPEN", nOpen);
    SetLocalInt(OBJECT_SELF, "PAW_HIDDEN_COMPARTMENT", nHiddenCompartment);

    SetLocalLocation(OBJECT_SELF, "PAW_LOC", GetLocation(OBJECT_SELF));
    SetLocalFloat(OBJECT_SELF, "PAW_FACING", GetFacing(OBJECT_SELF));
    ActionStartConversation(OBJECT_SELF, "crpco_paw", TRUE, FALSE);
}

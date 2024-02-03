#include "crp_inc_paw"

object oPit = GetLocalObject(OBJECT_SELF, "PAW_PIT");
string sGoTo = GetLocalString(oPit, "DESTINATION");
location lGoTo = GetLocation(GetObjectByTag(sGoTo));

void CreateRope()
{
    //PlaySound("as_cv_minepick2");
    location lLoc = GetLocation(OBJECT_SELF);
    vector vLoc = GetPositionFromLocation(lLoc);
    //vector vLow = Vector(vLoc.x, vLoc.y, vLoc.z - 1.3f);
    location lRope = Location(GetArea(OBJECT_SELF), vLoc, GetFacing(OBJECT_SELF));
    //location lSpike = Location(GetArea(OBJECT_SELF), vLow, 0.0);
    //Destroy Rope and Spike Items
    object oRopeItem = GetItemPossessedBy(OBJECT_SELF, "crpi_rope");
    DestroyObject(oRopeItem);
    object oSpikes = GetItemPossessedBy(OBJECT_SELF, "crpi_ironspikes");
    int nStackSize = GetNumStackedItems(oSpikes);
    if(nStackSize == 1)
        DestroyObject(oSpikes);
    else
        SetItemStackSize(oSpikes, nStackSize - 1);
    //Create Rope and Spike Placeables
    object oRopeBundle = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_ropebundle", lRope);
    object oRopeDrop = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_ropedrop", lGoTo);
    //CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_floorspike", lSpike);
    SetLocalInt(oPit, "ROPE", 1);
    SetLocalObject(oRopeBundle, "ROPE", oRopeDrop);
    SetLocalObject(oRopeDrop, "ROPE", oRopeBundle);
}

void LowerRope()
{
    DelayCommand(0.2, SetFacingPoint(GetPosition(oPit)));
    DelayCommand(2.5, AssignCommand(oPit, PlaySound("as_cv_minepick2")));
    crp_PlayAnimation(ANIMATION_SPIKE_LOW);

    DelayCommand(1.0, ActionDoCommand(CreateRope()));
    DelayCommand(1.5, ActionResumeConversation());
}


void main()
{
    object oMallet = GetItemPossessedBy(OBJECT_SELF, "crpi_spk_mallet");
    object oRH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if(oMallet != oRH)
    {
        ActionUnequipItem(oRH);
        ActionEquipItem(oMallet, INVENTORY_SLOT_RIGHTHAND);
    }
    ActionPauseConversation();
    DelayCommand(0.5, ActionMoveToLocation(GetLocation(oPit)));
    DelayCommand(0.6, ActionDoCommand(LowerRope()));
}

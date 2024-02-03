/* PLAYER ACTION SYSTEM - co_pas_at03
   Spike this door shut
   v1.00
*/
#include "x0_i0_position"
#include "crp_inc_paw"
#include "crp_inc_listen"
object oDoor = GetLocalObject(OBJECT_SELF, "PAW_TARGET");

void SetSpikes()
{
    SetLocked(oDoor, TRUE);
    SetLocalInt(oDoor, "SPIKED", 1);
    object oSpikes = GetItemPossessedBy(OBJECT_SELF, "crpi_ironspikes");
    int nStackSize = GetNumStackedItems(oSpikes);
    if(nStackSize == 1)
        DestroyObject(oSpikes);
    else
        SetItemStackSize(oSpikes, nStackSize - 1);
    object oTransDoor = GetTransitionTarget(oDoor);
    if(GetObjectType(oTransDoor) == OBJECT_TYPE_DOOR)
        SetLocalInt(oTransDoor, "TRNS_SPIKE_OTHER_SIDE", TRUE);
}

void PoundSpikes()
{
    if(GetLocalInt(oDoor, "SPIKED") == 1)
    {
        FloatingTextStringOnCreature("Someone has already spiked this door.", OBJECT_SELF, FALSE);
        return;
    }
    DelayCommand(2.5, AssignCommand(oDoor, PlaySound("as_cv_minepick2")));
    object oAhead, oBehind;
    float fDir = GetFacing(oDoor);
    float fAngleOpposite = GetOppositeDirection(fDir);
    location lPlayer = GetLocation(OBJECT_SELF);
    location lBehind = GenerateNewLocation(oDoor, 1.0, fAngleOpposite, fDir);
    location lAhead = GenerateNewLocation(oDoor, 1.0, fDir, fDir);
    float fAhead = GetDistanceBetweenLocations(lPlayer, lAhead);
    float fBehind = GetDistanceBetweenLocations(lPlayer, lBehind);
    if(fAhead < fBehind)
    {
        oAhead = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lAhead, FALSE, "SPIKEMARKER");
        oBehind = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lBehind, FALSE, "SPIKEMARKER");
        SetLocalInt(oAhead, "SPIKE_SIDE", 1);
    }
    else
    {
        oAhead = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lAhead, FALSE, "SPIKEMARKER");
        oBehind = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lBehind, FALSE, "SPIKEMARKER");
        SetLocalInt(oBehind, "SPIKE_SIDE", 1);
    }
    vector vec = GetPositionFromLocation(GetLocation(oDoor));
    float fDirection = GetDirection(vec, OBJECT_SELF);
    SetFacing(fDirection);
    crp_PlayAnimation(ANIMATION_SPIKE_LOW);
    ActionDoCommand(SetSpikes());
    /*
    SetLocked(oDoor, TRUE);
    SetLocalInt(oDoor, "SPIKED", 1);
    object oSpikes = GetItemPossessedBy(OBJECT_SELF, "crpi_ironspikes");
    int nStackSize = GetNumStackedItems(oSpikes);
    if(nStackSize == 1)
        DestroyObject(oSpikes);
    else
        SetItemStackSize(oSpikes, nStackSize - 1);
    object oTransDoor = GetTransitionTarget(oDoor);
    if(GetObjectType(oTransDoor) == OBJECT_TYPE_DOOR)
        SetLocalInt(oTransDoor, "TRNS_SPIKE_OTHER_SIDE", TRUE);
    */
}

void main()
{
    if(GetLocked(oDoor))
        SetLocalInt(oDoor, "LOCKED", TRUE);

    //float fDir = GetFacing(OBJECT_SELF);
    //float fAngle = GetAngleBetweenLocations(GetLocation(OBJECT_SELF), GetLocation(oDoor));
    //location lMoveTo = GenerateNewLocation(oDoor, 2.20, fAngle, fDir);
    //ActionMoveToLocation(lMoveTo);

    object oMallet = GetItemPossessedBy(OBJECT_SELF, "crpi_spk_mallet");
    object oRH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if(oMallet != oRH)
    {
        ActionUnequipItem(oRH);
        ActionEquipItem(oMallet, INVENTORY_SLOT_RIGHTHAND);
    }
    DelayCommand(0.5, ActionMoveToObject(oDoor));
    DelayCommand(0.6, ActionDoCommand(PoundSpikes()));
}

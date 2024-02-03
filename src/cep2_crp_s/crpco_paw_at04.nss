/* PLAYER ACTION SYSTEM - co_pas_at04
   Attempt to remove the spikes holding this door shut
   For the door spiking system
   v1.00
*/
const int CRP_DEBUG = 1;
object oDoor = GetLocalObject(OBJECT_SELF, "PAW_TARGET");

void SpikeAnimFinish()
{
    object oSpikeSide = GetNearestObjectByTag("SPIKEMARKER");
    object oOtherSide = GetNearestObjectByTag("SPIKEMARKER", OBJECT_SELF, 2);
    DestroyObject(oSpikeSide);
    DestroyObject(oOtherSide);

    if(!GetLocalInt(oDoor, "LOCKED"))
    {
        SetLocked(oDoor, FALSE);
    }
    DeleteLocalInt(oDoor, "SPIKED");
    CreateItemOnObject("crpi_ironspikes", OBJECT_SELF, 1);
    object oTransDoor = GetTransitionTarget(oDoor);
    if(GetObjectType(oTransDoor) == OBJECT_TYPE_DOOR)
    {
        DeleteLocalInt(oTransDoor, "TRNS_SPIKE_OTHER_SIDE");
        DeleteLocalInt(oTransDoor, "SPIKED");
    }
}

void RemoveSpikes()
{
    object oMallet = GetItemPossessedBy(OBJECT_SELF, "crpi_spk_mallet");
    object oRH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if(oMallet != oRH)
    {
        ActionUnequipItem(oRH);
        ActionEquipItem(oMallet, INVENTORY_SLOT_RIGHTHAND);
    }
    DelayCommand(1.5, AssignCommand(oDoor, PlaySound("as_cv_winch1")));
    ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 0.25, 5.0);
    ActionDoCommand(SpikeAnimFinish());
    /*if(!GetLocalInt(oDoor, "LOCKED"))
    {
        SetLocked(oDoor, FALSE);
    }
    DeleteLocalInt(oDoor, "SPIKED");
    CreateItemOnObject("crpi_ironspikes", OBJECT_SELF, 1);
    object oTransDoor = GetTransitionTarget(oDoor);
    if(GetObjectType(oTransDoor) == OBJECT_TYPE_DOOR)
    {
        DeleteLocalInt(oTransDoor, "TRNS_SPIKE_OTHER_SIDE");
        DeleteLocalInt(oTransDoor, "SPIKED");
    }*/
}
void CheckSpikeFacing()
{
    if(GetIsOpen(oDoor))
    {
        RemoveSpikes();
        return;
    }
    if(GetLocalInt(oDoor, "TRNS_SPIKE_OTHER_SIDE"))
    {
        FloatingTextStringOnCreature("This door is spiked from the other side.", OBJECT_SELF);
        return;
    }
    object oSpikeSide = GetNearestObjectByTag("SPIKEMARKER");
    if(GetLocalInt(oSpikeSide, "SPIKE_SIDE") == 1)
    {
        //object oOtherSide = GetNearestObjectByTag("SPIKEMARKER", OBJECT_SELF, 2);
        //DestroyObject(oSpikeSide);
        //DestroyObject(oOtherSide);
        RemoveSpikes();
    }
    else
        FloatingTextStringOnCreature("This door is spiked from the other side.", OBJECT_SELF);
}

void main()
{
    ActionMoveToObject(oDoor);
    ActionDoCommand(CheckSpikeFacing());
}

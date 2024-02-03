/* PLAYER ACTION SYSTEM - co_pas_at11
   Spike a door open
   v1.00
*/
#include "crp_inc_paw"
object oDoor = GetLocalObject(OBJECT_SELF, "PAW_TARGET");

void PoundSpikes()
{
    if(GetLocalInt(oDoor, "SPIKED") == 1)
    {
        FloatingTextStringOnCreature("Someone has already spiked this door.", OBJECT_SELF, FALSE);
        return;
    }
    DelayCommand(2.5, AssignCommand(oDoor, PlaySound("as_cv_minepick2")));
    crp_PlayAnimation(ANIMATION_SPIKE_LOW);
    //ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.00, 2.0);
    object oSpikes = GetItemPossessedBy(OBJECT_SELF, "crpi_ironspikes");
    int nStackSize = GetNumStackedItems(oSpikes);
    if(nStackSize == 1)
        DestroyObject(oSpikes);
    else
        SetItemStackSize(oSpikes, nStackSize - 1);

    SetLocalInt(oDoor, "SPIKED", 1);
    object oTransDoor = GetTransitionTarget(oDoor);
    if(GetObjectType(oTransDoor) == OBJECT_TYPE_DOOR)
    {
        AssignCommand(oTransDoor, ActionOpenDoor(oTransDoor));
        SetLocalInt(oTransDoor, "SPIKED", 1);
    }
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
    DelayCommand(0.5, ActionMoveToObject(oDoor));
    DelayCommand(0.6, ActionDoCommand(PoundSpikes()));
}

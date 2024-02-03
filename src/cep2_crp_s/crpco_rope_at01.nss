#include "x0_i0_position"

object oGoTo = GetLocalObject(OBJECT_SELF, "ROPE");
object oPC = GetPCSpeaker();

void EnterPit()
{
    //float fDir = GetOppositeDirection(GetFacing(oPC));
    //AssignCommand(oPC, SetFacing(fDir));
    ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
    ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND));
    ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM7, 0.5, 0.5);
    DelayCommand(0.2, SetCommandable(FALSE, OBJECT_SELF));
    DelayCommand(0.83, SetCommandable(TRUE, OBJECT_SELF));
    DelayCommand(0.85, ActionJumpToObject(oGoTo));
}
void main()
{
    AssignCommand(oPC, ActionMoveToObject(OBJECT_SELF));
    AssignCommand(oPC, ActionDoCommand(EnterPit()));
}

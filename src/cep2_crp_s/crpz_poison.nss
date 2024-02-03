#include "crp_inc_poison"
void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetItemActivatedTarget();
    string sPoison = GetStringRight(GetResRef(GetItemActivated()), 2);
    if(oPC != GetItemPossessor(oTarget))
    {
        AssignCommand(oPC, ActionMoveToObject(oTarget, FALSE, 0.5f));
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 0.75, 2.0));
    }
    else
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 0.5, 2.0));

    AssignCommand(oPC, ActionDoCommand(PoisonWeapon(oPC, GetItemActivatedTarget(), sPoison)));
}

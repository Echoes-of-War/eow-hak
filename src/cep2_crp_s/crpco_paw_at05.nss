/* PLAYER ACTION SYSTEM - co_pas_at05
   Search this inventory for hidden compartments
   v1.00
*/
#include "x0_i0_position"
#include "crp_inc_paw"

void main()
{
    object oTarget = GetSpellTargetObject();
    int nTrapped = GetIsTrapped(oTarget);
    int nLocked = GetLocked(oTarget);
    int nInventory = GetHasInventory(oTarget);
    string sMsg;

    ActionInteractObject(oTarget);

    if(nTrapped)
    {
        return;
    }
    if(nLocked)
    {
        sMsg = "You must open this before searching it.";
        ActionDoCommand(DisplayText(sMsg));
        return;
    }
    if(nInventory)
    {
        object oItem = GetFirstItemInInventory(oTarget);
        if(GetIsObjectValid(oItem))
        {
            sMsg = "You must remove the items from this before searching it.";
            ActionDoCommand(DisplayText(sMsg));
            return;
        }
        else
        {
            DisplayText("Searching");
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 0.5);
            ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 0.6, 1.5);
            ActionDoCommand(SearchForHiddenCompartment(oTarget, nInventory));
            return;
        }
    }
    else
    {
        //ActionMoveToObject(oTarget);
        //ActionDoCommand(SetFacingPoint(GetPosition(oTarget)));
        DisplayText("Searching");
        ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 0.5);
        ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 0.6, 1.5);
        ActionDoCommand(SearchForHiddenCompartment(oTarget));
    }
}

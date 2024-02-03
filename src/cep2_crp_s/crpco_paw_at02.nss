/* PLAYER ACTION SYSTEM - co_pas_at02
   Actively detect traps on a placeable or door
   v1.00
*/
#include "crp_inc_paw"
#include "x0_i0_position"
void main()
{
    object oTarget = GetSpellTargetObject();
    if(GetIsTrapped(oTarget) && GetTrapDetectedBy(oTarget, OBJECT_SELF))
    {
        FloatingTextStringOnCreature("You have already found the trap here.", OBJECT_SELF, FALSE);
        return;
    }
    ActionMoveToLocation(GenerateNewLocation(OBJECT_SELF, GetDistanceBetween(oTarget, OBJECT_SELF) - 1.0f, GetFacing(OBJECT_SELF), GetFacing(OBJECT_SELF)));
    ActionDoCommand(DisplayText("Searching"));
    ActionDoCommand(SetFacingPoint(GetPosition(oTarget)));
    ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 0.5, 1.0);
    ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 0.25, 2.5);
    ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 0.25, 0.5);
    ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 0.5);
    ActionDoCommand(DetectTraps(oTarget));
}

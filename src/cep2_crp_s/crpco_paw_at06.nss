/* PLAYER ACTION SYSTEM - co_pas_at06
   Actively search for hidden objects (traps, secret doors, tracks)
   v1.00
*/

#include "crp_inc_paw"
void main()
{

    location lEnd = GetSpellTargetLocation();
    location lStart = GetLocation(OBJECT_SELF);
    float fDis = GetDistanceBetweenLocations(lStart, lEnd);
    if(fDis > 2.5)
    {
        location lMoveTo = GetThreeQuarterLocation(lStart, lEnd);
        ActionMoveToLocation(lMoveTo);
    }
    ActionDoCommand(DisplayText("Searching"));
    DelayCommand(fDis - 1.0f, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0, 1.0));
    DelayCommand(fDis, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 1.0));
    DelayCommand(fDis + 1.0f, ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 3.0));
    DelayCommand(fDis + 2.0f, ActionDoCommand(SearchForSecrets(lEnd)));
}

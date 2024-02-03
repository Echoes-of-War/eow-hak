/* PLAYER ACTION SYSTEM - co_pas_at07
   Setup a campsite here
   v1.00
*/
#include "crp_inc_rest"
#include "x0_i0_position"
void main()
{
    int CanDo = 0;
    object oPC = GetPCSpeaker();
    location lLoc = GetSpellTargetLocation();

    if(HasTinder(oPC) && GetWeather(GetArea(oPC)) == WEATHER_CLEAR)
    {
        ActionMoveToLocation(lLoc);
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.5);
        ActionDoCommand(MakeCampFire(lLoc));

        float fDir = GetFacingFromLocation(lLoc);
        lLoc = GenerateNewLocationFromLocation(lLoc, 1.5, fDir, fDir);

        object oWood = GetLocalObject(oPC, "FIREWOOD");
        ActionDoCommand(DestroyObject(oWood));
        DeleteLocalObject(oPC, "FIREWOOD");
        object oTinder = GetLocalObject(oPC, "TINDER");
        SetItemCharges(oTinder, GetItemCharges(oTinder) - 1);
        DeleteLocalObject(oPC, "TINDER");
        CanDo = 1;
    }
    string sTent = GetTentType(oPC);
    if(sTent != "")
    {
        ActionMoveToLocation(lLoc);
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.5);
        ActionDoCommand(RaiseTent(sTent, lLoc));

        object oTent = GetLocalObject(oPC, "TENT");
        ActionDoCommand(DestroyObject(oTent));
        DeleteLocalObject(oPC, "TENT");
        CanDo = 1;
    }
    if(!CanDo)
        FloatingTextStringOnCreature("You have nothing to build a campsite with.", oPC, FALSE);

}

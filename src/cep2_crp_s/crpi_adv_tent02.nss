//Raise a tent
#include "crp_inc_rest"

const string sTent = "crpp_tent02";
const string sAdvTent = "crpi_adv_tent02";

void main()
{
    location lLoc = GetSpellTargetLocation();

    ActionMoveToLocation(lLoc);
    ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.5);
    ActionDoCommand(RaiseTent(sTent, lLoc));

    object oTent = GetItemPossessedBy(OBJECT_SELF, sAdvTent);
    DestroyObject(oTent);
}

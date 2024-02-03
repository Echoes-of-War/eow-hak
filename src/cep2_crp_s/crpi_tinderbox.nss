#include "crp_inc_rest"
void SendFailedMessage()
{
    FloatingTextStringOnCreature("Its too wet to build a fire.", OBJECT_SELF, FALSE);
}
void main()
{
    object oWood = GetItemActivatedTarget();
    string sTag = GetTag(oWood);
    if(GetWeather(GetArea(OBJECT_SELF)) != WEATHER_CLEAR)
    {
        ActionMoveToObject(oWood);
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.5);
        ActionDoCommand(SendFailedMessage());
        return;
    }
    if(!(sTag == "crpi_wood01" || sTag == "crpi_wood02"))
    {
        FloatingTextStringOnCreature("Invalid Target", OBJECT_SELF, FALSE);
        return;
    }
    else
    {
        location lLoc = GetLocation(oWood);
        ActionMoveToObject(oWood);
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.5);
        ActionDoCommand(MakeCampFire(lLoc));
        ActionDoCommand(DestroyObject(oWood));
    }
}

#include "crp_inc_control"

int StartingConditional()
{
    object oTrigger = GetLocalObject(OBJECT_SELF, "LISTEN_TRIGGER");
    object oArea = GetArea(OBJECT_SELF);

    if((GetIsObjectValid(oTrigger) && GetLocalInt(oTrigger, "DO_ONCE") != 1) ||
       (OUTDOOR_LISTENING && !GetIsAreaInterior(oArea)) &&
        GetLocalInt(oArea, "NO_LISTENING") != 1)
    {
        return TRUE;
    }
    return FALSE;

}
/*int StartingConditional()
{
    if ((OUTDOOR_LISTENING) && GetIsAreaAboveGround(GetArea(GetPCSpeaker())))
    {
        return TRUE;
    }
    else return FALSE;
}

 return GetIsObjectValid(oTrigger) && GetLocalInt(oTrigger, "DO_ONCE") != 1; */

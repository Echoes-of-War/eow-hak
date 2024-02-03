/* PLAYER ACTION SYSTEM - co_pas_ta09
   Check to see if this is a bleeding creature and if the player has
   bandages to stabilize the bleeding.
   v1.00
*/
int StartingConditional()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "PAW_TARGET");
    int nType = GetLocalInt(OBJECT_SELF, "PAW_TARGET_TYPE");

    if(nType == OBJECT_TYPE_CREATURE &&
       GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "crpi_bandages")))
    {
        int nHP = GetCurrentHitPoints(oTarget);
        //SendMessageToPC(OBJECT_SELF, IntToString(nHP));
        if(nHP > -10 && nHP <= 0)
            return TRUE;
    }

    return FALSE;
}

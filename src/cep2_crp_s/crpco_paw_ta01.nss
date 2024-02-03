/* PLAYER ACTION SYSTEM - co_pas_ta01
   Check to see if this is a closed door so it can be listened at.
   v1.00
*/

int StartingConditional()
{
    int nType = GetLocalInt(OBJECT_SELF, "PAW_TARGET_TYPE");
    int nOpen = GetLocalInt(OBJECT_SELF, "PAW_OPEN");
    if(nType == OBJECT_TYPE_DOOR && !nOpen)
        return TRUE;
    else
        return FALSE;
}

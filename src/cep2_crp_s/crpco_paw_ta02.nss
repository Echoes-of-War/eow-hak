/* PLAYER ACTION SYSTEM - co_pas_ta02
   Check to see if this is a closed door or placeable - to detect traps.
   v1.01
*/
int StartingConditional()
{
    int nType = GetLocalInt(OBJECT_SELF, "PAW_TARGET_TYPE");
    int nOpen = GetLocalInt(OBJECT_SELF, "PAW_OPEN");

    if((nType == OBJECT_TYPE_DOOR || nType == OBJECT_TYPE_PLACEABLE) &&
       !nOpen)
        return TRUE;
    else
        return FALSE;
}

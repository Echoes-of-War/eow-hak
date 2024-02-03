/* PLAYER ACTION SYSTEM - co_pas_ta06
   Check to see if this is an empty section of floor so it can be checked
   for secret or hidden objects.
   v1.00
*/
int StartingConditional()
{
    int nType = GetLocalInt(OBJECT_SELF, "PAW_TARGET_TYPE");
    int nPit = GetLocalInt(OBJECT_SELF, "PIT_OPTIONS");

    if(nType == 0 && nPit < 1)
        return TRUE;
    else
        return FALSE;
}

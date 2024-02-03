/* PLAYER ACTION SYSTEM - co_pas_ta07
   Check to see if this is an empty section of ground outside so that
   camp can be struck here.
   v1.00
*/
int StartingConditional()
{

    int nType = GetLocalInt(OBJECT_SELF, "PAW_TARGET_TYPE");
    int nPit = GetLocalInt(OBJECT_SELF, "PIT_OPTIONS");

    if(nType == 0 && nPit < 1 &&
       !GetIsAreaInterior(GetArea(OBJECT_SELF)))
        return TRUE;
    else
        return FALSE;
}

/* Player Action System - co_pas_ta13
   Is there a rope lowered into this pit?
*/
int StartingConditional()
{
    int nOption = GetLocalInt(OBJECT_SELF, "PIT_OPTIONS");

    if(nOption == 1)
         return TRUE;
    else
        return FALSE;
}

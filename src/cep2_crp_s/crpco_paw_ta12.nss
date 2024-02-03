/* Player Action System
   Should we lower a rope into this pit?
*/
int StartingConditional()
{
    int nOption = GetLocalInt(OBJECT_SELF, "PIT_OPTIONS");

    if(nOption == 2)
         return TRUE;
    else
        return FALSE;
}

#include "crp_inc_rest"
int StartingConditional()
{
    // If it hasn't been long enough since we last rested.....
    int nHours = GetIsRestingAllowed(GetPCSpeaker());
    if(nHours != 999 || GetLocalInt(OBJECT_SELF, "NO_REST"))
        return FALSE;

    return TRUE;
}

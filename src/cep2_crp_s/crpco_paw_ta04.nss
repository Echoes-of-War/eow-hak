/* PLAYER ACTION SYSTEM - co_pas_ta04
   Check to see if this is a door that has been spiked so that the spikes
   can be retrieved.
   v1.00
*/
#include "crp_inc_paw"
int StartingConditional()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "PAW_TARGET");
    int nType = GetLocalInt(OBJECT_SELF, "PAW_TARGET_TYPE");
    int nMallet = GetLocalInt(OBJECT_SELF, "PAW_MALLET");

    if(nType == OBJECT_TYPE_DOOR && nMallet &&
       GetLocalInt(oTarget, "SPIKED") == 1)
        return TRUE;
    else
        return FALSE;
}

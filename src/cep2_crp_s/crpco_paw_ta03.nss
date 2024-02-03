/* PLAYER ACTION SYSTEM - co_pas_ta03
   Check to see if this is a door and if we have spikes and a mallet.
   For the door spiking system
   v1.00
*/
int StartingConditional()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "PAW_TARGET");
    int nType = GetLocalInt(OBJECT_SELF, "PAW_TARGET_TYPE");
    int nOpen = GetLocalInt(OBJECT_SELF, "PAW_OPEN");
    int nSpikes = GetLocalInt(OBJECT_SELF, "PAW_SPIKES");
    int nMallet = GetLocalInt(OBJECT_SELF, "PAW_MALLET");

    if(nType == OBJECT_TYPE_DOOR && !nOpen &&
       nSpikes && nMallet &&
       GetLocalInt(oTarget, "SPIKED") == 0)
        return TRUE;
    else
        return FALSE;
}

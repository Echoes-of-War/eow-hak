/* PLAYER ACTION SYSTEM - co_pas_ta05
   Check to see if this is an object with an inventory so that it
   can be searched for hidden compartments.
   v1.00
*/
int StartingConditional()
{
    int nHC = GetLocalInt(OBJECT_SELF, "PAW_HIDDEN_COMPARTMENT");

    if(nHC)
        return TRUE;
    else
        return FALSE;
}

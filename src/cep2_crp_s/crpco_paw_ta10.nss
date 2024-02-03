/* PLAYER ACTION SYSTEM - co_pas_ta10
   Check probability that a player wants to jump to this location
   v1.00
*/
#include "crp_inc_paw"

int StartingConditional()
{
    int nJump = GetLocalInt(OBJECT_SELF, "PAW_JUMP");

    if(nJump && GetLocalInt(OBJECT_SELF, "NO_JUMP") != TRUE)
        return TRUE;
    else
        return FALSE;
}

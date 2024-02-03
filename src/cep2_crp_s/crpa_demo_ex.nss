#include "crp_inc_control"
void main()
{
    if(CRP_CONTROLLED_RESTING_ONLY) return;
    else DeleteLocalInt(GetExitingObject(), "NO_REST");
}

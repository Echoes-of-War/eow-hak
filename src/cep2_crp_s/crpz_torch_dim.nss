//::///////////////////////////////////////////////
//:: torch_Dimmer Rev. 2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*   See "loc_inc_torches" for usage details
     and author's info                          */

#include "x2_inc_itemprop"

void main()
{
    IPRemoveAllItemProperties(OBJECT_SELF, DURATION_TYPE_PERMANENT);
    IPSafeAddItemProperty(OBJECT_SELF, ItemPropertyLight(2, 3), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
}

//::///////////////////////////////////////////////
//:: torch_OnEquip Rev. 3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*   See "loc_inc_torches" for usage details
     and author's info                          */

#include "crp_inc_torches"

void main()
{
    object oItem = GetPCItemLastEquipped();
    if (GetTag(oItem) != "NW_IT_TORCH001") return;

    int nMode = GetLocalInt(OBJECT_SELF, "EQUIP_MODE");
    switch(nMode)
    {
        case 1: TorchPrep(oItem); return;
        case 2: SetLocalInt(oItem, "TorchInHands", 0); return;
    }
}


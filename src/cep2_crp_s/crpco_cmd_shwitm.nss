#include "crp_inc_merchant"
int StartingConditional()
{
    //quick check 1 - show no more items?
    if(GetLocalInt(oMerch, "SHOW_NO_MORE_ITEMS") == TRUE)
        return FALSE;

    object oPC = GetPCSpeaker();
    int nOffset = GetLocalInt(oPC, "MERCH_MENU_ITEM") + 1;
    SetLocalInt(oPC, "MERCH_MENU_ITEM", nOffset);
    int bShowIt = crp_ShowMerchantItem(nOffset);

    return bShowIt;
}

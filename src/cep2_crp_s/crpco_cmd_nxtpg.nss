//when you click next
#include "crp_inc_merchant"
void main()
{
    int iPage = GetLocalInt(oMerch, "PAGE") + 1;
    SetLocalInt(oMerch, "PAGE", iPage);
    DeleteLocalInt(GetPCSpeaker(), "MERCH_MENU_ITEM");
    DeleteLocalInt(oMerch, "SHOW_NO_MORE_ITEMS");
}

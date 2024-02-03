//when you click previous
//only shows up when iPage >= 1;
#include "crp_inc_merchant"
void main()
{
   int iPage = GetLocalInt(oMerch, "PAGE") - 1;
   SetLocalInt(oMerch, "PAGE", iPage);
   DeleteLocalInt(OBJECT_SELF, "SHOW_NO_MORE_ITEMS");
   DeleteLocalInt(GetPCSpeaker(), "MERCH_MENU_ITEM");
}

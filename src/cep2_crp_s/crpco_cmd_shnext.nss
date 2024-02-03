#include "crp_inc_merchant"
int StartingConditional()
{
    string sMenu = GetLocalString(oMerch, "MENU");
    int iPage = GetLocalInt(oMerch, "PAGE");
    int iSub = (iPage * 6) + 7;

    return GetLocalString(oMerch, "ITEM" + IntToString(iSub)) != "";
}

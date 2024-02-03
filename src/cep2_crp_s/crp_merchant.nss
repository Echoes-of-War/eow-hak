///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//:: Refer to the actual script below as an example and reference
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//
//SetMerchantItem( ListNumber, "ItemName", "Item resref", NumberOfCoins, TYPE_OF_COIN);
//
//    ListNumber----- The order that the item will show up in the menu.
//                    Use 1,2,3,... in order, on each of your lines.
//    "ItemName"----- The text that will show up in the merchant's menu dialog
//                    for each item.
//    "Item resref"-- The blueprint name or resref of the item that the player
//                    should receive when they select this item. (case sensitive)
//    NumberOfCoins-- The number of coins that the item costs.  If the item
//                    costs 3cp, then this number should be 3.  If the item
//                    costs 2sp, then this number should be 2...
//    TYPE_OF_COIN--- The only legal values for this field are:
//                    COIN_COPPER
//                    COIN_SILVER or
//                    COIN_GOLD
//                    I'm not sure why you would want to use COIN_GOLD,
//                    but you might. If you want something to cost 2sp, then
//                    NumberOfCoins = 2, and TYPE_OF_COIN = COIN_SILVER.
//
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////


#include "crp_inc_merchant"
void main()
{
    SetMerchantItem(1, "Torch", "nw_it_torch001", 3, COIN_COPPER);
    SetMerchantItem(2, "Iron Spike", "crpi_ironspikes", 1, COIN_COPPER);
    SetMerchantItem(3, "Rope", "crpi_rope", 3, COIN_SILVER);
    SetMerchantItem(4, "Grappling Hook", "crpi_graphook", 5, COIN_SILVER);
    SetMerchantItem(5, "Tinderbox", "crpi_tinderbox", 1, COIN_SILVER);
    SetMerchantItem(6, "Bedroll", "crpi_bedroll", 2, COIN_SILVER);
    SetMerchantItem(7, "Bandages", "crpi_bandages", 1, COIN_COPPER);
}

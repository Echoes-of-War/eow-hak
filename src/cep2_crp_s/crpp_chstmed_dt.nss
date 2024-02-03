//C.R.A.P. Container on death script
//KC Solberg - 11/20/05

#include "x0_i0_treasure"

void main()
{
    CRP_CONTAINER_HAS_BEEN_DESTROYED = 1;
    int nNoAutoGen = 0;

    //break fragile items routine
    if(CRP_USE_BREAKABLE_ITEMS)
    {
        nNoAutoGen = crp_BreakFragileItems();
    }

    if(GetLocalInt(OBJECT_SELF, "DO_ONCE"))
        return;

    int nCP = GetLocalInt(OBJECT_SELF, "CP");
    int nSP = GetLocalInt(OBJECT_SELF, "SP");
    int nEP = GetLocalInt(OBJECT_SELF, "EP");
    int nGP = GetLocalInt(OBJECT_SELF, "GP");
    int nPP = GetLocalInt(OBJECT_SELF, "PP");

    if((nCP + nSP + nEP + nGP + nPP) < 1 && (nNoAutoGen != 1))
    {
        CTG_CreateTreasure(TREASURE_TYPE_MED, GetLastOpener(), OBJECT_SELF);
    }

    if(!CRP_USE_COINS) return;

    GiveCoinsTo(OBJECT_SELF, nCP, COIN_COPPER);
    GiveCoinsTo(OBJECT_SELF, nSP, COIN_SILVER);
    GiveCoinsTo(OBJECT_SELF, nEP, COIN_ELECTRUM);
    GiveCoinsTo(OBJECT_SELF, nGP, COIN_GOLD);
    GiveCoinsTo(OBJECT_SELF, nPP, COIN_PLATINUM);
}

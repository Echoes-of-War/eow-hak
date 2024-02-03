#include "nw_i0_plot"
#include "crp_inc_control"
void main()
{
    object oPC = OBJECT_SELF;
    object oBag = GetItemPossessedBy(oPC, "crpi_playerbag");
    if(!GetIsObjectValid(oBag))
        oBag = CreateItemOnObject("crpi_playerbag", oPC);

    if(GetIsDM(oPC))
    {
        if(!HasItem(oPC, "dmfi_dmbook"))
            CreateItemOnObject("dmfi_dmbook", oBag);
        if(!HasItem(oPC, "dmfi_exploder"))
            CreateItemOnObject("dmfi_exploder", oBag);
    }
    else
    {
        if(!HasItem(oPC, "dmfi_pc_dicebag"))
            CreateItemOnObject("dmfi_pc_dicebag", oBag);
        if(!HasItem(oPC, "dmfi_pc_emote"))
            CreateItemOnObject("dmfi_pc_emote", oBag);
        if(!HasItem(oPC, "dmfi_playerbook"))
            CreateItemOnObject("dmfi_playerbook", oBag);
        if(!HasItem(oPC, "crpi_paw"))
            CreateItemOnObject("crpi_paw", oBag);

        int i;
       // for (i=1; i<=28; i++){
            //CreateItemOnObject("crpi_spacer", oBag);}

        if (CRP_USE_COINS)
         if(!HasItem(oPC, "crpi_coinpouch"))
             CreateItemOnObject("crpi_coinpouch", oPC);
    }
}

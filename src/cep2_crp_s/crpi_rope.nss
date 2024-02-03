#include "crp_inc_paw"

string sGoTo;
location lGoTo;
object oPit;

void CreateRope()
{
    //PlaySound("as_cv_minepick2");
    location lRope = GetLocation(OBJECT_SELF);

    //Destroy Rope and Spike Items
    object oRopeItem = GetItemPossessedBy(OBJECT_SELF, "crpi_rope");
    DestroyObject(oRopeItem);
    object oSpikes = GetItemPossessedBy(OBJECT_SELF, "crpi_ironspikes");
    int nStackSize = GetNumStackedItems(oSpikes);
    if(nStackSize == 1)
        DestroyObject(oSpikes);
    else
        SetItemStackSize(oSpikes, nStackSize - 1);

    //Create Rope Placeables
    object oRopeBundle = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_ropebundle", lRope);
    object oRopeDrop = CreateObject(OBJECT_TYPE_PLACEABLE, "crpp_ropedrop", lGoTo);

    SetLocalInt(oPit, "ROPE", 1);
    SetLocalObject(oRopeBundle, "ROPE", oRopeDrop);
    SetLocalObject(oRopeDrop, "ROPE", oRopeBundle);
}

void LowerRope()
{
    DelayCommand(2.5, AssignCommand(oPit, PlaySound("as_cv_minepick2")));
    crp_PlayAnimation(ANIMATION_SPIKE_LOW);

    DelayCommand(1.0, ActionDoCommand(CreateRope()));
    //DelayCommand(0.2, SetFacingPoint(GetPosition(oPit)));
    //DelayCommand(1.0, PlaySound("as_cv_minepick2"));
    //DelayCommand(1.0, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 3.00, 0.5));
    //DelayCommand(3.0, CreateRope());
}


void main()
{

    oPit = GetNearestObjectByTag("PIT");
    float fPitDis = GetDistanceToObject(oPit);

    if(fPitDis == -1.0f)
    {
        DisplayText("There are no valid targets within range.");
        return;
    }
    else if(fPitDis <= 5.0f)
    {
        int nSpikes = GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "crpi_ironspikes"));
        int nMallet = GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "crpi_spk_mallet"));
        if(!(nSpikes && nMallet))
        {
            DisplayText("You need mallet and spikes to secure the rope.");
        }
        else
        {
            object oMallet = GetItemPossessedBy(OBJECT_SELF, "crpi_spk_mallet");
            object oRH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
            if(oMallet != oRH)
            {
                ActionUnequipItem(oRH);
                ActionEquipItem(oMallet, INVENTORY_SLOT_RIGHTHAND);
            }
            sGoTo = GetLocalString(oPit, "DESTINATION");
            lGoTo = GetLocation(GetObjectByTag(sGoTo));
            ActionMoveToLocation(GetLocation(oPit));
            ActionDoCommand(LowerRope());
        }
    }
    else
    {
        DisplayText("There are no valid targets within range.");
    }
}
    /*object oTarget = GetSpellTargetObject();

    if(GetTag(oTarget) == "crpi_graphook")
    {
        DestroyObject(oTarget);
        DestroyObject(GetItemActivated());
        CreateItemOnObject("crpi_graprope");
        return;
    }

    oPit = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, GetSpellTargetLocation());
    if(GetTag(oPit) == "PIT" && GetDistanceBetweenLocations(GetLocation(oPit), GetSpellTargetLocation()) < 2.0f)
    {
        //We have ourselves a pit
        int nSpikes = GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "crpi_ironspikes"));
        int nMallet = GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "crpi_spk_mallet"));
        if(!(nSpikes && nMallet))
        {
            DisplayText("You need mallet and spikes to secure the rope.");
            return;
        }
        else
        {
            sGoTo = GetLocalString(oPit, "DESTINATION");
            lGoTo = GetLocation(GetObjectByTag(sGoTo));
            ActionMoveToLocation(GetLocation(oPit));
            ActionDoCommand(LowerRope());
            return;
        }
    }
    else
    {
        ActionPutDownItem(GetItemActivated());
    }
} */

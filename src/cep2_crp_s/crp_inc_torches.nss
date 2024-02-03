//::///////////////////////////////////////////////
//:: Name:     torch_OnEquip Rev. 3
//:: FileName: loc_inc_torches
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    this "include" script is a customized OnEquipItem
    package which will manage the lifetimes of torches
    so that they will burn out after a set amount of
    time, customizable by the module builder.

    useful for low-magic or "real world" settings.
    developed for single-player modules; some
    modification MIGHT be necessary for use in multi-
    player. then again, it might work out of the box!

    IF YOU END UP USING THIS IN A PUBLISHED SINGLE-PLAYER,
    MULTIPLAYER OR PERSISTENT WORLD PROJECT, PLEASE LET
    ME KNOW! THANKS!

    More info: this script is different from the other
    torch management scripts out there in that it does
    NOT rely on the module heartbeat event! (some people
    HATE using heartbeat events)  this script
    uses a "pseudo" heartbeat function (recursive
    DelayCommand). therefore, the script
    only runs when it NEEDS to run - while a
    regular heartbeat always runs every 6 seconds!

    Usage: Import the included ERF file into your module.
    Put "torch_onequip" and "torch_onunequip" as your
    "OnPlayerEquipItem" and "OnPlayerUnEquipItem" events,
    respectively. Do a full build of your module.

    If you already have scripts specified for those 2 events,
    add the following commands to those files:

    1. at the top of the EquipItem script put the line:

      #include "loc_inc_torches"

    2. also in the script for EquipItem put the following within
    the "void main" section:

      object oItem = GetPCItemLastEquipped();
      if (GetTag(oItem) == "NW_IT_TORCH001")
      {
          TorchPrep(oItem);
      }

    3. in the script for UnEquipItem put the following in the
    "void main" section (no "include" line needed):

        object oItem = GetPCItemLastUnequipped();
        if (GetTag(oItem) == "NW_IT_TORCH001")
        {
            SetLocalInt(oItem, "TorchInHands", 0);
        }

    Done and done!


    ADVANCED INFO: Below, change the constant TORCH_LIFESPAN
    to suit your needs. Default torch lifespan is
    20 realtime min.

    Change the constant WANT_DIMMING if you don't
    like the dimming effect when the clock is at 60 seconds remaining.
    I think its kinda cool. It basically changes the torch's
    light property to a Dim Red light and makes it "flicker".

    This script package only works with the standard torches
    from the Aurora Toolset palette unless you modify accordingly.
    This script WILL keep track of the lifespan of EACH individual
    torch by saving state. This script will ALSO keep track of torch
    lifespans through savegames.

    One issue I have found is that when you unequip/re-equip
    the same torch repeatedly you may lose some life from it
    depending on how close to the next pseudo-HB you
    unequipped it. To fix this issue I would have to lower the time
    between each pseudo-HB which isn't really worth it, since
    that's essentially going back to the OnHeartbeat model we
    are so trying to avoid.

    Credits: Rev. 2 was mostly done by myself. I got the pseudo-HB
    idea from a script by DenOfAssassins and of course thanks
    to BioWare for including that nifty new "OnEquipItem" event
    handler in HotU 1.59.

    In Rev. 3 no real new functionality was added, just re-organized
    everything into an easy-to-use INCLUDE file, since thats
    how all the other "OnEquipItem" scripts are being packaged!
    Also, I am now using FloatyText instead of sending the player
    a console message. So the player is more aware of the fact his
    torch is slowly burning away. Before, it was easy to lose that
    message in the jumble of stuff on most people's consoles.

*/
//:://////////////////////////////////////////////
//:: Created By: LoCash (LoCash@sympatico.ca)
//:: Created On: 12/15/03
//:: Rev.2 created on: 12/19/03
//:: Rev.3 created on: 01/23/04
//:://////////////////////////////////////////////

#include "crp_inc_control"

// PROTOTYPES -------------------------------------

// Initializes Torch Management & Begins PseudoHeartbeat Sequence
void TorchPrep(object oItem);

// PseudoHeartbeat function which keeps track of torch's lifetime
void TorchPseudoHB(object oObject, int hbSessionID);


// DEFINITIONS ------------------------------------
void TorchPrep(object oItem)
{
        int iTorchLife = GetLocalInt(oItem, "TorchLife");  // get life value from torch
        int iTorchInHands = GetLocalInt(oItem, "TorchInHands");
        if (iTorchLife == 0)
        {
            iTorchLife = TORCH_LIFESPAN; // brand-new torches get lifespan set
        }
        SetLocalInt(oItem, "TorchLife", iTorchLife); // pass torchlife back to object
        if (iTorchInHands != 1)
        {
            SetLocalInt(oItem, "TorchInHands", 1);  // flag torch is "in PC's hands" now
            int iSessionID = (Random(999) + 1);     // create almost-unique session ID
            SetLocalInt(oItem, "SessionID", iSessionID);    // store it on torch
            TorchPseudoHB(oItem, iSessionID);       // run pseudoHB function
        }
}

void TorchPseudoHB(object oObject, int hbSessionID)
{
    int hbTorchInHands = GetLocalInt(oObject, "TorchInHands");
    int hbTorchLife = GetLocalInt(oObject, "TorchLife");
    int objSessionID = GetLocalInt(oObject, "SessionID");
    object oPC = GetItemPossessor(oObject);
    object oTorch = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    if ((oTorch == oObject) && (hbTorchInHands != 0) && (objSessionID == hbSessionID))
    {
        if (hbTorchLife > 1)
        {
            if ((hbTorchLife == 4) && (WANT_DIMMING == TRUE))
            {
                ExecuteScript("z_torch_dimmer", oObject);
                FloatingTextStringOnCreature("Your torch begins to fade away...",oPC,FALSE);
            }
            hbTorchLife--;
            SetLocalInt(oObject, "TorchLife", hbTorchLife);
            DelayCommand(20.0, AssignCommand(oObject, TorchPseudoHB(oObject, hbSessionID)));
            return;
        }
        if (hbTorchLife <= 1)
        {
            DestroyObject(oObject, 0.4f);
            FloatingTextStringOnCreature("Your torch sputters out and dies.",oPC,FALSE);
            return;
        }
    }
}


// debug
// void main() {}

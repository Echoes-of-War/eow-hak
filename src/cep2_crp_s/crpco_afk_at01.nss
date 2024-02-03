//  Apply AFK effect to player
#include "NW_I0_GENERIC"
void main()
{
/* Customization: */
int LOKAFK = 751;  // Modify this to match your visualeffects.2da entry
/* Customization: */

object oPC = OBJECT_SELF;
int nHasEffect = GetLocalInt(oPC,"IsAFK");
object oMarker; // The invisible marker we'll create to monitor movement
effect eLOKAFK; // Just an effect declare
effect eTest;   // Ditto
if (nHasEffect==TRUE) // If we already have the effect on us then let's get rid of it
{

    eTest = GetFirstEffect(oPC); // Testing for the right VFX
    while (GetIsEffectValid(eTest))
    {
      if (GetEffectCreator( eTest) == OBJECT_SELF) // If I'm (the widget) the one that created it then its the right one to destroy.
      {
        RemoveEffect(oPC, eTest); // Get rid of it.
        SetLocalInt(oPC,"IsAFK",FALSE); // Flag us as not having the VFX
        oMarker = GetLocalObject(oPC,"Marker"); // Get the marker object which was stored on the PC
        DestroyObject(oMarker); // Get rid of the marker object
      }
      eTest = GetNextEffect(oPC); // Keep looping to make sure we get them all just on GP.
    }
    return;  // Get the hell out of dodge.
}
location lLocation = GetLocation(oPC); // here to avoid having to declare if we don't need it above.
oMarker = CreateObject(OBJECT_TYPE_PLACEABLE,"crpp_afkmarker",lLocation); // This object must exist.
SetLocalObject(oMarker,"PC",oPC); // Store PC on the Marker for ease of checking
SetLocalObject(oPC,"Marker",oMarker); // Store the Marker on the PC for ease of destruction
SetLocalInt(oPC,"IsAFK",TRUE); // Set us as having the VFX
eLOKAFK = EffectVisualEffect(LOKAFK); // Create the effect.
SetLocalObject(oMarker,"Widget",OBJECT_SELF); // Store the widget on the VFX for easy VFX removal checking
ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLOKAFK,oPC); // Apply the VFX to the PC and make it permanent.
FloatingTextStringOnCreature("I am currently Away From My Keyboard...",oPC); // Have the PC state his status just for the hell of it. DO it with floaty rather than speak to avoid breaking hiding.
}

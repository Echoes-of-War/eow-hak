/*
PLAYER ACTION SYSTEM - co_pas_at15
Forage this area for dead wood to build a fire.
*/

#include "crp_inc_paw"
#include "x0_i0_position"

void GiveWood()
{
    PlaySound("as_na_branchsnp3");
    FloatingTextStringOnCreature("You pull some dead branches from the tree.",OBJECT_SELF, FALSE);
    CreateItemOnObject("crpi_wood01", OBJECT_SELF);
}

void SearchForDeadWood(location lLoc)
{

    float fDir = GetFacingFromLocation(lLoc);
    location lSearchLoc = GenerateNewLocationFromLocation(lLoc, 15.0, fDir, fDir);
    object oTree = GetFirstObjectInShape(SHAPE_SPHERE, 15.0, lSearchLoc, TRUE, OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTree))
    {
        if(GetTag(oTree) == "crpp_deadtree")
        {
            ActionDoCommand(DisplayText("Searching"));
            ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 3.0);
            ActionMoveToObject(oTree);
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0, 1.0);
            ActionDoCommand(GiveWood());
            return;
        }
        oTree = GetNextObjectInShape(SHAPE_SPHERE, 15.0, lSearchLoc, TRUE, OBJECT_TYPE_PLACEABLE);
    }
    ActionDoCommand(DisplayText("Searching"));
    ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0, 3.0);
    ActionDoCommand(DisplayText("You do not see any dead wood nearby."));

}

void main()
{
    if(GetWeather(GetArea(OBJECT_SELF)) != WEATHER_CLEAR)
    {
        ActionDoCommand(DisplayText("Its too wet to find any dry wood."));
        return;
    }
    else
    {
        location lLoc = GetSpellTargetLocation();
        ActionMoveToLocation(lLoc, TRUE);
        ActionDoCommand(SearchForDeadWood(lLoc));
    }
}

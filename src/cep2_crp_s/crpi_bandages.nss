#include "crp_inc_ddr"
void main()
{
    object oPC = OBJECT_SELF;
    object oWounded = GetItemActivatedTarget();
    //Check for a valid target
    if(GetObjectType(oWounded) != OBJECT_TYPE_CREATURE)
    {
        FloatingTextStringOnCreature("Bandages may only be used on creatures.", oPC, FALSE);
        return;
    }
    if(GetRacialType(oWounded) == RACIAL_TYPE_UNDEAD)
    {
        FloatingTextStringOnCreature("The undead can not be healed.", oPC, FALSE);
        return;
    }
    if(oPC == oWounded)
    {
        ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 0.5, 5.0);
        ActionDoCommand(AttemptToStablize(oPC, oWounded));
        return;
    }
    else if(GetIsDead(oWounded))
    {
        ActionMoveToObject(oWounded, TRUE, 0.2);
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 0.5, 5.0);
        ActionDoCommand(AttemptToStablize(oPC, oWounded));
        return;
    }
    else
    {
        ActionMoveToObject(oWounded, TRUE, 0.2);
        ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 0.5, 5.0);
        ActionDoCommand(AttemptToStablize(oPC, oWounded));
        return;
    }
}

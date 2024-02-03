#include "crp_inc_control"

/*
To Place a generic sound emitter (automatic message when listening) simply
place a waypiont down and change its tag to SOUND_EMITTER.  Create a local
string Var called MESSAGE and put whatever text you want in it.

Current Creature DC modifiers are as follows:

Base DC                                             +5
Wearing a Helmet                                    +5
PC Listen Skill                                     -1/Rank
Distance Target is from PC                          +1/10ft
Type of Armor worn by Target                        +1/+2/+3/+4/+5
Target is Animal                                    +10
Target Size                                         +6/+3/-3/-6
Target In Conversation                              -5
Target Stealth Skill                                +1/Rank
*/


struct Info
{
string sMsg;
int DCMod;
};


//Will return the direction of Location based on the location of the PC
//Example: North-West
string GetCompassDir(object PC, location LOC);


struct Info GetCreatureAction(object oCreature)
{
struct Info Data;

switch (GetCurrentAction(oCreature))
{
     case ACTION_MOVETOPOINT: Data.sMsg = " something moving "; Data.DCMod = 5; break; //0
     case ACTION_PICKUPITEM: Data.sMsg = " something moving "; Data.DCMod = 2; break; //1
     case ACTION_DROPITEM: Data.sMsg = " something moving "; Data.DCMod = 2; break; //2
     case ACTION_ATTACKOBJECT: Data.sMsg = " sounds of battle "; Data.DCMod = 8; break; //3
     case ACTION_CASTSPELL: Data.sMsg = " muttered chants "; Data.DCMod = 5; break; //4
     case ACTION_OPENDOOR: Data.sMsg = " a door opening "; Data.DCMod = 3; break; //5
     case ACTION_CLOSEDOOR: Data.sMsg = " a door closing "; Data.DCMod = 3; break; //6
     case ACTION_DIALOGOBJECT: Data.sMsg = " voices "; Data.DCMod = 5; break; //7
     case ACTION_DISABLETRAP: Data.sMsg = " faint movements "; Data.DCMod = 2; break; //8
     case ACTION_RECOVERTRAP: Data.sMsg = " faint movements "; Data.DCMod = 2; break; //9
     case ACTION_FLAGTRAP: Data.sMsg = " faint movements "; Data.DCMod = 2; break; //10
     case ACTION_EXAMINETRAP: Data.sMsg = " faint movements "; Data.DCMod = 2; break; //11
     case ACTION_SETTRAP: Data.sMsg = " faint movements "; Data.DCMod = 2; break; //12
     case ACTION_OPENLOCK: Data.sMsg = " a lock opening "; Data.DCMod = 2; break; //13
     case ACTION_LOCK: Data.sMsg = " a lock closing "; Data.DCMod = 2; break; //14
     case ACTION_USEOBJECT: Data.sMsg = " faint movements "; Data.DCMod = 1; break; //15
     case ACTION_ANIMALEMPATHY: Data.sMsg = " unintellegible sounds "; Data.DCMod = 1; break; //16
     case ACTION_REST: Data.sMsg = " soft breathing "; Data.DCMod = 1; break; //17
     case ACTION_TAUNT: Data.sMsg = " taunts and rude jibes "; Data.DCMod = 5; break; //18
     case ACTION_ITEMCASTSPELL: Data.sMsg = " faint movements "; Data.DCMod = 2; break; //19
     case ACTION_COUNTERSPELL: Data.sMsg = " muttered chants "; Data.DCMod = 3; break; //31
     case ACTION_HEAL: Data.sMsg = " soothing sounds "; Data.DCMod = 2; break; //33
     case ACTION_PICKPOCKET: Data.sMsg = " faint movements "; Data.DCMod = 1; break; //34
     case ACTION_FOLLOW: Data.sMsg = " something moving "; Data.DCMod = 5; break; //35
     case ACTION_WAIT: Data.sMsg = " faint breathing "; Data.DCMod = 1; break; //36
     case ACTION_SIT: Data.sMsg = " faint breathing "; Data.DCMod = 1; break; //37
     case ACTION_SMITEGOOD: Data.sMsg = " sounds of battle "; Data.DCMod = 5; break; //40
     case ACTION_KIDAMAGE: Data.sMsg = " sounds of battle "; Data.DCMod = 5; break; //41
     case ACTION_RANDOMWALK: Data.sMsg = " something moving "; Data.DCMod = 5; break; //43
     case ACTION_INVALID: Data.sMsg = " something "; Data.DCMod = 1; break; //65535
}
return Data;
}

int CheckArmorType(object oCreature)
{
object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
int ACVal;
int DCMod;

if (oArmor != OBJECT_INVALID)
{
    ACVal = GetItemACValue(oArmor);
}

switch (ACVal)
{
    case 1: //padded
    case 2: //leather
    case 3: DCMod = 1; break; //studded/hide
    case 4: //chain shirt, scale
    case 5: DCMod = 2; break; //chain mail, breastplate
    case 6: DCMod = 3; break; //splint, banded
    case 7: DCMod = 4; break; //half-plate
    case 8: DCMod = 5; break; //full plate
    default: //no armor
}
return DCMod;
}


void MarkPartyMembers(object oPC)
{
object oPartyMember = GetFirstFactionMember(oPC, TRUE);
while (oPartyMember != OBJECT_INVALID)
{
    SetLocalInt(oPartyMember, "InParty", 1);
    oPartyMember = GetNextFactionMember(oPC, TRUE);
}

//mark all henchmen and familiars
oPartyMember = GetFirstFactionMember(oPC, FALSE);
while (oPartyMember != OBJECT_INVALID)
{
    SetLocalInt(oPartyMember, "InParty", 1);
    oPartyMember = GetNextFactionMember(oPC, FALSE);
}
}

int GetIsSilenced(object oTarget)
{
int TRUEFALSE = 0;
effect eQuiet = GetFirstEffect(oTarget);
while (GetIsEffectValid(eQuiet))
{
    if (GetEffectType(eQuiet) == EFFECT_TYPE_SILENCE)
    {
        TRUEFALSE = 1;
        break;
    }
    eQuiet = GetNextEffect(oTarget);
}
return TRUEFALSE;
}



void Listen(object PC)
{
/*
Creatures must be alive, must not be a DM or in PCs party, and must be within
listening range of 40 meters
Things that affect the DC to hear a creature are:


Target Creature Size
Distance from PC
Target Creature Stealthiness
PC's LISTEN Skill Rank
Target Creature IsInConversation
is PC Silenced
is Target Creature silenced
is PC wearing a Helmet
is Target Creature wearing armor (and what kind)
Target Creatures current Action
is Target Creature an Animal
*/
object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 40.0, GetLocation(PC), FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_WAYPOINT);

struct Info ActionInfo;
int fDistance;
int DC = 0;
int BaseDC = 10;
int nQuiet = 0;

MarkPartyMembers(PC);

//does listener have skillz?
if (GetHasSkill(SKILL_LISTEN, PC))
{
    BaseDC = BaseDC - GetSkillRank(SKILL_LISTEN, PC);
}

//is PC wearing a helmet?
if (GetItemInSlot(INVENTORY_SLOT_HEAD, PC) != OBJECT_INVALID)
{
    BaseDC = BaseDC + 5;
}

//is PC silenced? exit if he/she is
if (GetIsSilenced(PC)) return;

//Cycle through the targets within the shape until an invalid object is captured.
while(GetIsObjectValid(oTarget))
{
    if ((GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) && (oTarget != PC) &&
        (GetIsDM(oTarget)==FALSE) && (GetCurrentHitPoints(oTarget) > 0) &&
        (GetLocalInt(oTarget, "InParty") == 0) && (GetIsSilenced(oTarget) == 0))
    {
        DC = BaseDC;

        //check distance between creature and listener (in feet)
        fDistance = FloatToInt(GetDistanceBetween(PC, oTarget) * 3.28);
        DC = DC + ((fDistance / 10) - 1);

        //is target wearing armor and if so, what kind?
        DC = DC - CheckArmorType(oTarget);

        //is target an Animal?
        if ((GetRacialType(oTarget)== RACIAL_TYPE_ANIMAL) ||
        GetRacialType(oTarget) == RACIAL_TYPE_OOZE)
        {
            DC = DC + 10;
        }

        //check size of creature, larger creature easier to hear
        switch (GetCreatureSize(oTarget))
        {
            case CREATURE_SIZE_TINY: DC = DC + 6; break;
            case CREATURE_SIZE_SMALL: DC = DC + 3;  break;
            case CREATURE_SIZE_MEDIUM: break;
            case CREATURE_SIZE_LARGE: DC = DC - 3; break;
            case CREATURE_SIZE_HUGE: DC = DC - 6; break;
            case CREATURE_SIZE_INVALID: break;
        }

        //check if creature is in stealth mode and if it is, add its
        //move_silently skill rank to the DC
        if (GetStealthMode(oTarget)==STEALTH_MODE_ACTIVATED)
        {
            nQuiet = GetSkillRank( SKILL_MOVE_SILENTLY, oTarget );
            DC = DC + nQuiet;
        }

        //check if target is in conversation
        if (IsInConversation(oTarget))
        {
            DC = DC - 5;
        }

        //check what targets current action is
        ActionInfo = GetCreatureAction(oTarget);
        DC = DC - ActionInfo.DCMod;

        if (d20() >= DC)
        {
            SetCustomToken(888, "You think you hear" + ActionInfo.sMsg + "to the " + GetCompassDir(PC, GetLocation(oTarget)));
        }
    }

    if ((GetObjectType(oTarget) == OBJECT_TYPE_WAYPOINT) && (GetTag(oTarget) == "SOUND_EMITTER"))
    {
        SetCustomToken(888, GetLocalString(oTarget, "MESSAGE"));
    }

   //Select the next target within the spell shape.
   oTarget = GetNextObjectInShape(SHAPE_SPHERE, 40.0, GetLocation(PC), FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_WAYPOINT);
}
}


// GetDirection Routines
vector GetVectorAB(vector vectorA, object objectB)
{
//vector vA = GetPosition(oA);
    vector vectorB = GetPosition(objectB);
    vector vectorDelta = (vectorA - vectorB);
    return vectorDelta;
}

float GetDirection(vector oTarget, object oPC)
{
    vector vdTarget = GetVectorAB(oTarget, oPC);
    float fDirection = VectorToAngle(vdTarget);
    return fDirection;
}

string GetCompassDir(object PC, location LOC)
{
vector vec = GetPositionFromLocation(LOC);
float fDirection = GetDirection(vec, PC);

//SendMessageToPC(PC, "Angle is: " + FloatToString(fDirection));
if ((fDirection > 22.5) && (fDirection < 67.5)) return "North-East";
if ((fDirection > 67.5) && (fDirection < 112.5)) return "North";
if ((fDirection > 112.5) && (fDirection < 157.5)) return "North-West";
if ((fDirection > 157.5) && (fDirection < 202.5)) return "West";
if ((fDirection > 202.5) && (fDirection < 247.5)) return "South-West";
if ((fDirection > 247.5) && (fDirection < 292.5)) return "South";
if ((fDirection > 292.5) && (fDirection < 337.5)) return "South-East";
if ((fDirection > 337.5) || (fDirection < 22.5))
{
    return "East";
}
else return "INVALID DIRECTION";
}
string GetSoundDescriptor(int nRacialType, object oCreature)
{
    string sDescriptor;
    switch(nRacialType)
    {
        case RACIAL_TYPE_ABERRATION:
            sDescriptor = "From behind the door you hear sounds alien and strange."; break;
        case RACIAL_TYPE_ANIMAL:
            sDescriptor = "You hear the unmistakeable sound of animal snarls and grunts coming from behind this closed door."; break;
        case RACIAL_TYPE_BEAST:
            sDescriptor = "You hear angry grunts and screeches coming from behind the door. Nothing specific enough to identify easily."; break;
        case RACIAL_TYPE_CONSTRUCT:
            sDescriptor = "Ear pressed against the door, you hear a heavy, plodding stride... The footsteps sound almost mechanical in their rhythm."; break;
        case RACIAL_TYPE_DRAGON:
            sDescriptor = "You hear the slithering sound of serpentine scales drug across the floor, followed by a hiss of breath like steam from a boiler."; break;
        case RACIAL_TYPE_DWARF:
            sDescriptor = "You hear a voice (or voices) behind the door speaking in what sounds to be a dialect of Dwarven."; break;
        case RACIAL_TYPE_ELEMENTAL:
            if ((GetAppearanceType(oCreature) == APPEARANCE_TYPE_ELEMENTAL_AIR) || (GetAppearanceType(oCreature) == APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER))
            {
                sDescriptor = "You hear what you can only describe as a voice (or voices) that sound like the howling winds."; break;
            }
            else if ((GetAppearanceType(oCreature) == APPEARANCE_TYPE_ELEMENTAL_FIRE) || (GetAppearanceType(oCreature) == APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER))
            {
                sDescriptor = "You hear what you can only describe as a voice (or voices) that sound like a roaring flame."; break;
            }
            else if ((GetAppearanceType(oCreature) == APPEARANCE_TYPE_ELEMENTAL_EARTH) || (GetAppearanceType(oCreature) == APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER))
            {
                sDescriptor = "You hear what you can only describe as a voice (or voices) that sound like a stones being grated together."; break;
            }
            else if ((GetAppearanceType(oCreature) == APPEARANCE_TYPE_ELEMENTAL_WATER) || (GetAppearanceType(oCreature) == APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER))
            {
                sDescriptor = "You hear what you can only describe as a voice (or voices) that sound like a babbling brook."; break;
            }
            else
            {
                sDescriptor = "You hear indistinct sounds and you cannot recognize what might be making them."; break;
            }
        case RACIAL_TYPE_ELF:
            sDescriptor = "You hear a voice (or voices) behind the door speaking in what sounds to be a dialect of Elven."; break;
        case RACIAL_TYPE_FEY:
            sDescriptor = "You hear a voice (or voices) behind the door that have a light airy quality to them. You can't make out much more but whatever is behind this door isn't human."; break;
        case RACIAL_TYPE_GIANT:
            sDescriptor = "Ear pressed against the door, you hear the sound of slow, heavy footsteps and feel the vibrations of each plodding stride."; break;
        case RACIAL_TYPE_GNOME:
            sDescriptor = "You hear a voice (or voices) behind the door speaking in what sounds to be a dialect of Gnomish."; break;
        case RACIAL_TYPE_HALFELF:
            sDescriptor = "You hear a voice (or voices) behind the door speaking in what sounds to be a dialect of Common."; break;
        case RACIAL_TYPE_HALFLING:
            sDescriptor = "You hear a voice (or voices) behind the door speaking in what sounds to be a dialect of Halfling."; break;
        case RACIAL_TYPE_HALFORC:
            sDescriptor = "You hear a voice (or voices) behind the door speaking in what sounds to be a bastardized amalgamation of both Common and Orcish languages."; break;
        case RACIAL_TYPE_HUMAN:
            sDescriptor = "You hear a voice (or voices) behind the door speaking in what sounds to be a dialect of Common."; break;
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
            sDescriptor = "From behind the door you hear footsteps and crude gutteral voice(s) speaking in what sounds like a goblinoid dialect."; break;
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
            sDescriptor = "Ear pressed against the door, you hear the slow, heavy sound of a monstrous clawed, or perhaps cloven-footed, step.  You feel the vibrations of each plodding stride."; break;
        case RACIAL_TYPE_HUMANOID_ORC:
            sDescriptor = "From behind the door you hear footsteps and crude gutteral voice(s) speaking in what sounds like an orcish dialect."; break;
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
            sDescriptor = "From behind the door you hear a hissing, reptilian like voice(s) and the clicks of clawed feet against stone."; break;
        case RACIAL_TYPE_MAGICAL_BEAST:
            sDescriptor = "You hear indistinct sounds and you cannot recognize what might be making them."; break;
        case RACIAL_TYPE_OOZE:
            sDescriptor = "You hear sounds of squelching and other odd noises that you can best describe as the sound of a wet fish being slapped against a brick wall."; break;
        case RACIAL_TYPE_OUTSIDER:
            sDescriptor = "You hear a voice (or voices) that are heavily accented and human-like but in a dialect you can't understand."; break;
        case RACIAL_TYPE_SHAPECHANGER:
            sDescriptor = "You hear indistinct sounds and you cannot recognize what might be making them."; break;
        case RACIAL_TYPE_UNDEAD:
            sDescriptor = "From behind the door you hear the tortured moans of a creature that may once have been human, but is no more.  The sound makes your blood chill."; break;
        case RACIAL_TYPE_VERMIN:
            sDescriptor = "The creepy chitterings and clicks you hear from behind the door sound as if they were made by some large insect(s)."; break;
        default: sDescriptor = "You hear indistinct sounds and you cannot recognize what might be making them.";
    }
    return sDescriptor;
}

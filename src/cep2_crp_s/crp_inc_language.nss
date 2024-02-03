const string CharSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

int findcharindex (string Char)
{
int index = 0;
while (!(GetSubString(CharSet, index, 1) == Char))
    {
        index++;
    }
return index;
}


void Translate( string racial, string spoken, int offset, object PC)
{
//object oPC = GetLastSpeaker();
string speaktext;
int tmpi;
//int offset = 3;
int CharSetLen = GetStringLength(CharSet);
//string spoken = "Hey! What are you doing here?";
//string racial = "Orcish";
//SendMessageToPC(oPC, spoken);

int count;
int cindex;
for (count = 0; count < GetStringLength(spoken); count++)
    {
        if ((GetSubString(spoken, count, 1) == " ") || (GetSubString(spoken, count, 1) == ",")
            || (GetSubString(spoken, count, 1) == "!") || (GetSubString(spoken, count, 1) == "?")
            || (GetSubString(spoken, count, 1) == "'") || (GetSubString(spoken, count, 1) == ".")
            || (GetSubString(spoken, count, 1) == ";") || (GetSubString(spoken, count, 1) == ":"))
            {
                speaktext = speaktext + GetSubString(spoken, count, 1);
            }
            else
            {
                cindex = findcharindex(GetSubString(spoken, count, 1));
                if (cindex + offset > (GetStringLength(CharSet)-1))
                {
                    tmpi = GetStringLength(CharSet)-1; //get length of string - the null on the end
                    cindex = tmpi - cindex;
                    cindex = offset - cindex - 1;
                    speaktext = speaktext + GetSubString(CharSet, cindex, 1);
                }
                else
                {
                    speaktext = speaktext + GetSubString(CharSet, cindex + offset, 1);
                }
            }
    }

SpeakString(speaktext);
if (GetIsObjectValid(GetItemPossessedBy(PC, "hlslang_5")))
{
    SendMessageToPC(PC, "(Translated from " + racial + ") " + spoken);
}
else
{
    SendMessageToPC(PC, speaktext);
}

}

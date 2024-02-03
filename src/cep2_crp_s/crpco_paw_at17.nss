#include "crp_inc_listen"
#include "crp_inc_paw"
void main()
{
    //ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 0.5, 2.0);
    object oTrigger = GetLocalObject(OBJECT_SELF, "LISTEN_TRIGGER");
    if(GetIsObjectValid(oTrigger))
    {
        string sMessage = GetLocalString(oTrigger, "MESSAGE");
        SetCustomToken(888, sMessage);
        ActionPauseConversation();
        DelayCommand(0.5, DisplayText("Listening"));
        ActionDoCommand(SetCommandable(FALSE));
        DelayCommand(4.3, SetCommandable(TRUE));
        DelayCommand(4.5, ActionResumeConversation());
        DelayCommand(5.0, SetLocalInt(oTrigger, "DO_ONCE", 1));
    }
    else
    {
        SetCustomToken(888, "You listen closely, but hear nothing out of the ordinary");
        ActionPauseConversation();
        DelayCommand(0.5, DisplayText("Listening"));
        ActionDoCommand(SetCommandable(FALSE));
        DelayCommand(4.3, SetCommandable(TRUE));
        DelayCommand(4.5, ActionResumeConversation());
        Listen(OBJECT_SELF);
    }
}

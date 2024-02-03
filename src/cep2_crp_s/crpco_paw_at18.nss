#include "crp_inc_listen"
#include "crp_inc_paw"
void main()
{
    DelayCommand(0.5, DisplayText("Listening"));
    Listen(GetPCSpeaker());
//    DelayCommand(1.0, PlayAnimation(ANIMATION_LOOPING_LISTEN, 1.00, 4.5));
//    ActionDoCommand(SetCommandable(FALSE));
//    DelayCommand(4.3, SetCommandable(TRUE));

}

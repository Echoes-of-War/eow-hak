void main()
{
    PlaySound("as_cv_brickscrp2");
    object oPC = OBJECT_SELF;
    object oDrop = GetLocalObject(oPC, "PIT_DROP");
    int nDmg = GetLocalInt(oPC, "DROP_DAMAGE");
    PlayVoiceChat(VOICE_CHAT_PAIN2);
    effect effTouchupInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    PlayAnimation(ANIMATION_FIREFORGET_TAUNT, 2.5, 1.0);
    //ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM7, 0.5, 1.0);
    DelayCommand(0.7, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, effTouchupInvis, oPC, 3.00));
    //DelayCommand(0.7, ApplyEffectToObject(DURATION_TYPE_PERMANENT, effTouchupInvis, oPC));
    //ClearAllActions();
    SetCutsceneMode(oPC, TRUE);
    DelayCommand(2.0, FadeToBlack(oPC, FADE_SPEED_FAST));
    DelayCommand(2.5, ActionJumpToObject(oDrop));

    //location lLoc = GetLocation(oDrop);
    //effect eDrop = EffectDisappearAppear(lLoc);
    //DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrop, oPC, 3.5));

    //DelayCommand(3.00, AssignCommand(oPC, ActionDoCommand(DelayCommand(1.0, RemoveEffect(oPC, effTouchupInvis)))));
    DelayCommand(2.55, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 6.0));
    DelayCommand(5.5, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
    DelayCommand(5.5, SetCutsceneMode(oPC, FALSE));
    DelayCommand(5.6, SetCommandable(FALSE, oPC));
    effect eDamage = EffectDamage(nDmg, DAMAGE_TYPE_BLUDGEONING);
    DelayCommand(5.75, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
    DelayCommand(5.00, ActionDoCommand(DelayCommand(1.5, SetCommandable(TRUE, oPC))));
    //DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC));
}

integer listenHandle; 
list saved_gstate;

// Here we're trying to handle attachments on avatars. The case that
// additional avatars may be seated on those attachments, if that's
// even possible, is not addressed.
integer save_gstate(string gstate)
{
    integer link = llGetNumberOfPrims() > 1;
    integer end = link + llGetNumberOfPrims();
    saved_gstate = [];

    llOwnerSay("llGetNumberOfPrims returns " + (string) llGetNumberOfPrims());
    llOwnerSay("save_gstate " + (string) link + " " + (string) end);
    for(;link < end; ++link)//loop through all prims
    {
        if (gstate=="alpha")
        {
            list color_list =  llGetLinkPrimitiveParams(link, [PRIM_COLOR, ALL_SIDES]);
            llOwnerSay("save_gstate " + (string) link + " color_list " + (string) color_list);
            saved_gstate += color_list;
        }
        else if (gstate=="glow")
        {
            list glow_list =  llGetLinkPrimitiveParams(link, [PRIM_GLOW, ALL_SIDES]);
            llOwnerSay("save_gstate " + (string) link + " glow_list " + (string) glow_list);
            saved_gstate += glow_list;
        }
        else if (gstate=="shiny")
        {
            list state_list =  llGetLinkPrimitiveParams(link, [PRIM_BUMP_SHINY, ALL_SIDES]);
            llOwnerSay("save_gstate " + (string) link + " bump_shiny " + (string) state_list);
            saved_gstate += state_list;
        }
        else if (gstate=="bump")
        {
            list state_list =  llGetLinkPrimitiveParams(link, [PRIM_BUMP_SHINY, ALL_SIDES]);
            llOwnerSay("save_gstate " + (string) link + " bump_shiny " + (string) state_list);
            saved_gstate += state_list;
        }
        else if (gstate=="point_light")
        {
            // Note this is not per-face
            list state_list =  llGetLinkPrimitiveParams(link, [PRIM_POINT_LIGHT]);
            llOwnerSay("save_gstate " + (string) link + " point_light " + (string) state_list);
            saved_gstate += state_list;
        }
        else
        {
            llOwnerSay("unknown gstate " + gstate);
        }
    }
    return 0;
}   

integer restore_gstate(string gstate)
{
    integer start = llGetNumberOfPrims() > 1;
    integer end = start + llGetNumberOfPrims();
    integer link;
    integer i = 0;
    list restore_list = saved_gstate;
    for(link=start; link < end; ++link)//loop through all prims
    {
        llOwnerSay("link " + (string) link + " restore_gstate using " + (string) restore_list);
        integer face = 0;
        for (;face < llGetLinkNumberOfSides(link);++face)
        {
            if (gstate=="alpha")
            {
                vector color = llList2Vector(restore_list, 0);
                float alpha = llList2Float(restore_list, 1);
                llOwnerSay("restore link alpha " + (string) link + " face " + (string) face + " color " + (string) color + " alpha " + (string) alpha);
                restore_list = llDeleteSubList(restore_list, 0, 1);
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, color, alpha]);
            }
            else if (gstate=="glow")
            {
                llOwnerSay("restore glow");
                float glow = llList2Float(restore_list, 0);
                llOwnerSay("restore link glow " + (string) link + " face " + (string) face + " glow " + (string) glow);
                restore_list = llDeleteSubList(restore_list, 0, 0);
                llSetLinkPrimitiveParamsFast(link, [PRIM_GLOW, face, glow]);
            }
            else if (gstate=="shiny")
            {
                llOwnerSay("restore shiny");
                integer shiny = llList2Integer(restore_list, 0);
                integer bump = llList2Integer(restore_list, 1);
                restore_list = llDeleteSubList(restore_list, 0, 1);
                llSetLinkPrimitiveParamsFast(link, [PRIM_BUMP_SHINY, face, shiny, bump]);
            }
            else if (gstate=="bump")
            {
                llOwnerSay("restore bump");
                integer shiny = llList2Integer(restore_list, 0);
                integer bump = llList2Integer(restore_list, 1);
                restore_list = llDeleteSubList(restore_list, 0, 1);
                llSetLinkPrimitiveParamsFast(link, [PRIM_BUMP_SHINY, face, shiny, bump]);
            }
            else if (gstate=="point_light")
            {
                // Not per-face, so only do this once.
                if (face==0)
                {
                    list vals = llList2List(restore_list,0,4); 
                    restore_list = llDeleteSubList(restore_list, 0, 4);
                    llOwnerSay("restore point_light " + (string) vals);
                    list args = [PRIM_POINT_LIGHT] + vals;
                    llOwnerSay("args are " + (string) args);
                    llSetLinkPrimitiveParamsFast(link, args);
                }
            }
            else
            {
                llOwnerSay("unknown gstate " + gstate);
            }
        }
    }
    llOwnerSay("after restore, saved_gstate is " + (string) saved_gstate);

    return 0;
}

integer change_gstate(string gstate)
{
    integer start = llGetNumberOfPrims() > 1;
    integer end = start + llGetNumberOfPrims();
    integer link;
    integer i = 0;
    for(link=start; link < end; ++link)//loop through all prims
    {
        llOwnerSay("link " + (string) link + " change_gstate gstate " + gstate);
        integer face = 0;
        for (;face < llGetLinkNumberOfSides(link);++face)
        {
            if (gstate=="alpha")
            {
                vector color = <1,0,0>;
                float alpha = 0.5;
                llOwnerSay("alter link " + (string) link + " face " + (string) face + " color " + (string) color + " alpha " + (string) alpha);
                llSetLinkPrimitiveParamsFast(link, [PRIM_COLOR, face, color, alpha]);
            }
            else if (gstate=="glow")
            {
                float glow = 1.0;
                llOwnerSay("alter link " + (string) link + " face " + (string) face + " glow " + (string) glow);
                llSetLinkPrimitiveParamsFast(link, [PRIM_GLOW, face, glow]);
            }
            else if (gstate=="shiny")
            {
                integer shiny = PRIM_SHINY_HIGH;
                integer bump = PRIM_BUMP_NONE;
                llOwnerSay("alter link " + (string) link + " face " + (string) face + " shiny " + (string) shiny);
                llSetLinkPrimitiveParamsFast(link, [PRIM_BUMP_SHINY, face, shiny, bump]);
            }
            else if (gstate=="bump")
            {
                integer shiny = PRIM_SHINY_NONE;
                integer bump = PRIM_BUMP_BRICKS;
                llOwnerSay("alter link " + (string) link + " face " + (string) face + " bump " + (string) bump);
                llSetLinkPrimitiveParamsFast(link, [PRIM_BUMP_SHINY, face, shiny, bump]);
            }
            else if (gstate=="point_light")
            {
                if (face==0)
                {
                    llOwnerSay("alter link " + (string) link + " face " + (string) face + " point_light on");
                    llSetLinkPrimitiveParamsFast(link, [PRIM_POINT_LIGHT, 1, <0,1,0>, 1.0, 10.0, 0.5]);
                }
            }
            else
            {
                llOwnerSay("unknown gstate " + gstate);
            }
        }
   }
    return 0;
}

default
{
    state_entry()
    {
        llOwnerSay("listening");
        listenHandle = llListen(-777,"","","");  
    }

    listen(integer channel, string name, key id, string message)
    {
        llOwnerSay("listen func called");
        llOwnerSay("got message " + name + " " + (string) id + " " + message);
        list words = llParseString2List(message,[" "],[]);
        string gstate = llList2String(words,0);
        string action = llList2String(words,1);
        llOwnerSay("gstate " + gstate + " action " + action);
        if (action=="start")
        {
            save_gstate(gstate);
            change_gstate(gstate);
        }
        else if (action=="stop")
        {
            restore_gstate(gstate);
        }
    }
    
    touch_start(integer total_number)
    {
        llOwnerSay( "Touched.");
    }
}

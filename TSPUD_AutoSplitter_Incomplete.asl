state("The Stanley Parable Ultra Deluxe"){}

startup
{
    vars.Log = (Action<object>)(value => print(String.Concat("[The Stanley Parable Ultra Deluxe] ", value)));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
    vars.Unity.LoadSceneManager = true;
	
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var messageBox = MessageBox.Show(
			"The game is run in RTA w/o Loads as the main timing method.\n"
			+ "LiveSplit is currently set to show Real Time (RTA).\n"+
			+ "Would you like to set the timing method to RTA w/o Loads?",
			"LiveSplit | The Stanley Parable Ultra Deluxe", 
			MessageBoxButtons.YesNo, MessageBoxIcon.Question);
        if (messageBox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

onStart
{
	print("\nNew run started!\n----------------\n");
}

init
{
	//vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	//{
		// confident vars for classes to use
		//var ST = helper.GetClass("Assembly-CSharp", "Singleton`1");
		//var GM = helper.GetClass("Assembly-CSharp", "GameMaster", 1); // < 1 needed? should be
		//var SC = helper.GetClass("Assembly-CSharp", "StanleyController");
		//var MM = helper.GetClass("Assembly-CSharp", "MainMenu");
		
		// vars of interest
		// var CM = helper.GetClass("Assembly-CSharp", "ChoreoMaster");
		// var BC = helper.GetClass("Assembly-CSharp", "BucketController"); // class of interest: HASBUCKET
		// var FOC = helper.GetClass("Assembly-CSharp", "FigleyOverlayController"); // keeping track of figleys (if part of run)
		// var SE = helper.GetClass("Assembly-CSharp", "SimpleEvent"); // see this crop up a lot, making note of it
		
		// vars.Unity.Make<bool>(GM.Static, ST["_instance"], GM["ONMAINMENUORSETTINGS"]).Name = "OnMainMenu";
		// ^ to be used for start/onStart possibly to help run start - dependant on run if they do quit to menu's, etc - value changes recognised in Cheat Engine (.NET info), code not yet
		// vars.Unity.Make<int>(GM.Static, ST["_instance"], GM["PAUSEMENUACTIVE"]).Name = "PauseMenu";
		// ^ possible use for recognising in-game pausing - value changes recognised in Cheat Engine (.NET info), code not yet
		
		//return true;
	//});
	
	vars.Unity.Load(game);
}

update
{
    if (!vars.Unity.Loaded) return false;
	
    vars.Unity.Update();
	
	current.Scene = vars.Unity.Scenes.Active.Name;
	
	//logging to monitor change of output value of helper-made var (vars.Unity.Make<xxx>)
	//vars.Log(vars.Unity["OnMainMenu"].Current.ToString());
    
	// Logging Scene Changes
    if (old.Scene != current.Scene) vars.Log(String.Concat("Scene Change: ", vars.Unity.Scenes.Active.Index.ToString(), ": ", current.Scene));
}

start
{
	//Possibe start value, unsure if it will cause new start if going back to map1 after ending completed
	//tested, seems like it doesn't but more testing needed
	//return (current.Scene == "map1_UD_MASTER" && old.Scene == "LoadingScene_UD_MASTER");
}

split
{

}

onSplit
{
	//print("\nSplit\n-----\n");
}

isLoading
{
	// idea = as quitting out may be a situation, ability to pause IGT when game/state is inactive?
	return (current.Scene == "LoadingScene_UD_MASTER");
	// Will pausing to menu be utilised as load removal or not worth it?
	// return (vars.Unity["PauseMenu"].Current);
}

reset
{
	// if going back to main menu from in-game, it will automatically reset - depending on run if this is needed
	return (old.Scene == "LoadingScene_UD_MASTER" && current.Scene == "Menu_UD_MASTER");
}

onReset
{
	print("\nRESET\n-----\n");
}

exit
{
    vars.Unity.Reset();
}

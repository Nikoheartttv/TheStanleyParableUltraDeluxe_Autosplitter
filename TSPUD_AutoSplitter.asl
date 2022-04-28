state("The Stanley Parable Ultra Deluxe"){}

startup
{
	vars.Log = (Action<object>)(value => print(String.Concat("[The Stanley Parable Ultra Deluxe] ", value)));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	    vars.Unity.LoadSceneManager = true;
	
	vars.LoadingScenes = new List<string>()
	{
		"LoadingScene_UD_MASTER",
		"Menu_UD_MASTER",
	};
	
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var timingMessage = MessageBox.Show(
			"The game is run in RTA w/o Loads as the main timing method.\n"
			+ "LiveSplit is currently set to show Real Time (RTA).\n"
			+ "Would you like to set the timing method to RTA w/o Loads?",
			"LiveSplit | The Stanley Parable Ultra Deluxe", 
			MessageBoxButtons.YesNo, MessageBoxIcon.Question);
		if (timingMessage == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

onStart
{
	print("\nNew run started!\n----------------\n");
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var GM = helper.GetClass("Assembly-CSharp", "GameMaster");				
		vars.Unity.Make<bool>(GM.Static, GM["PAUSEMENUACTIVE"]).Name = "PauseMenu";
		
		return true;
	});
	
	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;
	
	vars.Unity.Update();
	
	current.Scene = vars.Unity.Scenes.Active.Name;
	    
	if (old.Scene != current.Scene) vars.Log(String.Concat("Scene Change: ", vars.Unity.Scenes.Active.Index.ToString(), ": ", current.Scene));
}

start
{
	return (current.Scene == "map1_UD_MASTER" && old.Scene == "LoadingScene_UD_MASTER");
}

split
{
	return (current.Scene == "map1_UD_MASTER" && old.Scene == "LoadingScene_UD_MASTER");
	return (current.Scene == "MemoryzonePartTwo_UD_MASTER" && old.Scene == "LoadingScene_UD_MASTER");
}

onSplit
{
	print("\nSplit\n-----\n");
}

isLoading
{
	if (!(vars.Unity["PauseMenu"].Current || vars.LoadingScenes.Contains(current.Scene))) 
	{
		return false;
	}
	return true;
}

onReset
{
	print("\nRESET\n-----\n");
}

exit
{
	timer.IsGameTimePaused = true;
	vars.Unity.Reset();
}

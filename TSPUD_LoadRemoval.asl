state("The Stanley Parable Ultra Deluxe"){}

startup
{
    vars.Log = (Action<object>)(value => print(String.Concat("[The Stanley Parable Ultra Deluxe] ", value)));
    vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
    vars.Unity.LoadSceneManager = true;
	
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var messageBox = MessageBox.Show(
			"The game is run in IGT (Time without Loads - Game Time).\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"Would you like to set the timing method to Game Time?",
			"LiveSplit | Dexter Stardust: Adventures in Outer Space", 
			MessageBoxButtons.YesNo, MessageBoxIcon.Question);
        if (messageBox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

init
{
	vars.Unity.Load(game);
}

update
{
    if (!vars.Unity.Loaded) return false;
	
    vars.Unity.Update();
	
	current.Scene = vars.Unity.Scenes.Active.Name;
	   
	// Logging Scene Changes
    if (old.Scene != current.Scene) vars.Log(String.Concat("Scene Change: ", vars.Unity.Scenes.Active.Index.ToString(), ": ", current.Scene));
}

isLoading
{
	// idea = as quitting out may be a situation, ability to pause IGT when game/state is inactive?
	return (current.Scene == "LoadingScene_UD_MASTER");
	// Will pausing to menu be utilised as load removal or not worth it?
	// return (vars.Unity["PauseMenu"].Current);
}

exit
{
    vars.Unity.Reset();
}

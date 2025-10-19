using Godot;
using GodotInk;
using System;

/// <summary>
/// Ink Manager - C# wrapper for GodotInk
/// Provides GDScript-compatible interface for Ink stories
/// </summary>
public partial class InkManager : Node
{
	private InkStory _story;
	private string _currentChapter = "";

	[Signal]
	public delegate void LineDisplayedEventHandler(string type, string speaker, string text);
	
	[Signal]
	public delegate void ChoicePresentedEventHandler(Godot.Collections.Array choices);
	
	[Signal]
	public delegate void ClueUnlockedEventHandler(string clueId);
	
	[Signal]
	public delegate void TrustChangedEventHandler(int amount);
	
	[Signal]
	public delegate void ChapterEndedEventHandler();

	public override void _Ready()
	{
		GD.Print("InkManager (C#) ready");
	}

	/// <summary>
	/// Load and start a chapter
	/// </summary>
	public bool LoadChapter(string chapterId)
	{
		_currentChapter = chapterId;
		string inkPath = $"res://ink/{chapterId}.ink";
		
		if (!ResourceLoader.Exists(inkPath))
		{
			GD.PushError($"Ink file not found: {inkPath}");
			return false;
		}
		
		// Load the InkStory resource
		var resource = GD.Load<InkStory>(inkPath);
		
		if (resource == null)
		{
			GD.PushError("Failed to load Ink resource");
			return false;
		}
		
		_story = resource;
		
		GD.Print($"Chapter loaded: {chapterId}");
		return true;
	}

	/// <summary>
	/// Continue the story
	/// </summary>
	public bool ContinueStory()
	{
		if (_story == null || !_story.CanContinue)
			return false;
		
		string line = _story.Continue();
		ProcessLine(line);
		
		// Check for choices
		if (_story.CurrentChoices.Count > 0)
		{
			var choices = new Godot.Collections.Array();
			foreach (var choice in _story.CurrentChoices)
			{
				choices.Add(choice.Text);
			}
			EmitSignal(SignalName.ChoicePresented, choices);
			return false;
		}
		
		return _story.CanContinue;
	}

	/// <summary>
	/// Make a choice
	/// </summary>
	public void MakeChoice(int choiceIndex)
	{
		if (_story == null || _story.CurrentChoices.Count == 0)
			return;
		
		_story.ChooseChoiceIndex(choiceIndex);
		ContinueStory();
	}

	/// <summary>
	/// Process a single line from Ink
	/// </summary>
	private void ProcessLine(string line)
	{
		line = line.Trim();
		
		if (string.IsNullOrEmpty(line))
			return;
		
		// Parse tags
		var tags = _story?.CurrentTags ?? new System.Collections.Generic.List<string>();
		string lineType = "narration";
		string speaker = "";
		
		foreach (string tag in tags)
		{
			if (tag.StartsWith("CHARACTER:"))
			{
				var parts = tag.Substring(10).Split('|');
				speaker = parts[0].Trim();
				lineType = "character";
			}
			else if (tag.StartsWith("THOUGHT"))
			{
				lineType = "thought";
			}
			else if (tag.StartsWith("CLUE_FOUND:"))
			{
				string clueId = tag.Substring(11).Trim();
				EmitSignal(SignalName.ClueUnlocked, clueId);
			}
		}
		
		// Emit the processed line
		EmitSignal(SignalName.LineDisplayed, lineType, speaker, line);
	}

	/// <summary>
	/// Get current story state
	/// </summary>
	public Godot.Collections.Dictionary GetStoryState()
	{
		if (_story == null)
			return new Godot.Collections.Dictionary();
		
		return new Godot.Collections.Dictionary
		{
			{ "can_continue", _story.CanContinue },
			{ "has_choices", _story.CurrentChoices.Count > 0 }
		};
	}
}

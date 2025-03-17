using Godot;
using System;
using System.IO.Ports;

public partial class arduinoHandler : Node
{
	private SerialPort serialPort;
	private bool handOnPlate = false;
	private bool refuelling;
	private double timer;
	private double timerReset = 2.5f; //after how much time in seconds the heat is turned up one step
	
	private double gracePeriod;
	private double gracePeriodReset = 0.3f; //time in seconds the pressure may be 0 before forfeit
	
	private int bikeSpeedMultiplier = 0;

	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		gracePeriod = gracePeriodReset;
		timer = timerReset;
		if(serialPort != null)
		{
			if (serialPort.IsOpen)
			{
				serialPort.Close();
			}
		}
		serialPort = new SerialPort();
		serialPort.DtrEnable = true;
		serialPort.RtsEnable = true;
		serialPort.PortName = "COM3"; //check if this is the case, otherwise change in device manager!
		serialPort.BaudRate = 9600; //needs to be the same in Arduino Code
		//serialPort.ReadTimeout = 1000; // Set timeout to 100 milliseconds or another appropriate value

		serialPort.Open();
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		
		if(!serialPort.IsOpen){
			GD.Print("Arduino not connected");
			return;
			}

		string serialMessage = serialPort.ReadLine();
		bikeSpeedMultiplier = GetValue(serialMessage, 1);
		int currentPressure = GetValue(serialMessage, 0);
		//GD.Print("Pressure: " + currentPressure);
		if(currentPressure >= 4){
			handOnPlate = true;
		}
		else
		{
			gracePeriod -= delta;
			if (gracePeriod <= 0)
			{
				handOnPlate = false;
				gracePeriod = gracePeriodReset;
			}
		}

		if (handOnPlate && refuelling){
			timer -= delta;
			if (timer <= 0){			
				serialPort.Write("1");
				var uiNode = GetNode("../UIScreen");
				uiNode.Call("increment_heat_label");
				//GD.Print("Heating up!");
				handOnPlate = false;
				timer = timerReset;
			}
		}
		else if (!handOnPlate)
		{
			ResetHeat();
			var score = GetNode("/root/Score");
			var result = score.Call("car_forfeit");
		}
	}
	
	public override void _ExitTree()
	{
		serialPort.Close();
	}

	public void SetRefuelling(bool isRefuelling)
	{
		//GD.Print("SetRefuelling is called with " , isRefuelling);
		refuelling = isRefuelling;
	}

	public int GetBikeSpeedMultiplier()
	{
		return bikeSpeedMultiplier;
	}
	
	public bool GetHandOnPlate()
	{
		return handOnPlate;
	}
	
	public void ResetHeat()
	{
		serialPort.Write("0");
	}

	int GetValue(string arduinoMessage, int index)
	{
		string[] temp = arduinoMessage.Split('|');
		string result = temp[index];
		if (result.Length != 0)
		{
			return result.ToInt();
		}
		return 0;
	}
}

using Godot;
using System;
using System.IO.Ports;

public partial class arduinoHandler : Node
{
	private SerialPort serialPort;
	private bool handOnPlate = false;
	private bool refuelling;
	private double timer;
	private double timerReset = 2;
	
	private float temperatureCounter = 0f;
	
	private int bikeSpeedMultiplier = 0;

	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
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
		serialPort.PortName = "COM6"; //check if this is the case, otherwise change in device manager!
		serialPort.BaudRate = 9600; //needs to be the same in Arduino Code
		//serialPort.ReadTimeout = 1000; // Set timeout to 100 milliseconds or another appropriate value

		serialPort.Open();
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		
		if(!serialPort.IsOpen) return;

		string serialMessage = serialPort.ReadLine();
		bikeSpeedMultiplier = GetValue(serialMessage, 1);
		int currentPressure = GetValue(serialMessage, 0);
		//GD.Print("Pressure: " + currentPressure);
		if(currentPressure >= 4){
			handOnPlate = true;
		}
		else
		{
			handOnPlate = false;
		}

		if (handOnPlate && refuelling){
			timer -= delta;
			if (timer <= 0){			
				serialPort.Write("1");
				temperatureCounter += 1;
				//GD.Print("Heating up!");
				handOnPlate = false;
				timer = timerReset;
			}
		}
		else if (!handOnPlate)
		{
			serialPort.Write("0");
			temperatureCounter = 0;
			var score = GetNode("/root/Score");
			var result = score.Call("car_forfeit");
		}
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

using Godot;
using System;
using System.IO.Ports;

public partial class arduinoHandler : Node
{
	private SerialPort serialPort;
	private bool handOnPlate = false;
	private bool refuelling;
	private double timer;
	private double timerReset = 3;
	
	private float temperatureCounter = 0f;
	
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
		serialPort.BaudRate = 9600;
		serialPort.Open();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if(!serialPort.IsOpen) return;
		
		string serialMessage = serialPort.ReadExisting();
		if(serialMessage.Length >= 1){
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
				handOnPlate = false;
				timer = timerReset;
			}
		}
		else if (!handOnPlate)
		{
			serialPort.Write("0");
			temperatureCounter = 0;
		}
	}

	public void SetRefuelling(bool isRefuelling)
	{
		//GD.Print("SetRefuelling is called with " , isRefuelling);
		refuelling = isRefuelling;
	}
}

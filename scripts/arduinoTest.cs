using Godot;
using System;
using System.IO.Ports;

public partial class arduinoTest : Node2D
{
	SerialPort serialPort;
	Label text;
	Label temperatureText;
	bool handOnPlate = false;
	double timer = 3;
	float temperatureCounter = 0f;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		text = GetNode<Label>("Label");
		temperatureText = GetNode<Label>("Label2");
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
			serialPort.PortName = "COM6";
			serialPort.BaudRate = 9600;
			serialPort.Open();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if(!serialPort.IsOpen) return;
		
		string serialMessage = serialPort.ReadExisting();
		if(serialMessage.Length >= 4){
			text.Text = "Hand ist drauf";
			handOnPlate = true;
		}
		else
		{
			handOnPlate = false;
		}

		if (handOnPlate){
			timer -= delta;
			if (timer <= 0){			
				temperatureText.Text = "Temperature rises " + temperatureCounter;
				serialPort.Write("1");
				temperatureCounter += 1;
				handOnPlate = false;
				timer = 3;
			}
		}
		else
		{
			text.Text = "You lose!";
			serialPort.Write("0");
			temperatureCounter = 0;
		}
	}
}

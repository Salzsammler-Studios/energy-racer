using Godot;
using System;
using System.IO.Ports;

public partial class arduinoTest : Node2D
{
	SerialPort serialPort;
	Label text;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		text = GetNode<Label>("Label");
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
			text.Text = "Now we're cooking with Arduino";
		}
		else
		{
			text.Text = "Hand is weg";
		}
	}
}

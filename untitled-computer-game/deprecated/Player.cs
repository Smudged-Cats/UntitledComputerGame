using Godot;
using System;

public partial class Player : Node2D
{

	private const float CAMERA_CHASE_SPEED = 3f;

	private Character _character;
	private Camera2D _camera;
	
	public override void _Ready()
	{
		_camera = GetNode<Camera2D>("Camera2D");
		_character = GetNode<Character>("Character");
		
		_camera.GlobalPosition = _character.GlobalPosition;
		GD.Print("Started player");
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 moveDir = GetMoveDir();
		MoveCharacter(moveDir);
		
		UpdateCameraPosition(delta);
		
	}
	
	public void UpdateCameraPosition(double delta)
	{
		if (_camera == null) return;
		_camera.GlobalPosition = _camera.GlobalPosition.Lerp(_character.GlobalPosition, CAMERA_CHASE_SPEED * (float)delta);
	}
	
	public void MoveCharacter(Vector2 dir)
	{
		if (_character == null) return;
		_character.SetMoveDir(dir);
	}
	
	private Vector2 GetMoveDir()
	{
		return Input.GetVector("move_left", "move_right", "move_up", "move_down");
	}
	
	
}

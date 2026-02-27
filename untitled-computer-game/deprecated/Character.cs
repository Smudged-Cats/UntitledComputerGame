using Godot;
using System;

public partial class Character : CharacterBody2D
{
	public const float SPEED = 150.0f;
	public const float ACCELERATION = 25.0f;
	public const float DECELLERATION = 25.0f;
	public Vector2 moveDir = Vector2.Zero;

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		Vector2 direction = moveDir;
		if (direction != Vector2.Zero)
		{
			velocity.X = Mathf.MoveToward(velocity.X, direction.X * SPEED, ACCELERATION);
			velocity.Y = Mathf.MoveToward(velocity.Y, direction.Y * SPEED * 0.5f, ACCELERATION);
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, DECELLERATION);
			velocity.Y = Mathf.MoveToward(Velocity.Y, 0, DECELLERATION);
		}

		Velocity = velocity;
		MoveAndSlide();
	}
	
	public void SetMoveDir(Vector2 dir) { moveDir = dir; }
}

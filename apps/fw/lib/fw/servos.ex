defmodule Fw.Servos do
  @right_servo_gpio 4
  @left_servo_gpio 17

  def stop do
    Pigpiox.GPIO.set_servo_pulsewidth(@right_servo_gpio, 0)
    Pigpiox.GPIO.set_servo_pulsewidth(@left_servo_gpio, 0)
  end

  def forward do
    Pigpiox.GPIO.set_servo_pulsewidth(@right_servo_gpio, 1000)
    Pigpiox.GPIO.set_servo_pulsewidth(@left_servo_gpio, 2000)
  end

  def backward do
    Pigpiox.GPIO.set_servo_pulsewidth(@right_servo_gpio, 2000)
    Pigpiox.GPIO.set_servo_pulsewidth(@left_servo_gpio, 1000)
  end

  def right do
    Pigpiox.GPIO.set_servo_pulsewidth(@right_servo_gpio, 2000)
    Pigpiox.GPIO.set_servo_pulsewidth(@left_servo_gpio, 2000)
  end

  def left do
    Pigpiox.GPIO.set_servo_pulsewidth(@left_servo_gpio, 1000)
    Pigpiox.GPIO.set_servo_pulsewidth(@right_servo_gpio, 1000)
  end

  defmodule Program do
    def run(program) do
      spawn_link fn ->
        execute(program)
      end
    end

    def stop(program) do
      send program, :stop
    end

    defp execute([]), do: :done
    defp execute([:left|rest]) do
      Fw.Servos.left
      execute(rest)
    end
    defp execute([:right|rest]) do
      Fw.Servos.right
      execute(rest)
    end
    defp execute([:forward|rest]) do
      Fw.Servos.forward
      execute(rest)
    end
    defp execute([:stop|rest]) do
      Fw.Servos.stop
      execute(rest)
    end
    defp execute([{:wait, time}|rest]) do
      Process.send_after(self(), :resume, time)

      receive do
        :resume -> execute(rest)
        :stop -> :done
      end
    end
  end
end

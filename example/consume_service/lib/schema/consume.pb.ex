defmodule ConsumeService.Echo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t(),
          echo_target: String.t()
        }
  defstruct [:message, :echo_target]

  field :message, 1, type: :string
  field :echo_target, 2, type: :string
end

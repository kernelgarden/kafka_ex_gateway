defmodule Common.Message do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          meta: Common.Message.Meta.t(),
          payload: String.t()
        }
  defstruct [:meta, :payload]

  field(:meta, 1, type: Common.Message.Meta)
  field(:payload, 2, type: :string)
end

defmodule Common.Message.Meta do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer,
          sender: String.t(),
          receiver: String.t(),
          command: String.t(),
          timestamp: String.t()
        }
  defstruct [:id, :sender, :receiver, :command, :timestamp]

  field(:id, 1, type: :int32)
  field(:sender, 2, type: :string)
  field(:receiver, 3, type: :string)
  field(:command, 4, type: :string)
  field(:timestamp, 5, type: :string)
end

defmodule TestCommand.Meta do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer,
          sender: String.t(),
          receiver: String.t()
        }
  defstruct [:id, :sender, :receiver]

  field :id, 1, type: :int32
  field :sender, 2, type: :string
  field :receiver, 3, type: :string
end

defmodule TestCommand.TestRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          meta: TestCommand.Meta.t(),
          message: String.t()
        }
  defstruct [:meta, :message]

  field :meta, 1, type: TestCommand.Meta
  field :message, 2, type: :string
end

defmodule TestCommand.TestResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          meta: TestCommand.Meta.t(),
          message: String.t()
        }
  defstruct [:meta, :message]

  field :meta, 1, type: TestCommand.Meta
  field :message, 2, type: :string
end

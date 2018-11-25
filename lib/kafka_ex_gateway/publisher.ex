defmodule KafkaExGateway.Publisher do
  require Logger

  # TODO: to adopt compression & partition selection

  def produce(topic_name, command, payload) do
    meta =
      Common.Message.Meta.new(
        # id: 1
        sender:
          "#{Application.get_env(:kafka_ex_gateway, :service_name)}_#{
            Application.get_env(:kafka_ex_gateway, :service_id)
          }",
        receiver: "#{topic_name}",
        command: command,
        timestamp: to_string(DateTime.to_unix(DateTime.utc_now()))
      )

    message = Common.Message.new(meta: meta, payload: payload)

    request = %KafkaEx.Protocol.Produce.Request{
      topic: topic_name,
      partition: 0,
      required_acks: 1,
      messages: [
        %KafkaEx.Protocol.Produce.Message{
          value: Common.Message.encode(message)
        }
      ]
    }

    KafkaEx.produce(request)
  end
end

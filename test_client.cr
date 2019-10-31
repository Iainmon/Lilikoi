require "http/web_socket"

sending_data = File.read("./request_example.json")

ws = HTTP::WebSocket.new(URI.parse("ws://localhost:3000/lilikoi"))

ws.on_message do |message|
    puts message.to_s
    ws.send sending_data.to_s
end

ws.on_pong do |message|
    ws.send sending_data.to_s
end

ws.ping

ws.run

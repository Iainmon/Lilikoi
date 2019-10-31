require "json"
require "./print.cr"
require "./lilikoi/**"
require "kemal"

include Lilikoi

vine_branches = Vine.branches_from_schema_file "./config/schema.json"

vine = Vine.new vine_branches

new_user_values = {
    "username" => "iainmoncrief",
    "email" => "exampleemail@example.com"
}
vine.create("users", new_user_values)

ws "/lilikoi" do |socket|

    socket.on_message do |message|

        fruit = Fruit.new message.to_s
        fruit.run vine
        socket.send(fruit.respond)

    end

    socket.on_close do |_|
        puts "Closing socket: #{socket}"
    end

end

Kemal.run
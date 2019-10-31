require "json"
require "./print.cr"
require "./lilikoi/**"
require "./database_test.cr"

module Lilikoi

    VERSION = "0.1.0"

    fruit_options = File.read("./request_example.json")

    vine = create_populated_vine_database("./config/schema.json")

    fruit = Fruit.new fruit_options
    
    fruit.run(vine)

    print("Example query response:")
    print(fruit.respond)

end
